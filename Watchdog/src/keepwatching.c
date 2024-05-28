/*
    Name: Aya
    Project: WatchDog
    Reviewer: ---
    Date: 05/01/2024
*/
/****************************** Libraries *************************************/
#define _POSIX_SOURCE
#define _POSIX_C_SOURCE 200112L
#include <stdio.h>  /* printf, perror */
#include <stdlib.h> /* exit, abort */
#include <assert.h> /* assert */
#include <signal.h> /* sigaction, kill, SIGUSR1, SIGUSR2 */
#include <unistd.h> /* sleep */
#include <sys/wait.h> /* pid_t */
#include <string.h>
#include <pthread.h>


#include "keepwatching.h"
#include "./../include/sched.h"

/******************************* Definitions **********************************/
typedef struct info
{
    char** argv;
    size_t interval;
    size_t max_failure_num;
    pid_t other_pid;
    sched_t* scheduler;
}info_ty;

/* define global counter */
volatile size_t g_counter = 0;
/* define global flags signal */
int g_sig2_has_recieved = 0;

/*********************** Helper Functions Declarations ************************/
/* function that creates and inits info struct */
static info_ty* CreateInfoIMP(char *argv[], pid_t other_pid, size_t interval, size_t max_failure_num);
/* functionn that initializes the scheduler that is in the info */
static int InitSchedIMP(info_ty *info);
/* function that registers handlers */
static int RegisterHandlersIMP();
/* function that unmasks SIGUSR1 and SIGUSR2 */
static int UnMaskSignalIMP();

/********************* Handlers Functions Declarations ************************/
/* signal handler for SIGUSR1 */
static void SignalHandler1(int signum);
/* signal handler for SIGUSR2 */
static void SignalHandler2(int signum);

/*********************** Tasks Functions Declarations ************************/
/* function that sends signal to the dest process */
static int SendSignalIMP(info_ty *info);
/* function that checks the counnter of the process */
static int CheckCounterIMP(info_ty *info);


static int ResusIMP(info_ty *info);

/******************************************************************************/
/************************  API's Functions  ***********************************/
/******************************************************************************/
int KeepWatching(char *argv[], pid_t other_pid, size_t interval, size_t max_failure_num)
{
    info_ty *info = NULL;
    int sched_status = SUCCESS;
    /* assert */

    /* prepare the info struct */
    info = CreateInfoIMP(argv, other_pid, interval, max_failure_num);
    if(NULL == info)
    {
        return FAILURE;
    }

    /* initialize global counter = 0 */
    __atomic_store_n(&g_counter, 0, __ATOMIC_SEQ_CST);

    /* register handlers - handle failure */
    if(FAILURE == RegisterHandlersIMP())
    {
        fprintf(stderr, "failed to register handler \n");
        SchedDestroy(info->scheduler);
        free(info);
        return FAILURE;
    }

    /* cancel mask - handle failure */
    if(FAILURE == UnMaskSignalIMP())
    {
        fprintf(stderr, "failed to unmask \n");
        SchedDestroy(info->scheduler);
        free(info);
        return FAILURE;
    }

    /* init scheduler - handle failure */
    if(FAILURE == InitSchedIMP(info))
    {
        SchedDestroy(info->scheduler);
        free(info);
        return FAILURE;
    }

    sched_status = SchedRun(info->scheduler); 
    /* run scheduler - handle failure */
    if(FAILURE == sched_status)
    {
        SchedDestroy(info->scheduler);
        free(info);
        return FAILURE;
    }
    /* assert scheduler stopped */
    assert(STOPPED == sched_status);
    
    /* Destroy resources - scheduler */
    SchedDestroy(info->scheduler);
    free(info);

    /* return SUCCESS */
    return SUCCESS;
}

/******************************************************************************/
/************************ Helper Functions  ***********************************/
/******************************************************************************/
static info_ty* CreateInfoIMP(char *argv[], pid_t other_pid, size_t interval, size_t max_failure_num)
{
    info_ty *info = (info_ty*)malloc(sizeof(info_ty));

    if(NULL == info)
    {
        return NULL;
    }

    info->scheduler = SchedCreate();
    if(NULL == info->scheduler)
    {
        free(info);
        info = NULL;
        return NULL;
    }

    info->argv = argv;
    info->interval = interval;
    info->max_failure_num = max_failure_num;
    info->other_pid = other_pid;

    return info;
}

static int RegisterHandlersIMP()
{
    struct sigaction sig_action1;
    struct sigaction sig_action2;

    sig_action1.sa_handler = SignalHandler1;
    if(0 != sigemptyset(&sig_action1.sa_mask))
    {
        perror("failed to sigemptyset\n");
        return FAILURE;
    }
    
    if(-1 == sigaction(SIGUSR1, &sig_action1, NULL))
    {
        return FAILURE;
    }

    sig_action2.sa_handler = SignalHandler2;
    if(0 != sigemptyset(&sig_action2.sa_mask))
    {
        perror("failed to sigemptyset\n");
        return FAILURE;
    }

    if(-1 == sigaction(SIGUSR2, &sig_action2, NULL))
    {
        return FAILURE;
    }

    return SUCCESS;
}

static int UnMaskSignalIMP()
{
    sigset_t mask;
    
    if(0 != sigemptyset(&mask))
    {
        perror("failed to sigemptyset\n");
        return FAILURE;
    }
    if(0 != sigaddset(&mask, SIGUSR1))
    {
        perror("failed to set SIGUSR1 signal\n");
        return FAILURE;
    } 
    if(0 != sigaddset(&mask, SIGUSR2))
    {
        perror("failed to set SIGUSR2 signal\n");
        return FAILURE;
    } 
    if(0 != pthread_sigmask(SIG_UNBLOCK, &mask, NULL))
    {
        perror("failed to unmask\n");
        return FAILURE;
    }

    return SUCCESS;
}

static int InitSchedIMP(info_ty *info)
{
    time_t baseTime = time(NULL);
    time_t convertedTime = baseTime + (time_t)info->interval;
    uid_ty returned_uid;

    returned_uid = AddTask(info->scheduler, (sched_operation_func)SendSignalIMP, info, convertedTime, NULL, NULL);  
    if(UIDIsSame(returned_uid, bad_uid))
    {
        fprintf(stderr, "failed to add task");
        return FAILURE;
    }
    returned_uid = AddTask(info->scheduler, (sched_operation_func)CheckCounterIMP, info, convertedTime, NULL, NULL);  
    if(UIDIsSame(returned_uid, bad_uid))
    {
        fprintf(stderr, "failed to add task");
        return FAILURE;
    }

    return SUCCESS;
}

/******************************************************************************/
/********************** handlers Functions  ***********************************/
/******************************************************************************/
static void SignalHandler1(int signum)
{
    /* assert */
    assert(SIGUSR1 == signum);

    /* reset global counter */
    __atomic_store_n(&g_counter, 0, __ATOMIC_SEQ_CST);
}

static void SignalHandler2(int signum)
{
    /* assert */
    assert(SIGUSR2 == signum);

    /* set on the global flag */
    __atomic_store_n(&g_sig2_has_recieved, 1, __ATOMIC_SEQ_CST);
}

/******************************************************************************/
/************************ Tasks Functions  ************************************/
/******************************************************************************/
static int SendSignalIMP(info_ty *info)
{
    /* assert */
    assert(NULL != info);
     printf("this is %s and its pid is %d\n", info->argv[0], info->other_pid);
    /* send SIGUSR1 to the other process */
    kill(info->other_pid, SIGUSR1);
    /* increase global counter */
    __atomic_fetch_add(&g_counter, 1, __ATOMIC_SEQ_CST);

    /* return TRUE for rescheduling */
    return TRUE;
}

static int CheckCounterIMP(info_ty *info)
{
    /* assert */
    assert(NULL != info);

    /* if the sigusr2 flag is set on */
    if(1 == g_sig2_has_recieved)
    {
        /* if parent */
        if(getppid() != info->other_pid)
        {
            /* kill child */
            if(0 != kill(info->other_pid, SIGUSR2))
            {
                perror("failed to kill process\n");
                return FALSE;
            }
            /* wait for child */
            waitpid(info->other_pid, 0, 0);
        }

        /* stop scheduler */
        SchedStop(info->scheduler);
        return FALSE;
    }

    /* check counter - if the limit reached */
    if(g_counter >= info->max_failure_num)
    {
        /* kill other pid */
        kill(info->other_pid, SIGTERM);

        /* resus the other pid */
        if(FAILURE == ResusIMP(info))
        {
            return FALSE;
        } 

        __atomic_store_n(&g_counter, 0, __ATOMIC_SEQ_CST);
    }

    /* return TRUE for rescheduling */
    return TRUE;
}

static int ResusIMP(info_ty *info)
{
    pid_t child_pid;

    /* If I'm parent (application) */
    if(getppid() != info->other_pid)
    {
        /* fork */
        child_pid = fork();

        /* handle failure */
        if (-1 == child_pid) 
        {
            perror("failed in fork\n");
            return FAILURE;
        } 
        /* child process */
        if(0 == child_pid)
        {
            /* execv watchdog process */
            execv(info->argv[0], info->argv);
        }
        else
        {
            info->other_pid = child_pid;
        }
    }
    /* if I'm child (watchdog process) */
    else 
    {
        /* execv application */
        execv(info->argv[0], info->argv);
    }

    return SUCCESS;
}
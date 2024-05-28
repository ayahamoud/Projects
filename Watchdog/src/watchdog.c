/*
    Name: Aya
    Project: WatchDog
    Reviewer: ---
    Date: 05/01/2024
*/
/****************************** Libraries *************************************/
#define _POSIX_C_SOURCE 200112L
#include <stdio.h>     /*  */
#include <signal.h>    /*  */
#include <sys/types.h> /*  */
#include <unistd.h>    /*  */
#include <semaphore.h> /*  */
#include <stdlib.h>    /*  */
#include <sys/wait.h>  /*  */
#include <pthread.h>   /*  */
#include <fcntl.h>     /*  */
#include <errno.h>     /*  */
#include <assert.h>    /*  */
#include <errno.h>     /*  */
#include <string.h>    /*  */

#include "watchdog.h"
#include "keepwatching.h"

/******************************************************************************/
typedef struct info
{
    char** argv;
    size_t interval;
    size_t max_failure_num;
    pid_t other_pid;
}info_ty;

/******************************************************************************/
pthread_t g_wd_thread = 0;

/******************************************************************************/
/*  */
static void* ThreadFuncIMP(info_ty* info);

/*  */
static char **CreateCustArgIMP(char *argv[], int argc, size_t interval, size_t max_failure_num);

/*  */
static int SetMaskIMP();

/*  */
static char *CreateString(size_t value);

/******************************************************************************/
/************************  API's Functions  ***********************************/
/******************************************************************************/
int MakeMeImmortal(char* argv[], int argc, size_t interval, size_t max_failure_num )
{
    char **custom_arguments = NULL;
    pid_t child_pid = 0;
    struct timespec timeout = {0};
    sem_t *sem = {0};
    info_ty* info = {0};

    /* assert */
    assert(NULL != argv);
    assert(1 <= argc);

    /* create struct */
    info = (info_ty*)malloc(sizeof(info_ty));
    if(NULL == info)
    {
        return FAILURE;
    }

    /* prepare custom arguments - "./watchdogprocess.out, interval, max_failure" */
    custom_arguments = CreateCustArgIMP(argv, argc, interval, max_failure_num);

    /* create named semaphore */
    sem = sem_open("mmi_sem", O_CREAT, 0777, 0);
    /* handle failure */
    if (SEM_FAILED == sem && errno != EEXIST)
    {
        perror("failed to open semaphore\n");
        return FAILURE;
    }

    /* init struct timespec */
    /* handle failure */
    if (-1 == clock_gettime(CLOCK_REALTIME, &timeout))
    {
        perror("clock_gettime failed");
        return FAILURE;
    }
    timeout.tv_sec += 3;

    /* set mask to ignore SIGUSR1 SIGUSR2 */
    /* handle failure */
    if (FAILURE == SetMaskIMP())
    {
        return FAILURE;
    }

    /* fork */
    child_pid = fork();
    /* handle failure */
    if (-1 == child_pid)
    {
        perror("failed in fork\n");
        return FAILURE;
    }
    /* if child */
    if (0 == child_pid)
    {
        /* execv watchdog process */
        execv(custom_arguments[0], custom_arguments);
        /* handle failure */
    }
    
    /* init info struct */
    info->argv = custom_arguments;
    info->interval = interval;
    info->max_failure_num = max_failure_num;
    info->other_pid = child_pid;

    /* trywait sempahore - decrease 1 */
    if (-1 == sem_timedwait(sem, &timeout))
    {
        /* time reached? */
        /* handle failure */
        if (errno == ETIMEDOUT)
        {
            perror("semaphore timed out\n");
            return FAILURE;
        }
        perror("semaphore not incremented\n");
        return FAILURE;
    }

    /* close semaphore */
    if (-1 == sem_close(sem))
    {
        /* handle failure */
        perror("failed to close semaphore");
        return FAILURE;
    }

    /* ceate thread - send info struct as argument */
    if (0 != pthread_create(&g_wd_thread, NULL, (void*(*)(void*))ThreadFuncIMP, info))
    {
        /* handle failure */
        return FAILURE;
    }
    
    /* return */
    return SUCCESS;
}

int DoNotResuscitate()
{
    /* send SIGUSR2 to the application */
    if (0 != kill(getpid(), SIGUSR2))
    {
        perror("failed to kill process\n");
        return FAILURE;
    }
    /* unlink semaphore */
    if (0 != sem_unlink("mmi_sem"))
    {
        perror("failed to unlike semaphore\n");
        return FAILURE;
    }
    /* join thread */
    if (0 != pthread_join(g_wd_thread, NULL))
    {
        fprintf(stderr, "failed to join thread\n");
        return FAILURE;
    }

    return SUCCESS;
}
/******************************************************************************/
/***********************  Helper Functions  ***********************************/
/******************************************************************************/
static void* ThreadFuncIMP(info_ty* info)
{
    /* assert */
    assert(NULL != info);

    /* call keep watching */
    KeepWatching(info->argv, info->other_pid, info->interval, info->max_failure_num);

    /* free info struct */
    free(info);
    info = NULL;

    return NULL;
}

static char **CreateCustArgIMP(char *argv[], int argc, size_t interval, size_t max_failure_num)
{
    char **arguments = NULL;
    int i = 0;

    arguments = (char **)malloc(sizeof(char*) * (argc + 3 + 1 /*for NULL*/));
    arguments[0] = "./wd_process.out";
    arguments[1] = CreateString(interval);
    arguments[2] = CreateString(max_failure_num);
    for (i = 0; i < argc; ++i)
    {
        arguments[3 + i] = argv[i];
    }
    arguments[3 + i] = NULL;

    return arguments;
}

static char *CreateString(size_t value)
{
    char *string = (char *)malloc(sizeof(char) * 20);
    if (NULL == string)
    {
        return NULL;
    }

    sprintf(string, "%ld", value);

    return string;
}

static int SetMaskIMP()
{
    sigset_t mask;

    if (0 != sigemptyset(&mask))
    {
        perror("failed to sigemptyset\n");
        return FAILURE;
    }

    if (0 != sigaddset(&mask, SIGUSR1))
    {
        perror("failed to set SIGUSR1 signal\n");
        return FAILURE;
    }

    if (0 != sigaddset(&mask, SIGUSR2))
    {
        perror("failed to set SIGUSR2 signal\n");
        return FAILURE;
    }

    if (0 != pthread_sigmask(SIG_BLOCK, &mask, NULL))
    {
        perror("Failed to pthread_sigmask\n");
        return FAILURE;
    }

    return SUCCESS;
}


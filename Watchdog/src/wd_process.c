/*
    Name: Aya
    Project: WatchDog
    Reviewer: ---
    Date: 05/01/2024
*/
/****************************** Libraries *************************************/
#define _POSIX_SOURCE
#define _POSIX_C_SOURCE 200112L
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <semaphore.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>
#include <pthread.h>
#include <fcntl.h>

#include "./../include/keepwatching.h"

int main (int argc, char *argv[])
{
    sem_t *sem = {0};
    /* assert */

    (void)argc;
    
    /* open named semaphore */
    sem = sem_open("mmi_sem", O_CREAT);
        /* handle failure */
    /* increase semaphore */
    sem_post(sem);
        /* handle failure */
    /* close semaphore - handle failure */
    if(-1 == sem_close(sem))
    {
        perror("failed to close semaphore");
        return FAILURE;
    }

    /* call keepwatching - get the arguments from argv */
    /* return status of keepwtching */
    return KeepWatching(&argv[3], getppid(), (size_t)atoi(argv[1]), (size_t)atoi(argv[2]));
}
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main() 
{
    pid_t watchdog_pid = getpid(); 
    pid_t child_pid;
    char *args[50] = {"./testing/test_env.out", NULL}; 
    int status;
    char *wd_pid = (char*)malloc(sizeof(char) * 100);

    char pid_str[20];
    snprintf(pid_str, sizeof(pid_str), "%d", watchdog_pid);

    if (setenv("TEST_WD_PID", pid_str, 1) != 0) {
        perror("setenv");
        exit(EXIT_FAILURE);
    }

    printf("From set_env, TEST_WD_PID set to %s\n", pid_str);
    printf("From set_env, TEST_WD_PID set to %s\n", getenv("TEST_WD_PID"));


    child_pid = fork();
    if (-1 == child_pid) 
    {
        perror("fork");
        exit(EXIT_FAILURE);
    } 
    else if (0 == child_pid) 
    {
        if (-1 == execvp("./testing/test_env.out", args)) 
        {
            perror("execvp");
            exit(EXIT_FAILURE);
        }
    } 


    return 0;
}
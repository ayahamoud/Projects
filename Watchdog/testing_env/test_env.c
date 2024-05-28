#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <string.h>

int main() 
{
    if (NULL != getenv("TEST_WD_PID")) 
    {
        printf("Value of WD_PID: %s\n", getenv("TEST_WD_PID"));
    } 
    else 
    {
        printf("WD_PID not found in the environment\n");
    }
    return 0;
}
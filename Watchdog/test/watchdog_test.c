/*Name: Aya
  Project: 
  Reviewer: 
  Date: 
*/
/****************************** INCLUDES **************************************/
#include <stdio.h> /* fprintf */
#include <semaphore.h>
#include <unistd.h>

#include "watchdog.h"

enum{SUCCESS = 0, FAILURE};
enum{NUM_OF_PRINTS = 10};

/******************************************************************************/
/* int main(int argc, char *argv[])
{
    size_t i = 0;

    for (i = 0; i < NUM_OF_PRINTS; ++i)
    {
        fprintf(stdout, "start!\n");
    }

    if(FAILURE == MakeMeImmortal(argv, argc, 2, 5))
    {
        fprintf(stderr,"MakeMeImmortal failed\n");
        return FAILURE;
    }

    for (i = 0; i < NUM_OF_PRINTS; ++i)
    {
        fprintf(stdout, "end!\n");
    }


    sleep(20);
    DoNotResuscitate();

    return SUCCESS;
} */


int main(int argc, char *argv[])
{  
    int status = 0;
    /* size_t count = 0; */

    /* while(2 > count)
    {
        sleep(1);
        printf("Hello\n");
        ++count;
    } */

    printf("Hello\n");
    printf("app start\n");

    status = MakeMeImmortal(argv, argc, 2, 5);

    if(FAILURE == status)
    {
        fprintf(stderr, "MMI failed !!\n");
    }

    printf("Now start waiting ....\n");
    sleep(10);

    DoNotResuscitate();

    /* while(5 > count)
    {
        sleep(2);
        printf("End\n");
        ++count;
    } */

    printf("End\n");
    return SUCCESS;

}



/******************************************************************************/

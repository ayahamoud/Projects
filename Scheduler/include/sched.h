/******************************************************************************/
/*
  Name: Aya
  Project: Scheduler
  Reviewer: Idan
  Date: 10/09/23
  Version: 1.0
  
  Overview: Implementation of a scheduler.
*/

#ifndef __ILRD_SCHEDULER_H__
#define __ILRD_SCHEDULER_H__
/******************************** Libraries  **********************************/

#include <stddef.h>    /*size_t*/
#include <sys/types.h> /*pid_t, time_t*/
 #include <time.h>     /*time_t*/
#include "Uid.h"
#include "task.h"   


/******************************** Definitions  ********************************/

typedef struct sched sched_t;

typedef enum {SUCCESS = 0, STOPPED, FAILURE} sched_status_t;
typedef enum {ONHOLD = 0, RUNNING} sched_run_status;

typedef int (*sched_operation_func)(void*);
typedef void (*sched_clean_func)(void*);
/*********************** Queue API Declerations  ******************************/

/*Function that creates a scheduler.  
  Arguments: void.  
  Return value: pointer to a scheduler.
  Complexity: O(1). 
  Undefined B.:*/
sched_t *SchedCreate(void);

/*Function that destroys a scheduler.

  Arguments: 'sched' - pointer to scheduler.

  Return value: None.

  Complexity: O(n). 

  Undefined B.: NULL ptr of scheduler */
void SchedDestroy(sched_t *sched);

/*Function that adds a task to the scheduler. The return value of 
  sched_func is responsible for rescheduling: if TRUE: task will be
   reschedule, except for when the task conducts clear operation.
  Arguments:  'sched' - pointer to scheduler.
              'time_to_exec' - Task's Time To Run. 
              'op_func' - task's operation function
              'op_params' - operation function-related parameters
              'cleanup_func' - task's optional clenaup operation for tasks
                               that allocate memory.
              'cleanup_params' - should be sent as an array of pointers to be
                                 freed. arr[0] should contain number of params.
                                 If Cleanup Function isn't available, freeing of the params won't be attempted.
  Return value: pointer to newly generated Task. On Error, returns NULL.
  Complexity: O(n).
  Undefined B.: NULL ptr of scheduler, NULL time_to_exec
                NULL functions & params delivered by user 
                Memory leaks unhandled by user logics prior to calling Destroy*/
uid_ty AddTask(sched_t *sched, sched_operation_func sched_func, 
  void *op_param ,time_t time_to_run, sched_clean_func clean_func, 
    void *clean_params);

/*Function that removes a task from the scheduler by a uid identifier.
  Arguments: 'sched' - pointer to scheduler,
             'uid' - unique identifier for the task.
  Return value: N.A.
  Complexity: O(1).
  Undefined B.: NULL pointer to scheduler, invalid uid.*/
void RemoveTask(sched_t *sched, uid_ty uid);

/*Function that Sets the scheduler to 'Run',
            Queueud tasks are being executed by priority.
  Arguments: 'sched' - pointer to scheduler,
  Return value: when queue is empty, returns SUCCESS\STOPPED,
                On Error, returns FAILURE.  
  Complexity: O(n*Operation Functions).
  Undefined B.: NULL pointer to scheduler,
                Calling to Run from within a running schedule*/
int SchedRun(sched_t *sched);

/*Function that Sets the scheduler to 'Stop',
            current task is first to be completed.
  Arguments: 'sched' - pointer to scheduler,
  Return value: N.A.
  Complexity: O(1).
  Undefined B.: NULL pointer to scheduler*/
void SchedStop(sched_t *sched);

/*Function that returns size of the scheduler.
  Arguments: 'sched' - pointer to scheduler,
  Return value: size of scheduler queue; . Running task is counted.
  Complexity: O(n).
  Undefined B.: NULL pointer to scheduler*/
size_t SchedSize(const sched_t *sched);

/*Function that returns if scheduler is empty.
  Arguments: 'sched' - pointer to scheduler.
  Return value: if empty = TRUE, othewise = FALSE. Running task is taken into consideration.
  Complexity: O(1).
  Undefined B.: NULL pointer to scheduler*/
int SchedIsEmpty(const sched_t *sched);

/*Function that clear all the elements in the scheduler.
  Arguments: 'sched' - pointer to scheduler.
  Return value: NA.
  Complexity: O(n).
  Undefined B.: NULL pointer to scheduler*/
void SchedClear(sched_t *sched);


#endif /*(__SCHEDULER_H__)*/
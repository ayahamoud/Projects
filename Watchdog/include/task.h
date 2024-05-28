/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet #task
  Reviewer: ???
  Date: 06/09/23
  Version: 1.0
  
  Overview: Implementation of a Task Manager.
*/

#ifndef __ILRD_TASK_H__
#define __ILRD_TASK_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_t*/
#include <sys/types.h> /*pid_t, time_t*/
#include "Uid.h"  /*uid_t*/

/******************************** Definitions  ********************************/

typedef struct task task_t;
/*typedef enum {FALSE = 0, TRUE} boolean_t;*/
typedef enum {UNSCHEDULE = 0, RESCHEDULE} status_t;

typedef int (*task_operation_t)(void*);
typedef int (*task_is_match_t)(const void*, const void*);
typedef int (*task_compare_t)(const void*, const void*);
typedef void (*task_cleanup_t)(void*);

/*********************** Task API Declerations  ******************************/

/*
  Function that creates a Task. By default, interval remembers original interval between creation & execuition time. If change is needed, use a self operation-func() to update task's self interval.
  Arguments:  'time_to_exec' - task's excecution time (relative to epoch)
              'op_func' - task's operation function
              'op_params' - operation function-related parameters
              'cleanup_func' - task's optional clenaup operation for tasks
                               that allocate memory.
              'cleanup_params' - should be sent as an array of pointers to be
                                 freed. arr[0] should contain number of params.
                                 If Cleanup Function isn't available, freeing of the params won't be attempted.
  Return value: pointer to newly generated Task. On Error, returns NULL.
  Complexity: O(1). 
  Undefined B.: NULL pointer to Task.
*/
task_t* TaskCreate(time_t time_to_run, task_operation_t op_func, void* op_params,task_cleanup_t cleanup_func, void* cleanup_params );

/*
  Function that destroys a Task. If Cleanup Function isn't available,
  freeing of the params won't be attempted.
  Arguments: 'task' - Task pointer.
  Return value: None.
  Complexity: O(n) n = cleanup_params. 
  Undefined B.: NULL ptr of task. 
*/
void TaskDestroy(task_t *task);

/*
  Function that executes a task function
  Arguments: 'task' - Task pointer. Task won't be changed except if user operation func explicitly leadt to that.
  Return value: UNSCHEDULE / RESCHEDULE given by task's operation function
  Complexity: O(op_func).
  Undefined B.: NULL pointer to Task. 
*/
int TaskExecute(const task_t *task);

/*
  Function that retrieves the value of the tasks' execution time.
  Arguments: 'task' - Task pointer, 
  Return value: tasks' execution time
  Complexity: O(1).
  Undefined B.: NULL pointer to Task. 
*/
time_t TaskGetTimeToExecute(const task_t *task);

/*
  Function that retrieves the UID of the task
  Arguments: 'task' - pointer to Task,
  Return value: task UID
  Complexity: O(1).
  Undefined B.: NULL pointer to Task. 
*/
uid_ty TaskGetUID(const task_t *task);

/*Function that updates a task data
  Arguments: 'task' - pointer to Task,
  Return value: updated task's time_to_run.
  Complexity: O(n).
  Undefined B.: NULL pointer to Task */
void* TaskUpdateTime(task_t *task_to_update);

/*Function that searches a math between to tasks
  Arguments: 'task' - pointer to Task, Task UID
  Return value: match result: TRUE, othewise = FALSE.
  Complexity: O(1).
  Undefined B.: NULL pointer to Task.*/
int TaskIsMatch(const task_t *task, uid_ty task_uid);

/*Function that compares two tasks
  Arguments: 'task1,2' - pointers to Tasks
  Return value: match result: TRUE, othewise = FALSE.
  Complexity: O(1).
  Undefined B.: NULL pointer to Task.*/
int TaskCompare(const task_t *task1, const task_t *task2);

#endif /*__ILRD_TASK_H__*/
/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet #task
  Reviewer: Idan
  Date: 06/09/23
  Version: 1.0
  
  Overview: Implementation of a Task Manager.
*/

/******************************** Libraries  **********************************/
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <time.h>

#include "Uid.h"  /*uid_ty*/
#include "task.h"   

/******************************** Definitions  ********************************/

struct task
{
  uid_ty uid;
  time_t time_to_run;
  double interval_in_sec;
  task_operation_t op_func;
  task_cleanup_t cleanup_func;
  void* op_params;
  void* cleanup_params;
};

/*********************** Task API Declerations  ****************************/


task_t* TaskCreate(time_t time_to_run, task_operation_t op_func, void* op_params,
                  task_cleanup_t cleanup_func, void* cleanup_params )
{
  task_t* task = (task_t*)malloc(sizeof(task_t));

  assert(NULL != op_func);
  /*assert(NULL != cleanup_func);*/

  if(NULL == task)
  {
    return NULL;
  }

  task->uid = UidCreate();
  if(TRUE == UidIsSame(task->uid, bad_uid))
  {
    free(task);
    task = NULL;
    return NULL;
  }

  task->time_to_run = time_to_run;
  task->interval_in_sec = difftime(time_to_run, time(NULL));
  task->op_func = op_func;
  task->cleanup_func = cleanup_func;
  task->op_params = op_params;
  task->cleanup_params = cleanup_params;

  return task;
}

void TaskDestroy(task_t *task)
{
  assert(NULL != task);

  if(NULL != task->cleanup_func)
  {
    task->cleanup_func(task->cleanup_params);
  }

  free(task);
  task = NULL;
}

int TaskExecute(const task_t *task)
{
  assert(NULL != task);

  return task->op_func(task->op_params);
}

time_t TaskGetTimeToExecute(const task_t *task)
{
  assert(NULL != task);

  return task->time_to_run;
}

uid_ty TaskGetUID(const task_t *task)
{
  assert(NULL != task);

  return task->uid;
}

void* TaskUpdateTime(task_t *task_to_update)
{
  assert(NULL != task_to_update);

  task_to_update->time_to_run += task_to_update->interval_in_sec;

  return (void*)task_to_update->time_to_run;
}

int TaskIsMatch(const task_t *task, uid_ty task_uid)
{
  assert(NULL != task);

  return UidIsSame(task->uid, task_uid);
}

int TaskCompare(const task_t *task1, const task_t *task2)
{
  assert(NULL != task1);
  assert(NULL != task2);

  return difftime( task1->time_to_run, task2->time_to_run);;
}
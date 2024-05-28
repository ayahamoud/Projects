/******************************************************************************/
/*
  Name: Aya
  Project: Scheduler
  Reviewer: Idan
  Date: 10/09/23
  Version: 1.0
  
  Overview: Implementation of a scheduler.
*/
/******************************** Libraries  **********************************/

#include <assert.h> /* assert() */
#include <stdio.h>  /* printf */
#include <stdlib.h> /* malloc(), free() */
#include <stddef.h> /* size_t, NULL */
#include <time.h>   /*time_t*/
#include <unistd.h> /*sleep*/
 
#include "sched.h"
#include "task.h"   
#include "pq.h" 

struct sched
{
    pq_t *pq;
    int is_running;
    int is_self_terminate;
    task_t *curr_task;    
};


/******************************** Definitions  ********************************/

static int IsMatch(const void *task, void *task_uid);

static int Compare(const void *task1, void *task2);

static void custom_sleep(time_t time_to_run);

/*********************** Queue API Declerations  ******************************/

sched_t *SchedCreate()
{
  sched_t *sched = (sched_t*)malloc(sizeof(sched_t));
  if (NULL == sched)
  {
    return (sched_t*)0;
  }

  sched->pq = PQCreate(Compare);
  if (NULL == sched->pq)
  {
    return (sched_t*)0;
  }

  sched->is_running = ONHOLD;
  sched->is_self_terminate = FALSE; 
  sched->curr_task = NULL;

  return sched;
}

/******************************************************************************/

void SchedDestroy(sched_t *sched)
{
  assert(NULL != sched);

  SchedClear(sched);
  PQDestroy(sched->pq);

  free(sched);
  sched = NULL;
}

/******************************************************************************/

uid_ty AddTask(sched_t *sched, sched_operation_func sched_func, 
  void *op_param ,time_t time_to_run, sched_clean_func clean_func, 
    void *clean_params)
{
  task_t *task = NULL;
  assert(NULL != sched);
  assert(NULL != sched_func);
  assert((time_t)-1 != time_to_run);

  task = TaskCreate(time_to_run, sched_func, op_param, clean_func, clean_params);
  if (NULL == task)
  {
      return bad_uid;
  }

  if (FAILURE == PQEnqueue(sched->pq, task))
  {
      return bad_uid;
  }
  return TaskGetUID(task);
}

/******************************************************************************/

void RemoveTask(sched_t *sched, uid_ty uid)
{
  task_t *task_to_delete = NULL;

  assert(NULL != sched);

  if(sched->curr_task == NULL || !TaskIsMatch(sched->curr_task,uid))
  {
    task_to_delete = PQErase(sched->pq, &uid, IsMatch);
    TaskDestroy(task_to_delete);
  }
  else
  {
    sched->is_self_terminate = TRUE;
  }
}

/******************************************************************************/

int SchedRun(sched_t *sched)
{
  int exec_status = 0;
  assert(NULL != sched);
  sched->is_running = RUNNING;
  

  while(!PQIsEmpty(sched->pq))
  {
    if (ONHOLD == sched->is_running)
    {
      return STOPPED;
    } 

    sched->curr_task = (task_t*)PQDequeue(sched->pq);

    if(sched->is_self_terminate)
    {
      TaskDestroy(sched->curr_task);
      sched->is_self_terminate = FALSE;
    }

    custom_sleep(TaskGetTimeToExecute(sched->curr_task));

    exec_status = TaskExecute(sched->curr_task);

    
    if(RESCHEDULE == exec_status)
    {
      TaskUpdateTime(sched->curr_task);
      if (FAILURE == PQEnqueue(sched->pq, sched->curr_task))
      {
          return FAILURE;
      }
    }
    else
    {
      TaskDestroy(sched->curr_task);
    }

  }

  sched->is_running = ONHOLD;
  return SUCCESS;
}

/******************************************************************************/

void SchedStop(sched_t *sched)
{
  assert(NULL != sched);

  ((sched_t*)sched)->is_running = ONHOLD;
}

/******************************************************************************/

size_t SchedSize(const sched_t *sched)
{
  assert(NULL != sched);

  return PQSize(sched->pq) + sched->is_running;
}

/******************************************************************************/

int SchedIsEmpty(const sched_t *sched)
{
  assert(NULL != sched);

  return PQIsEmpty(sched->pq) && (ONHOLD == sched->is_running);
}

/******************************************************************************/

void SchedClear(sched_t *sched)
{
  assert(NULL != sched);

  while(!PQIsEmpty(sched->pq))
  {
    TaskDestroy((task_t*)PQDequeue(sched->pq));
  }

  sched->is_running = ONHOLD;
}

/******************************************************************************/

static int IsMatch(const void *task, void *task_uid)
{
    return  TaskIsMatch(task, *(uid_ty*)task_uid);
}

static int Compare(const void *task1, void *task2)
{
    return  TaskCompare((task_t*)task1, (task_t*)task2);
}

static void custom_sleep(time_t time_to_run)
{
  while(0 != difftime(time_to_run, time(NULL)))
  {
    sleep(difftime(time_to_run, time(NULL)));
  }
}
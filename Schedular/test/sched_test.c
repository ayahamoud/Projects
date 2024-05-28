/******************************************************************************/
/*
  Name: Aya
  Project: Scheduler
  Reviewer: Idan
  Date: 10/09/23
  Version: 1.0
  
  Overview: Implementation of a scheduler.
*/

/******************************** Libraries  *********************************/

#include <assert.h>             /* assert() */
#include <stdio.h>              /* perror */
#include <stdlib.h>             /* malloc(), free() */
#include <errno.h>              /* errno global */
#include <stddef.h>             /* size_t, NULL */

#include "sched.h"   
#include "Uid.h"   

/*typedef enum {FALSE = 0, TRUE} pq_boolean_t;
typedef enum  {SUCCESS = 0, FAILURE} pq_status_t;*/

/*****************************************************************************/
/********************************* Type Definitions **************************/
/*****************************************************************************/
    
#define REPORT(expected	, result, str) \
	{\
	    if (expected != result)\
	    {\
	    	printf("%s has failed\n", str);\
	    }\
	}
	
/*****************************************************************************/
/**************************** Test Functions Declerations ********************/
/*****************************************************************************/
    
static int Compare(const void *data1, void *data2);
static int Match(const void* data, void* param);

/******************************************************************************/

static void MainTestFunc(void);

static void TestSchedCreate(void);
static void TestAddTask(void);
static void TestRemoveTask(void);
static void TestSchedRun_DefaultCase(void);
static void TestSchedStop(void);
static void TestSchedSize(void);
static void TestSchedIsEmpty(void);
static void TestSchedClear(void);


static int my_sched_func(void *param);
static int my_stop_func(void *param);
static void my_clean_func(void *param);

/*****************************************************************************/
/*************************************** Main ********************************/
/*****************************************************************************/

int main()
{
	MainTestFunc();
	return 0;
}

/******************************************************************************/

static void MainTestFunc(void)
{
	TestSchedCreate();
	TestAddTask();
	TestRemoveTask();
	TestSchedRun_DefaultCase();
	TestSchedStop();
	TestSchedSize();
	TestSchedIsEmpty();
	TestSchedClear();
}

/*****************************************************************************/
/**************************** Test Functions Definitions *********************/
/*****************************************************************************/

static void TestSchedCreate(void) 
{
  sched_t *sched = SchedCreate();
  
  REPORT(1, SchedIsEmpty(sched), "TestSchedCreate()");
	REPORT(0, SchedSize(sched), "TestSchedCreate()");

	printf("TestSchedCreate() tested\n");

  SchedDestroy(sched);
}

static void TestAddTask(void) 
{
  sched_t *sched = SchedCreate();
  int op_param = 1;
  time_t time_to_run = time(NULL) + 5;
  uid_ty uid = AddTask(sched, my_sched_func, &op_param, time_to_run, my_clean_func, NULL);

  REPORT(FALSE, UidIsSame(uid, bad_uid), "TestAddTask()");

  printf("TestAddTask() tested\n");
  SchedDestroy(sched);
}

static void TestRemoveTask(void) 
{
  sched_t *sched = SchedCreate();
  int op_param = 1;
  time_t time_to_run = time(NULL) + 5;
  uid_ty uid = AddTask(sched, my_sched_func, &op_param, time_to_run, my_clean_func, NULL);

  RemoveTask(sched, uid);
  REPORT(0, SchedSize(sched), "TestRemoveTask()");

  printf("TestRemoveTask() tested\n");
  SchedDestroy(sched);
}

static void TestSchedRun_DefaultCase(void) 
{
  sched_t *sched = SchedCreate();
  int op_param1 = 1;
  int op_param2 = 2;
  time_t time_to_run1 = time(NULL) + 2;
  time_t time_to_run2 = time(NULL) + 5;
  uid_ty uid1 = AddTask(sched, my_sched_func, &op_param1, time_to_run1, my_clean_func, NULL);
  uid_ty uid2 = AddTask(sched, my_sched_func, &op_param2, time_to_run2, my_clean_func, NULL);

  REPORT(SUCCESS, SchedRun(sched), "TestSchedRun_DefaultCase()");
  
  printf("TestSchedRun_DefaultCase() tested\n");
  SchedDestroy(sched);
}

/*static void TestSchedRun_(void) 
{
  sched_t *sched = SchedCreate();
  int op_param1 = 1;
  int op_param2 = 2;
  time_t time_to_run1 = time(NULL) + 2;
  time_t time_to_run2 = time(NULL) + 5;
  uid_ty uid1 = AddTask(sched, my_sched_func, &op_param1, time_to_run1, my_clean_func, NULL);
  uid_ty uid2 = AddTask(sched, my_sched_func, &op_param2, time_to_run2, my_clean_func, NULL);

  REPORT(SUCCESS, SchedRun(sched), "TestSchedRun_DefaultCase()");
  
  printf("TestSchedRun_DefaultCase() tested\n");
  SchedDestroy(sched);
}*/

static void TestSchedStop(void) 
{
  sched_t *sched = SchedCreate();
  int op_param1 = 1;
  int op_param2 = 2;
  int op_param3 = 3;
  int op_param4 = 4;
  time_t time_to_run1 = time(NULL) + 5;
  time_t time_to_run2 = time(NULL) + 2;
  time_t time_to_run3 = time(NULL) + 8;
  time_t time_to_run4 = time(NULL) + 10;
  time_t time_to_run5 = time(NULL) + 7;
  uid_ty uid1 = AddTask(sched, my_sched_func, &op_param1, time_to_run1, my_clean_func, NULL);
  uid_ty uid2 = AddTask(sched, my_sched_func, &op_param2, time_to_run2, my_clean_func, NULL);
  uid_ty uid3 = AddTask(sched, my_sched_func, &op_param3, time_to_run3, my_clean_func, NULL);
  uid_ty uid4 = AddTask(sched, my_sched_func, &op_param4, time_to_run4, my_clean_func, NULL);
  uid_ty uid5 = AddTask(sched, my_stop_func, sched, time_to_run5, my_clean_func, NULL);

  REPORT(STOPPED, SchedRun(sched), "TestSchedStop()");

  printf("TestSchedStop() tested\n");
  SchedDestroy(sched);
}

static void TestSchedSize(void) 
{
  sched_t *sched = SchedCreate();

  uid_ty uid1 = {0};
	uid_ty uid2 = {0};
  int op_param1 = 1;
  int op_param2 = 2;
  time_t time_to_run1 = time(NULL) + 2;
  time_t time_to_run2 = time(NULL) + 5;

	REPORT(0, SchedSize(sched), "TestSchedSize()");

  uid1 = AddTask(sched, my_sched_func, &op_param1, time_to_run1, my_clean_func, NULL);
  uid2 = AddTask(sched, my_sched_func, &op_param2, time_to_run2, my_clean_func, NULL);
  REPORT(2, SchedSize(sched), "TestSchedSize()");

  RemoveTask(sched, uid1);
  REPORT(1, SchedSize(sched), "TestSchedSize()");

  RemoveTask(sched, uid2);
  REPORT(0, SchedSize(sched), "TestSchedSize()");

  printf("TestSchedSize() tested\n");
  SchedDestroy(sched);
}

static void TestSchedIsEmpty(void) 
{
	sched_t *sched = SchedCreate();

  uid_ty uid = {0};
  int op_param = 1;
  time_t time_to_run = time(NULL) + 5; 

  REPORT(1, SchedIsEmpty(sched), "TestSchedIsEmpty()");

  uid = AddTask(sched, my_sched_func, &op_param, time_to_run, my_clean_func, NULL);
  REPORT(0, SchedIsEmpty(sched), "TestSchedIsEmpty()");

  printf("TestSchedIsEmpty() tested\n");
  SchedDestroy(sched);
}

static void TestSchedClear(void) 
{
  sched_t *sched = SchedCreate();
  int op_param = 1;
  time_t time_to_run = time(NULL) + 5;
  uid_ty uid = AddTask(sched, my_sched_func, &op_param, time_to_run, my_clean_func, NULL);

  SchedClear(sched);

	REPORT(1, SchedIsEmpty(sched), "TestSchedClear()");

	printf("TestSchedClear() tested\n");
  SchedDestroy(sched);
}

/*****************************************************************************/
/******************************* Tester Helper Functions  ********************/
/*****************************************************************************/

static int my_sched_func(void *param) 
{
    int *message = (int *)param;
    printf("message: %d\n", *message);

    return UNSCHEDULE;
}

static int my_stop_func(void *param) 
{
    SchedStop((sched_t*)param);
    printf("message: stopped\n");

    return UNSCHEDULE;
}

/*static int my_delete_func(void *param) 
{
    SchedRemove((sched_t*)param);
    printf("message: stopped\n");

    return UNSCHEDULE;
}*/

static void my_clean_func(void *param) 
{
    /*free(param);*/
}



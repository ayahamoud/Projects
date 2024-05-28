/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet 12 - Data Structures - pq
  Reviewer: 
  Date: 06/09/23
  Version: 1.0
  
  Overview: Implementation of a Priority Queue.
*/
/******************************** Libraries  **********************************/
#include <stdlib.h> /*malloc*/
#include <assert.h> /*assert*/

#include "sorted_list.h"
#include "pq.h"

/******************************** Definitions  ********************************/
struct pq
{
  sorted_list_t *list;
};

/*********************** PQ API Declerations  ****************************/
pq_t* PQCreate(pq_compare_t cmp_func)
{
  pq_t *pqueue = (pq_t*)malloc(sizeof(pq_t));

  if(NULL == pqueue)
  {
    return (pq_t*)0;
  }

  pqueue->list = SListCreate(cmp_func);

  return pqueue;
}

void PQDestroy(pq_t *pq)
{
  assert(NULL != pq);

  SListDestroy(pq->list);

  free(pq);
  pq = NULL;
}

size_t PQSize(const pq_t *pq)
{
  assert(NULL != pq);

  return SListSize(pq->list);
}

int PQIsEmpty(const pq_t *pq)
{
  assert(NULL != pq);

  return SListIsEmpty(pq->list);
}

void* PQPeek(const pq_t *pq)
{
  assert(NULL != pq);

  return SListGetData(SListBegin(pq->list));
}

int PQEnqueue(pq_t *pq, void* data)
{
  assert(NULL != pq);

  if(!SListIsSameIter(SListEnd(pq->list),SListInsert(pq->list, data)))
  {
    return FAILURE;
  }

  return SUCCESS;
}

void* PQDequeue(pq_t *pq)
{
  void* data = PQPeek(pq);

  assert(NULL != pq);
  
  SListPopFront(pq->list);
  return data;
}

void PQClear(pq_t *pq)
{
  assert(NULL != pq);

  while(!SListIsEmpty(pq->list))
  {
    PQDequeue(pq);
  }
}

void* PQErase(pq_t *pq, void *params, pq_is_match_t match_func)
{
  void *data;
  sorted_list_iter_t iter = {0};

  iter = SlistFindIF(SListBegin(pq->list), SListEnd(pq->list), match_func, params);
  data = SListGetData(iter);
  
  SListRemove(iter);

  return data;
}
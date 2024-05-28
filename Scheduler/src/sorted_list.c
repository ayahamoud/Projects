/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet 12 - Data Structures - Sorted List
  Reviewer: ???
  Date: 24/08/23
  Version: 1.0
*/
/******************************** Libraries  **********************************/
#include <stdlib.h> /*malloc*/
#include <assert.h> /*assert*/
#include <stdio.h>

#include "sorted_list.h"
#include "DLL.h"

/******************************** Definitions  ********************************/

struct sorted_list 
{
  sorted_list_compare_t cmp_func;
  dll_t *dlist;
};

typedef struct Params
{
  void *params;
  sorted_list_compare_t wrapped_cmp_func;
}params_t;

/************************************* Helper functions ***********************/
/*Wrapper Funcs*/
static int MatchFuncWrapper(const void* from_data, void* params);
static int IsEndElement(sorted_list_t *slist, sorted_list_iter_t iter);

/*Parser Funcs*/
sorted_list_iter_t ToSrtIter (dll_iter_t to_parse);
dll_iter_t ToDllIter (sorted_list_iter_t to_parse);

/******************************************************************************/


sorted_list_t* SListCreate(sorted_list_compare_t compare_func)
{
  sorted_list_t *slist = (sorted_list_t*)malloc(sizeof(sorted_list_t));

  if(NULL == slist)
  {
    return (sorted_list_t*)0;
  }

  slist->dlist = DListCreate();
  slist->cmp_func = compare_func;

  return slist;
}

/******************************************************************************/

void SListDestroy(sorted_list_t *list)
{
  assert(NULL != list);

  DListDestroy(list->dlist);

  free(list);
  list = NULL;
}

/******************************************************************************/

size_t SListSize(const sorted_list_t *list)
{
  assert(NULL != list);

  return DListSize(list->dlist);
}

/******************************************************************************/

int SListIsEmpty(sorted_list_t *list)
{
  assert(NULL != list);

  return DListIsEmpty(list->dlist);
}

/******************************************************************************/

void* SListGetData(sorted_list_iter_t iter)
{
  /*AssertIter(iter.internal_iter);*/

  return DListGetData(iter.internal_iter);
}

/******************************************************************************/

sorted_list_iter_t SListInsert(sorted_list_t *slist, void* data)
{
  sorted_list_iter_t begin = SListBegin(slist);
  sorted_list_iter_t end = SListEnd(slist);

  while (!SListIsSameIter(end, begin))
  {
    if(0 < slist->cmp_func(SListGetData(begin), data))   
    {
      begin.internal_iter = DListInsertBefore(begin.internal_iter, data,
      slist->dlist);
      return begin;
    }
    begin = SListNext(begin);
  }
  begin.internal_iter = DListInsertBefore(begin.internal_iter, data,
    slist->dlist);

  #ifndef NDEBUG
    begin.list = slist;
  #endif

  return begin;
}

/******************************************************************************/

sorted_list_iter_t SListRemove(sorted_list_iter_t iter)
{
  iter.internal_iter = DListRemove(iter.internal_iter);

  return iter;
}

/******************************************************************************/

sorted_list_iter_t SListPopFront(sorted_list_t *slist)
{
  sorted_list_iter_t iter = {0};

  assert(NULL != slist);

  iter.internal_iter = DListPopFront(slist->dlist);

  return iter;
}

/******************************************************************************/

sorted_list_iter_t SListPopBack(sorted_list_t *slist)
{
  sorted_list_iter_t iter = {0};

  assert(NULL != slist);

  iter.internal_iter = DListPrev(DListPopBack(slist->dlist));

  return iter;
}

/******************************************************************************/

sorted_list_iter_t SListFind
(sorted_list_iter_t from, sorted_list_iter_t to, void* params, sorted_list_t *slist)
{
  sorted_list_iter_t iter = {0};    
  params_t *wrapper_params = {0};

  assert( NULL != slist );

  wrapper_params = (params_t*)malloc(sizeof(params_t));

  wrapper_params->wrapped_cmp_func = slist->cmp_func;
  wrapper_params->params = params;

  iter.internal_iter = DListFind(from.internal_iter ,to.internal_iter , MatchFuncWrapper, (void *)wrapper_params);

  free(wrapper_params);

  #ifndef NDEBUG
    iter.list = from.list;
  #endif

  return iter;
}

/******************************************************************************/

int SListForEach
(sorted_list_iter_t from, sorted_list_iter_t to, sorted_list_action_t action_func, void* params)
{
  return DListForEach(from.internal_iter, to.internal_iter, action_func, params);
}

/******************************************************************************/

sorted_list_iter_t SlistFindIF
(sorted_list_iter_t from, sorted_list_iter_t to, sorted_list_is_match_t conditional_func, void *params)
{
  while(FALSE == SListIsSameIter(from, to))
  {
    if(GREATER == conditional_func(DListGetData(from.internal_iter),params))
    {
      return(from);
    }

    from = SListNext(from);
  }

  return(from);
}

/******************************************************************************/

sorted_list_t* SlistMerge(sorted_list_t *dest_list, sorted_list_t *src_list)
{
  sorted_list_iter_t dest_runner = SListBegin(dest_list);
  sorted_list_iter_t src_runner_from = SListBegin(src_list);
  sorted_list_iter_t src_runner_to = SListBegin(src_list);

  assert(NULL != dest_list);
  assert(NULL != src_list);
  
  /*while src not empty*/
  while(FALSE == SListIsEmpty(src_list))
  {
    /*src from = src to = src.begin*/
    src_runner_from = SListBegin(src_list);
    src_runner_to = SListBegin(src_list);
    
    /*while dest <= from*/
    while
    ( (FALSE == IsEndElement(dest_list, dest_runner)) &&
        (GREATER != src_list->cmp_func
          ((SListGetData(dest_runner)), SListGetData(src_runner_to))))
    {
      /*++dest*/
      dest_runner = SListNext(dest_runner);
      /*if dest->next = NULL*/
      if(TRUE == IsEndElement(dest_list, dest_runner))
      {
        /*reached dest_end_flag = 1*/
        src_runner_to = SListEnd(src_list);
        DListSplice(src_runner_from.internal_iter,
              src_runner_to.internal_iter,
              dest_runner.internal_iter);
        return dest_list;
      }
    }
    
    /*while to <= dest && to != END*/
    while(  (FALSE == IsEndElement(src_list, src_runner_to)) &&
          (GREATER != src_list->cmp_func
          ((SListGetData(src_runner_to)),SListGetData(dest_runner))))
    {
      /*++to*/
      src_runner_to = SListNext(src_runner_to);
    }
    /*splice src from-to => dest*/
    DListSplice(src_runner_from.internal_iter,
          src_runner_to.internal_iter,
          dest_runner.internal_iter);
  }
  
  return dest_list;
}

/******************************************************************************/

int SListIsSameIter(sorted_list_iter_t iter, sorted_list_iter_t iter_to_compare)
{
  /*AssertIter(iter.internal_iter);
  AssertIter(iter_to_compare.internal_iter);*/

  return DListIsSameIter(iter.internal_iter, iter_to_compare.internal_iter);
}

sorted_list_iter_t SListBegin(const sorted_list_t *list)
{
  sorted_list_iter_t sorted_list_iter = {0};

  assert(NULL != list);
  
  sorted_list_iter.internal_iter = DListBegin(list->dlist);

  return sorted_list_iter;
}

sorted_list_iter_t SListEnd(const sorted_list_t *list)
{
  sorted_list_iter_t sorted_list_iter = {0};

  assert(NULL != list);
  
  sorted_list_iter.internal_iter = DListEnd(list->dlist);

  return sorted_list_iter;
}

sorted_list_iter_t SListNext(sorted_list_iter_t iter)
{
  sorted_list_iter_t sorted_list_iter = {0};

  /*AssertIter(iter.internal_iter);*/
  
  sorted_list_iter.internal_iter = DListNext(iter.internal_iter);

  return sorted_list_iter;
}

sorted_list_iter_t SListPrev(sorted_list_iter_t iter)
{
  sorted_list_iter_t sorted_list_iter = {0};

  /*AssertIter(iter.internal_iter);*/
  
  sorted_list_iter.internal_iter = DListPrev(iter.internal_iter);
  
  return sorted_list_iter;
}

/******************************************************************************/

static int MatchFuncWrapper(const void* from_data, void* p_wrapper)
{
  return EQUAL == ((params_t *)p_wrapper)->wrapped_cmp_func(from_data, (((params_t *)p_wrapper)->params));
}

static int IsEndElement(sorted_list_t *slist, sorted_list_iter_t iter)
{
  return SListIsSameIter(iter, SListEnd(slist));
}

sorted_list_iter_t ToSrtIter (dll_iter_t to_parse)
{
  sorted_list_iter_t iter = {0};
  iter.internal_iter = to_parse;
  return iter;
}

dll_iter_t ToDllIter (sorted_list_iter_t to_parse)
{
  return to_parse.internal_iter;
}
/*
  Name: Aya
  Project: Work Sheet 11 - Data Structures - DLL
  Reviewer: Sahar
  Date: 22/08/23
  Version: 1.0
*/

/******************************** Libraries  **********************************/
#include <stdlib.h> /*malloc*/
#include <assert.h> /*assert*/

#include "DLL.h"

/******************************************************************************/
static dll_node_t* CreateNode(void* data, dll_iter_t nxt_iter, dll_iter_t prev_iter);
static dll_node_t* IterToNode (dll_iter_t to_parse);
static dll_iter_t NodeToIter (dll_node_t *to_parse);

struct node
{
  void *data;
  dll_node_t *next;
  dll_node_t *prev;
};

struct dll
{
  dll_node_t head;
  dll_node_t tail;
};

/*********************** D-list API Declerations  ****************************/
dll_t* DListCreate()
{
  dll_t *dlist = (dll_t*)malloc(sizeof(dll_t));

  if(NULL == dlist)
  {
    return (dll_t*)0;
  }

  dlist->head.next = &dlist->tail;
  dlist->head.prev = NULL;

  dlist->tail.next = NULL;
  dlist->tail.prev = &dlist->head;

  return dlist;
}

void DListDestroy(dll_t *list)
{
  dll_node_t* current = list->head.next; 
  dll_node_t* next = NULL;

  assert(NULL != list);

  while (!DListIsSameIter((NodeToIter(current)), DListEnd(list)))
  {
      next = (IterToNode(current))->next;
      free(current);
      current = NULL;
      current = next;
  }

  free(list);
  list = NULL;
}

size_t DListSize(const dll_t *list)
{
  size_t count = 0;
  dll_iter_t iter = NULL;

  assert(NULL != list);

  iter = DListBegin((dll_t*)list);

  while (!DListIsSameIter((iter), DListEnd((dll_t*)list)))
  {
    iter = DListNext(iter);
    ++count;
  }

  return count;
}

int DListIsEmpty(dll_t *list)
{
  assert(NULL != list);

  if(DListIsSameIter(DListBegin(list), DListEnd(list)))
  {
    return TRUE;
  }

  return FALSE;
}

void* DListGetData(dll_iter_t iter)
{
  assert(NULL != IterToNode(iter));

  return iter->data;
}

void DListSetData(dll_iter_t iter, const void *data)
{
  assert(NULL != IterToNode(iter));

  iter->data = (void*)data;
}

dll_iter_t DListInsertBefore(dll_iter_t iter, void* data, dll_t *dlist)
{
  dll_iter_t new_iter = NULL;
  dll_iter_t prev_iter = NodeToIter(iter->prev);
  dll_iter_t nxt_iter = iter;

  assert(NULL != dlist);
  assert(NULL != IterToNode(iter));

  new_iter = NodeToIter(CreateNode(data, nxt_iter, prev_iter));
  if(NULL == IterToNode(new_iter))
  {
    return DListEnd(dlist);
  }

  prev_iter->next = IterToNode(new_iter);
  nxt_iter->prev = IterToNode(new_iter);

  return new_iter;
}

dll_iter_t DListRemove(dll_iter_t iter)
{
  dll_iter_t prev_iter = NodeToIter(iter->prev);
  dll_iter_t nxt_iter = NodeToIter(iter->next);

  assert(NULL != IterToNode(iter));

  prev_iter->next = IterToNode(nxt_iter);
  nxt_iter->prev= IterToNode(prev_iter);

  free(IterToNode(iter));
  iter = NULL;

  return nxt_iter;
}

dll_iter_t DListPushFront(dll_t *list, void* data)
{
  assert(NULL != list);

  return DListInsertBefore(DListBegin(list), data, list);
}

dll_iter_t DListPushBack(dll_t *list, void* data)
{
  assert(NULL != list);

  return DListInsertBefore(DListEnd(list), data, list);
}

dll_iter_t DListPopFront(dll_t *list)
{
  assert(NULL != list);

  return DListRemove(DListBegin(list));
}

dll_iter_t DListPopBack(dll_t *list)
{
  assert(NULL != list);

  return DListRemove(DListPrev(DListEnd(list)));
}

dll_iter_t DListFind
(dll_iter_t from, dll_iter_t to, DLLMatchFunc_t match_func, void* params)
{
  assert(NULL != match_func);
  assert(NULL != IterToNode(from));
  assert(NULL != IterToNode(to));

  while (FALSE == DListIsSameIter(from, to))
  {
    if (match_func(from->data, params))
    {
        return from;
    }

    from = DListNext(from);
  }

  return to;
}

int DListForEach
(dll_iter_t from, dll_iter_t to, DLLActionFunc_t action_func, void* params)
{
  assert(NULL != action_func);
  assert(NULL != IterToNode(from));
  assert(NULL != IterToNode(to));

  while (FALSE == DListIsSameIter(from, to))
  {
    if (SUCCESS != action_func(from->data, params))
    {
        return FAILURE;
    }

    from = DListNext(from);
  }

  return SUCCESS;
}

int DListMultiFind(dll_iter_t from, dll_iter_t to, DLLMatchFunc_t match_func,
  void *param, dll_t *dest_list)
{
  dll_iter_t iter = NULL;

  assert(NULL != dest_list);
  assert(NULL != match_func);
  assert(NULL != IterToNode(from));
  assert(NULL != IterToNode(to));
  
  while(FALSE == DListIsSameIter(from, to))
  {
    iter = DListFind(from, to, match_func, param);
    if(FALSE == DListIsSameIter(iter, to))
    {
      DListPushFront(dest_list, iter->data);
      from = DListNext(iter);
    }
  }

  if(NULL == dest_list)
  {
    return FALSE;
  }

  return TRUE;
}

void DListSplice(dll_iter_t from, dll_iter_t to, dll_iter_t where)
{
  dll_iter_t prev_to = DListPrev(to);
  dll_iter_t before_from = DListPrev(from);
  dll_iter_t before_where = DListPrev(where);

  assert(NULL != IterToNode(from));
  assert(NULL != IterToNode(to));
  assert(NULL != IterToNode(where));


  before_from->next = IterToNode(to);
  to->prev = IterToNode(before_from);

  before_where->next = IterToNode(from);
  where->prev = IterToNode(prev_to);

  from->prev = IterToNode(before_where);
  prev_to->next = IterToNode(where);
}

/********************* Iterator API Declerations  ****************************/
int DListIsSameIter(dll_iter_t iter1, dll_iter_t iter2)
{
  assert(NULL != IterToNode(iter1));
  assert(NULL != IterToNode(iter2));

  if(IterToNode(iter1) == IterToNode(iter2))
  {
    return TRUE;
  }

  return FALSE;
}

dll_iter_t DListBegin(dll_t *list)
{
  assert(NULL != list);

  return NodeToIter(list->head.next);
}

dll_iter_t DListEnd(dll_t *list)
{
  assert(NULL != list);

  return NodeToIter(&list->tail);
}

dll_iter_t DListNext(dll_iter_t iter)
{
  assert(NULL != IterToNode(iter));

  return NodeToIter(iter->next);
}

dll_iter_t DListPrev(dll_iter_t iter)
{
  assert(NULL != IterToNode(iter));

  return NodeToIter(iter->prev);
}

/**************************** Helper Functions  *******************************/

static dll_node_t* CreateNode(void* data, dll_iter_t nxt_iter, dll_iter_t prev_iter)
{
  dll_node_t* node = NULL;
  
  node = (dll_node_t*)malloc(sizeof(dll_node_t));
  node->data = data;
  node->next = nxt_iter;
  node->prev = prev_iter;

  return node;
}

static dll_node_t* IterToNode (dll_iter_t to_parse)
{
    return (dll_node_t*)to_parse;
}

static dll_iter_t NodeToIter (dll_node_t *to_parse)
{
    return (dll_iter_t)to_parse;
}
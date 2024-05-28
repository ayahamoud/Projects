/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet 11 - Data Structures - DLL
  Reviewer: Sahar
  Date: 22/08/23
  Version: 1.0
  
  Overview: Implementation of a Doubly Linked List data structure.
*/

#ifndef __ILRD_DLL_H__
#define __ILRD_DLL_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_t*/

/******************************** Definitions  ******************************/

typedef struct node dll_node_t;
typedef dll_node_t* dll_iter_t;
typedef struct dll dll_t;

typedef enum  {SUCCESS = 0, FAILURE} status_t;
typedef enum {FALSE = 0, TRUE} boolean_t;

typedef int (*DLLActionFunc_t)(void* data, void* param);
typedef int (*DLLMatchFunc_t)(const void* list_data, void* params);

/*********************** D-list API Declerations  ****************************/

/*
  Description: Function that creates a new doubly linked list.
  Arguments: None.
  Return value: Pointer to a new doubly linked list. Returns NULL on failure.
  Complexity: O(1). 
  Undefined B.: None
*/
dll_t* DListCreate(void);

/*
  Description: Function that destroys a doubly linked list and releases its 
               memory.
  Arguments: 'list' - Pointer to the list to be destroyed.
  Return value: None.
  Complexity: O(n). 
  Undefined B.: 'list' is NULL. 
*/
void DListDestroy(dll_t *list);

/*
  Description: Function that returns the number of elements in the list.
  Arguments: list' - Pointer to the list.
  Return value: Number of elements in the list.
  Complexity: O(n).
  Undefined B.: 'list' is NULL.
*/
size_t DListSize(const dll_t *list);

/*
  Description: Function that checks if the doubly linked list is empty.
  Arguments: 'list' - Pointer to the list.
  Return value: Returns TRUE if the list is empty, FALSE otherwise.
  Complexity: O(1).
  Undefined B.: 'list' is NULL.
*/
int DListIsEmpty(dll_t *list);

/*
  Description: Function that retrieves the data stored in the element pointed 
               to by the iterator.
  Arguments: 'iter' - Iterator pointing to the element.
  Return value: Pointer to the data stored in the element.
  Complexity: O(1).
  Undefined B.: 'iter' is NULL. 
*/
void* DListGetData(dll_iter_t iter);

/*
  Description: Function that sets the data of the element pointed to by the 
               iterator.
  Arguments: 'iter' - Iterator pointing to the element.
             'data' - Data to be set.
  Return value: None.
  Complexity: O(1).
  Undefined B.: 'iter' is NULL. 
*/
void DListSetData(dll_iter_t iter, const void *data);

/*
  Description: Function that inserts a new element before the element pointed 
               to by the iterator.
  Arguments: 'iter' - Iterator pointing to the next element.
             'data' - Data to be stored in the new element.
             'dlist' - Pointer to the doubly linked list.
  Return value: Iterator pointing to the newly inserted element.
                Returns an invalid iterator on failure.
  Complexity: O(1).
  Undefined B.: 'iter' or 'dlist' is NULL.
*/
dll_iter_t DListInsertBefore(dll_iter_t iter, void* data, dll_t *dlist);

/*
  Description: Function that removes the element pointed to by the iterator 
               from the list.
  Arguments: 'iter' - Iterator pointing to the element to be removed.
  Return value: Iterator pointing to the element following the removed element.
                Passed iterator is invalidated.
  Complexity: O(1).
  Undefined B.: 'iter' is NULL.
*/
dll_iter_t DListRemove(dll_iter_t iter);

/*
  Description: Function that inserts a new element at the beginning of the list.
  Arguments: 'list' - Pointer to the list.
             'data' - Data to be stored in the new element.
  Return value: Iterator pointing to the newly inserted element.
                Returns an invalid iterator on failure.
  Complexity: O(1).
  Undefined B.: 'list' is NULL.
*/
dll_iter_t DListPushFront(dll_t *list, void* data);

/*
  Description: Function that inserts a new element at the end of the list.
  Arguments: 'list' - Pointer to the list.
             'data' - Data to be stored in the new element.
  Return value: Iterator pointing to the newly inserted element.
                Returns an invalid iterator on failure.
  Complexity: O(1).
  Undefined B.: 'list' is NULL.
*/
dll_iter_t DListPushBack(dll_t *list, void* data);

/*
  Description: Function that removes the element at the beginning of the list.
  Arguments: 'list' - Pointer to the list.
  Return value: Iterator pointing to the element following the removed element.
                Returns an invalid iterator on failure.
  Complexity: O(1).
  Undefined B.: 'list' is NULL.
*/
dll_iter_t DListPopFront(dll_t *list);

/*
  Description: Function that Removes the element at the end of the list.
  Arguments: 'list' - Pointer to the list.
  Return value: Iterator pointing to the element following the removed element.
                Returns an invalid iterator on failure.
  Complexity: O(1).
  Undefined B.: 'list' is NULL. 
*/
dll_iter_t DListPopBack(dll_t *list);

/* 
  Description: Function that searches for data within a specified range in the 
               list.
  Arguments: 'from' - Iterator marking the beginning of the range.
             'to' - Iterator marking the end of the range (not included).
             'match_func' - Function for data comparison.
             'params' - Parameters to be passed to 'match_func'.
  Return value: Iterator to the first found element within the range.
                Returns 'to' iterator if the element is not found.
  Complexity: O(n).
  Undefined behavior: 'from', 'to' are NULL or belong to different lists.
*/
dll_iter_t DListFind
(dll_iter_t from, dll_iter_t to, DLLMatchFunc_t match_func, void* params);

/* 
 Description: Function that searches for and retrieves elements within a 
              specified range, storing them in a destination list.
 Arguments: 'from' - Iterator marking the beginning of the range.
            'to' - Iterator marking the end of the range (not included).
            'match_func' - Function for data comparison.
            'param' - Parameters to be passed to 'match_func'.
            'dest_list' - Pointer to the destination list for storing 
                          found elements.
 Return value: Returns SUCCESS if any elements were found and stored, otherwise 
               returns FAILURE.
 Complexity: O(n) * complexity of action func.
 Undefined behavior: 'from', 'to' are NULL or belong to different lists, or 
                     'dest_list' is NULL.
*/
int DListForEach
(dll_iter_t from, dll_iter_t to, DLLActionFunc_t action_func, void* params);

/* 
 Description: Function that applies a given action function to elements within 
              a specified range.
 Arguments: 'from' - Iterator marking the beginning of the range.
            'to' - Iterator marking the end of the range (not included).
            'action_func' - Function to be applied to elements.
            'params' - Parameters to be passed to 'action_func'.
 Return value: Returns SUCCESS if all actions were completed, otherwise returns     
               FAILURE.
 Complexity: O(n);
 Undefined behavior: 'from', 'to' are NULL or belong to different lists, or 
                      'action_func' is NULL.
*/
int DListMultiFind(dll_iter_t from, dll_iter_t to, DLLMatchFunc_t match_func,
  void *param, dll_t *dest_list);

/* 
 Description: Function that relocates consecutive elements defined by a range 
              to exist before a new specified element.
 Arguments: 'from' - Iterator marking the beginning of the range.
            'to' - Iterator marking the end of the range (not included).
            'where' - Iterator marking the relocation point.
 Return value: None.
 Complexity: O(1).
 Undefined behavior: 'from', 'to' are NULL or belong to different lists, or 
                     'where' is NULL.
*/
void DListSplice(dll_iter_t from, dll_iter_t to, dll_iter_t where);

/********************* Iterator API Declerations  ****************************/

/*
  Description: Function that checks if two iterators are pointing to the same 
               element in the list.
  Arguments: 'iter1', 'iter2' - Iterators to be compared.
  Return value: Returns SUCCESS if iterators are the same, otherwise returns 
                FAILURE.
  Complexity: O(1).
  Undefined B.: None. 
*/
int DListIsSameIter(dll_iter_t iter1, dll_iter_t iter2);

/*
  Description: Function that Returns an iterator to the beginning of the list.
  Arguments: 'list' - Pointer to the list.
  Return value: Iterator pointing to the first element of the list.
  Complexity: O(1).
  Undefined B.: 'list' is NULL. 
*/
dll_iter_t DListBegin(dll_t *list);

/*
  Description: Function that returns an iterator to the end of the list.
  Arguments: 'list' - Pointer to the list.
  Return value: Iterator pointing to the ending element of the list.
  Complexity: O(1).
  Undefined B.: 'list' is NULL. 
*/
dll_iter_t DListEnd(dll_t *list);

/*
  Description: Function that returns an iterator pointing to the element 
               following the given iterator.
  Arguments: 'iter' - Iterator pointing to an element.
  Return value: Iterator pointing to the next element.
  Complexity: O(1).
  Undefined B.: 'iter' is NULL.
*/
dll_iter_t DListNext(dll_iter_t iter);

/*
  Description: Function that returns an iterator pointing to the element 
               preceding the given iterator.
  Arguments: 'iter' - Iterator pointing to an element.
  Return value: Iterator pointing to the previous element.
  Complexity: O(1).
  Undefined B.: 'iter' is NULL.
*/
dll_iter_t DListPrev(dll_iter_t iter);

/******************************************************************************/

#endif /*(__ILRD_DLL_H__)*/
/******************************************************************************/
/*
  Name: Aya
  Project: Work Sheet 12 - Data Structures - UID
  Reviewer: 
  Date: 06/09/23
  Version: 1.0
  
  Overview: Implementation of an UID.
*/

#ifndef __ILRD_UID_H__
#define __ILRD_UID_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_t*/
#include <sys/types.h> /*pid_t, time_t*/

/******************************** Definitions  ********************************/

typedef struct uid
{
	size_t counter;
	time_t time_stamp;
	pid_t pid; 
}uid_ty;

extern const uid_ty bad_uid;

typedef enum {FALSE = 0, TRUE} boolean_t;

/*********************** Uid API Declerations  ********************************/

/*
  Description: Function that creates a new UID.
  Arguments: None.
  Return value: New UID by value. Returns bad_uid on failure.
  Complexity: O(1). 
  Undefined B.: None
*/
uid_ty UidCreate(void);

/*
  Description: Function that checks if two UID are the same.
  Arguments: 'original_uid', 'uid_to_cmp' - UID's to be compared.
  Return value: Returns TRUE if UID's are the same, otherwise returns FALSE.
  Complexity: O(1).
  Undefined B.: None. 
*/
int UidIsSame(uid_ty original_uid, uid_ty uid_to_cmp);

/******************************************************************************/

#endif /*(__ILRD_UID_H__)*/
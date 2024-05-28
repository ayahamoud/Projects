/******************************************************************************/
/*
  Name:Agbaria Ahmad
  Project: UID project -project of two function : UIDCreate- generates a uid, 
  UIDIsSame - check if two uid are same uid.
  Reviewer: Ahmad Wattad
  Date: 06/09/1991
  Version: 1.0
*/
/******************************************************************************/
#ifndef __ILRD_UID_H__
#define __ILRD_UID_H__

#include <sys/types.h>/* pid_t */
#include <stddef.h>   /* size_t */
#include <time.h>     /* time_t */
#include <stdatomic.h> /*atomic*/

typedef enum {FALSE = 0, TRUE} boolean_t;

typedef struct uid uid_ty;

/************************** Uid API Declerations  *****************************/

/*A function that generate new uid
  return value : the function returns new uid
  Complexity: O(1).
  Undefined B.: invalid uid. */
uid_ty UIDCreate(void);

/*A Function that checks if the two uids are the same. 
  Arguments: two uid to be checked if they are the same.
  Return value: it will return 1 if similar, otherwise, it will return 0.
  Complexity: O(1).
  Undefined B.: invalid uid. */
int UIDIsSame(uid_ty uid1, uid_ty uid2);

/******************************* bad uid decleration **************************/
/*The user Must not change anything in bad_uid, any change can cause the program
 to malfunction */
extern const uid_ty bad_uid;


/************************* management structure *******************************/
struct uid 
{
	atomic_size_t counter;
	time_t timestamp;
	pid_t pid;
};


/******************************************************************************/

#endif /* ILRD_UID_H__*/

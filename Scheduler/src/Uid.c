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
#include <unistd.h>/*getpid*/

#include "Uid.h"

const uid_ty bad_uid = {0,-1,0};
/******************************************************************************/

uid_ty UidCreate()
{
	uid_ty new_uid = {0};
	static atomic_size_t counter = 1;
	
	new_uid.counter = counter;
	new_uid.timestamp = time(0);
	new_uid.pid = getpid();
	
	if(-1 == new_uid.timestamp)
	{
		return bad_uid;
	}
	
	__atomic_fetch_add(&counter, 1, __ATOMIC_SEQ_CST);
	
	return new_uid;
}

/******************************************************************************/

int UidIsSame(uid_ty uid1, uid_ty uid2)
{
	if((uid1.counter == uid2.counter) && (uid1.timestamp == uid2.timestamp)
	&& (uid1.pid == uid2.pid))
	{
		return TRUE;
	}
	return FALSE;
}

/******************************************************************************/



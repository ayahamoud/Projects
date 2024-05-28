/*
  Name: 
  Project: Keep Watching
  Reviewer: ---
  Date: 18/12/2023.
*/
/******************************************************************************/
#ifndef __ILRD_KEEPWATCHING_H__
#define __ILRD_KEEPWATCHING_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_t*/

/*********************** AVL API Declerations  ********************************/

int KeepWatching(char *argv[], pid_t other_pid, size_t interval, size_t max_failure_num);

/******************************************************************************/
#endif /*(__ILRD_KEEPWATCHING_H__)*/
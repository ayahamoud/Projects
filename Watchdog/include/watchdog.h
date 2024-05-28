/*
  Name: 
  Project: Watchdog
  Reviewer: ---
  Date: 18/12/2023.
*/
/******************************************************************************/
#ifndef __ILRD_WATCHDOG_H__
#define __ILRD_WATCHDOG_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_t*/

/*********************** AVL API Declerations  ********************************/

int MakeMeImmortal(char* argv[], int argc, size_t interval, size_t max_failure_num );

int DoNotResuscitate();

/******************************************************************************/
#endif /*(__ILRD_WATCHDOG_H__)*/
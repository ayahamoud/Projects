/*
  Name: Aya
  Project: Calculator
  Reviewer: ???
  Date: 03/10/2023
  Version: 1.0


  Project Overview: API for a Calculator
*/

#ifndef __ILRD_CALCULATOR_H__
#define __ILRD_CALCULATOR_H__

/******************************** Libraries  **********************************/

#include <stddef.h> /*size_ty*/

/******************************** Definitions  ********************************/

typedef enum {SUCCESS = 0, FAILURE, MATH_ERROR=2, SYNTAX_ERROR=3} calc_status_ty;
#define EXP_MAX_LEN   100 
#define UNSAFE_RESULT 0 

/*********************** BST API Declerations  ********************************/

/*Function that calculates the expression given by input.
	Supported operators are: ('-', '+' , '*', '/', '(' ,')')
  Arguments: 'input' - an expression to evaluate, not greater than EXP_MAX_LEN 
             'status' - an integer pointer to store calculation status,
                        as defined by calc_status_ty (provided by user)
  Return value: Calculated expression.
                On Error- returns 0 , so user is obligated to validate 'status',
                          to ensure it does not inform of an error.
  Complexity: O(n), where n is input's length.
  Undefined B.: Input String is not terminated with '/0'
                Staus pointer sent by user is not poining to a valid memory chunk */
double Calculate(const char *input, int *status);

#endif /*(__ILRD_CALCULATOR_H__)*/
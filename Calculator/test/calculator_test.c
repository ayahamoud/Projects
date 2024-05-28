/*
  Name: Aya
  Project: Calculator
  Reviewer: ???
  Date: 03/10/2023
  Version: 1.0


  Project Overview: API for a Calculator
*/  

/******************************************************************************/
/******************************** Libraries  **********************************/
/******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include "calculator.h"

/******************************************************************************/
/******************************** Definitions  ********************************/
/******************************************************************************/
#define NUM_OF_EXPRESSIONS 18
#define MAX_EXPRESSION_SIZE 50

#define REPORT(expected , result, str) \
  {\
      if (expected != result)\
      {\
        printf("%s has failed\n", str);\
      }\
  }

/*****************************************************************************/
/**************************** Test Functions Declerations ********************/
/*****************************************************************************/
static void CalculateTest();

/*****************************************************************************/
/*************************************** Main ********************************/
/*****************************************************************************/
int main(int argc, char const *argv[])
{
    CalculateTest();
    return 0;
}

/*****************************************************************************/
/************************* Test Calculator Functions **************************/
/*****************************************************************************/

static void CalculateTest()
{
    int status_info[NUM_OF_EXPRESSIONS] = {SUCCESS, SUCCESS, SUCCESS, SUCCESS, SUCCESS, MATH_ERROR, SUCCESS, SUCCESS, SUCCESS, SUCCESS, SYNTAX_ERROR, SYNTAX_ERROR, SYNTAX_ERROR, SYNTAX_ERROR, SYNTAX_ERROR, SUCCESS, SYNTAX_ERROR, SYNTAX_ERROR};
    double results[NUM_OF_EXPRESSIONS] = {2.0, -1.0, 0.0, 4.0, 2.0, 0.0, 2.0, 16.0, 4.0, 16.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 0.0, 0.0};
    char expressions[NUM_OF_EXPRESSIONS][MAX_EXPRESSION_SIZE] = {"1+1", "1-1-1", "1-1", "1+1*3", "10/5", "10/0", "(10/5)", "1+1*3*5", "1+(1*3)", "1+5*(1*3)", "(8+3", "8+3)", "(8+3))", "2A6t+6", "32+1    -3", "1+(((5)))", "1+((", "1++1"};
    size_t i = 0;
    int status;
    double res = 0.0;

    while(NUM_OF_EXPRESSIONS > i)
    {
        res = Calculate(expressions[i], &status);
        REPORT(results[i], res, expressions[i]);
        REPORT(status_info[i], status, expressions[i]);
        ++i;
    }

    printf("Calculator tested!\n");
}

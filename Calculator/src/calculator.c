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
#include <assert.h> /*assert*/
#include <stdlib.h> /*strtod*/
#include <string.h> /*strlen*/

#include "calculator.h"
#include "stack.h"

#define ASCII_SIZE 256
#define MIN_SIZE_OPERANDS 2

/******************************************************************************/
/******************************** Definitions  ********************************/
/******************************************************************************/

/*---------------------------------- Enums -----------------------------------*/
typedef enum {WAIT_OPERAND = 0, WAIT_OPERATOR, ERROR, NUM_OF_STATES} state_ty;
typedef enum {HASH_OPERATOR = 0, PLUS_OPERATOR, MINUS_OPERATOR , MULTIPLY_OPERATOR ,DIVIDE_OPERATOR, OPEN_PARAN, NUM_OF_OPERATORS, INVALID, OPERAND, CLOSE_PARAN, TERMINATOR, NUM_OF_INPUTS} input_ty;
typedef enum {HASH_P = 0, PARAN_P, PLUS_P, MINUS_P = PLUS_P, MULTIPLY_P ,DIVIDE_P = MULTIPLY_P} op_priority_ty;
typedef enum {UNINITIALIZED, INITIALIZED} init_ty;

/*------------------------------ Functions Pointer ---------------------------*/
typedef double (*operator_func_ty)(double *left_data, double right_data, int *status);
typedef state_ty (*handle_ty)(int *status, char **input);

/*---------------------------------- Structs ---------------------------------*/
typedef struct operator
{
	op_priority_ty priority;
	operator_func_ty action_func;
}operator_ty;

/*---------------------------------- LUT'S -----------------------------------*/
input_ty input_LUT[ASCII_SIZE];
handle_ty handlers_LUT[NUM_OF_STATES][NUM_OF_INPUTS];
operator_ty operators_LUT[NUM_OF_OPERATORS];

/*---------------------------------- Stacks ----------------------------------*/
stack_ty *operands_stack = NULL;
stack_ty *operators_stack = NULL;


/*------------------------------ Handler Functions ---------------------------*/
static state_ty OperandHandler(int *status, char **input);
static state_ty OperatorHandler(int *status, char **input);
static state_ty OpenpParanHandler(int *status, char **input);
static state_ty CloseParanHandler(int *status, char **input);
static state_ty ErrorHandler(int *status, char **input);
static state_ty EOIHandler(int *status, char **input);

/*-------------------------- Operator Action Functions -----------------------*/
static double Sum(double *left_data, double right_data, int *status);
static double Minus(double *left_data, double right_data, int *status);
static double Divide(double *left_data, double right_data, int *status);
static double Multiply(double *left_data, double right_data, int *status);

/*------------------------------ Helper Functions ----------------------------*/
static void InitLuts(void);
static int InitStacks(char *str, int *status);
static char EvaluateOperator(char operator, int *status);

/******************************************************************************/
/**************************** Calculator API **********************************/
/******************************************************************************/

double Calculate(const char *str, int *status)
{
  char curr_char;
  state_ty curr_state = WAIT_OPERAND;
  static int initialize = UNINITIALIZED;
  char* input = NULL;
  double return_value = 0.0;

  assert(NULL != str);
  /*assert(NULL != status);*/
  
  *status = SUCCESS;
  input = (char*)str;
  
  if(UNINITIALIZED == initialize)
  {
    InitLuts();
    initialize = INITIALIZED;
  }

  if(FAILURE == InitStacks(input, status))
  {
    return UNSAFE_RESULT;
  }

  while(ERROR != curr_state)
  {
    curr_char = *input;
    curr_state = handlers_LUT[curr_state][input_LUT[curr_char]](status, &input);
  }

  if(SUCCESS == *status)
  {
    return_value = *(double*)StackPeek(operands_stack);
  }
  
  StackDestroy(operands_stack);
  StackDestroy(operators_stack);

  return return_value;
}

/******************************************************************************/
/**************************** Handler Functions *******************************/
/******************************************************************************/

state_ty OperandHandler(int *status, char **input)
{
  double curr_operand = 0.0;

  assert(NULL != status);
  assert(NULL != input);

  curr_operand = strtod(*input, input);
  StackPush(operands_stack, &curr_operand);

  return WAIT_OPERATOR;
}

/*----------------------------------------------------------------------------*/

state_ty OperatorHandler(int *status, char **input)
{
  char curr_operator = ' ';
  char prev_operator = *(char*)StackPeek(operators_stack);

  assert(NULL != status);
  assert(NULL != input);

  curr_operator = **input;

  while(operators_LUT[input_LUT[curr_operator]].priority <= operators_LUT[input_LUT[prev_operator]].priority)
  {
    prev_operator = EvaluateOperator(prev_operator, status);

    if(*status == MATH_ERROR)
    {
      return ERROR;
    }

  }

  StackPush(operators_stack, &curr_operator);
  ++(*input);

  return WAIT_OPERAND;
}

/*----------------------------------------------------------------------------*/

state_ty OpenpParanHandler(int *status, char **input)
{
  assert(NULL != status);
  assert(NULL != input);

  StackPush(operators_stack, &(*(*input)));
  ++(*input);

  return WAIT_OPERAND;
}

/*----------------------------------------------------------------------------*/

state_ty CloseParanHandler(int *status, char **input)
{
  char curr_operator = *(char*)StackPeek(operators_stack);

  assert(NULL != status);
  assert(NULL != input);

  while('(' != curr_operator)
  {
    if('#' == curr_operator)
    {
      *status = SYNTAX_ERROR;
      return ERROR;
    }

    curr_operator = EvaluateOperator(curr_operator, status);

    if(*status == MATH_ERROR)
    {
      return ERROR;
    }
  }

  StackPop(operators_stack);
  ++(*input);

  return WAIT_OPERATOR;
}

/*----------------------------------------------------------------------------*/

state_ty ErrorHandler(int *status, char **input)
{
  assert(NULL != status);
  assert(NULL != input);

  *status = SYNTAX_ERROR;

  return ERROR;
}

/*----------------------------------------------------------------------------*/

state_ty EOIHandler(int *status, char **input)
{
  char curr_operator = *(char*)StackPeek(operators_stack);

  assert(NULL != status);
  assert(NULL != input);

  while('#' != curr_operator)
  {
    if(MIN_SIZE_OPERANDS > StackSize(operands_stack))
    {
      *status = SYNTAX_ERROR;
      return ERROR;
    }
    curr_operator = EvaluateOperator(curr_operator, status);
  }

  return ERROR;
}

/******************************************************************************/
/*********************** Operator Action Functions ****************************/
/******************************************************************************/

double Sum(double *left_data, double right_data, int *status)
{
  assert(NULL != left_data);
  assert(NULL != status);

  return (*left_data) + right_data;
}

/*----------------------------------------------------------------------------*/

double Minus(double *left_data, double right_data, int *status)
{
  assert(NULL != left_data);
  assert(NULL != status);

  return (*left_data) - right_data;
}

/*----------------------------------------------------------------------------*/

double Divide(double *left_data, double right_data, int *status)
{
  assert(NULL != left_data);
  assert(NULL != status);

  if(0 == right_data)
  {
    *status = MATH_ERROR;
    return UNSAFE_RESULT;
  }

  return (*left_data) / right_data;
}

/*----------------------------------------------------------------------------*/

double Multiply(double *left_data, double right_data, int *status)
{
  assert(NULL != left_data);
  assert(NULL != status);

  return (*left_data) * right_data;
}

/******************************************************************************/
/**************************** Helper Functions ********************************/
/******************************************************************************/

static void InitLuts()
{
	char digit = '0';
  size_t i = 0;
	/*init input helper lut*/
  while(ASCII_SIZE > i)
  {
    input_LUT[i] = INVALID;  
    ++i;
  }

	for (digit; '9' >= digit; ++digit)
	{
    /*printf("%d,",digit);*/
    input_LUT[digit] = OPERAND;
  }

	input_LUT['#'] = HASH_OPERATOR;
	input_LUT['+'] = PLUS_OPERATOR;
	input_LUT['-'] = MINUS_OPERATOR;
	input_LUT['*'] = MULTIPLY_OPERATOR;
	input_LUT['/'] = DIVIDE_OPERATOR;
	input_LUT['('] = OPEN_PARAN;
	input_LUT[')'] = CLOSE_PARAN;
	input_LUT['\0'] = TERMINATOR;
	
  /*init handlers lut*/
	handlers_LUT[WAIT_OPERAND][INVALID] = ErrorHandler;	
	handlers_LUT[WAIT_OPERAND][HASH_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][PLUS_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][MINUS_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][MULTIPLY_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][DIVIDE_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][OPERAND] = OperandHandler;
	handlers_LUT[WAIT_OPERAND][OPEN_PARAN] = OpenpParanHandler;
	handlers_LUT[WAIT_OPERAND][CLOSE_PARAN] = ErrorHandler;
	handlers_LUT[WAIT_OPERAND][TERMINATOR] = ErrorHandler;
	
	handlers_LUT[WAIT_OPERATOR][INVALID] = ErrorHandler;	
  handlers_LUT[WAIT_OPERATOR][HASH_OPERATOR] = ErrorHandler;
	handlers_LUT[WAIT_OPERATOR][PLUS_OPERATOR] = OperatorHandler;
	handlers_LUT[WAIT_OPERATOR][MINUS_OPERATOR] = OperatorHandler;
	handlers_LUT[WAIT_OPERATOR][MULTIPLY_OPERATOR] = OperatorHandler;
	handlers_LUT[WAIT_OPERATOR][DIVIDE_OPERATOR] = OperatorHandler;
	handlers_LUT[WAIT_OPERATOR][OPERAND] = ErrorHandler;
	handlers_LUT[WAIT_OPERATOR][OPEN_PARAN] = ErrorHandler;
	handlers_LUT[WAIT_OPERATOR][CLOSE_PARAN] = CloseParanHandler;
	handlers_LUT[WAIT_OPERATOR][TERMINATOR] = EOIHandler;
	
	handlers_LUT[ERROR][INVALID] = ErrorHandler;	
  handlers_LUT[ERROR][HASH_OPERATOR] = ErrorHandler;
	handlers_LUT[ERROR][PLUS_OPERATOR] = ErrorHandler;
	handlers_LUT[ERROR][MINUS_OPERATOR] = ErrorHandler;
	handlers_LUT[ERROR][MULTIPLY_OPERATOR] = ErrorHandler;
	handlers_LUT[ERROR][DIVIDE_OPERATOR] = ErrorHandler;
	handlers_LUT[ERROR][OPERAND] = ErrorHandler;
	handlers_LUT[ERROR][OPEN_PARAN] = ErrorHandler;
	handlers_LUT[ERROR][CLOSE_PARAN] = ErrorHandler;
	handlers_LUT[ERROR][TERMINATOR] = ErrorHandler;

  /*init operators lut*/
  operators_LUT[HASH_OPERATOR].priority = HASH_P;
	operators_LUT[HASH_OPERATOR].action_func = NULL;

	operators_LUT[OPEN_PARAN].priority = PARAN_P;
	operators_LUT[OPEN_PARAN].action_func = NULL;
	
	operators_LUT[PLUS_OPERATOR].priority =PLUS_P;
	operators_LUT[PLUS_OPERATOR].action_func = Sum;
	
	operators_LUT[MINUS_OPERATOR].priority = MINUS_P;
	operators_LUT[MINUS_OPERATOR].action_func = Minus;
	
	operators_LUT[MULTIPLY_OPERATOR].priority = MULTIPLY_P;
	operators_LUT[MULTIPLY_OPERATOR].action_func = Multiply;
	
	operators_LUT[DIVIDE_OPERATOR].priority = DIVIDE_P;
	operators_LUT[DIVIDE_OPERATOR].action_func = Divide;
	
}

/*----------------------------------------------------------------------------*/

static char EvaluateOperator(char operator, int *status)
{
  double right_data = *(double*)StackPeek(operands_stack);
  double *left_data = NULL;
  double result = 0.0;

  assert(NULL != status);

  StackPop(operands_stack);
  left_data = &(*(double*)StackPeek(operands_stack));
  result = operators_LUT[input_LUT[operator]].action_func(left_data, right_data, status);
  *left_data = result;
  StackPop(operators_stack);

  return *(char*)StackPeek(operators_stack);
}

/*----------------------------------------------------------------------------*/

static int InitStacks(char *str, int *status)
{
  char dummy_operator = '#';
  operands_stack = StackCreate(strlen(str), sizeof(double));

  if(NULL == operands_stack)
  {
    *status = FAILURE;
    return FAILURE;
  }

  operators_stack = StackCreate(strlen(str), sizeof(char));

  if(NULL == operators_stack)
  {
    *status = FAILURE;
    StackDestroy(operands_stack);
    return FAILURE;
  }
  

  StackPush(operators_stack, &dummy_operator);

  return SUCCESS;
}
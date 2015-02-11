#ifndef _incl_common_pic18_h
#define _incl_common_pic18_h

#include <built_in.h>

#define INPUT   1
#define OUTPUT  0

#define YES     1
#define NO      0

#define NULL    0

#define LOW     0
#define HIGH    1

#define INTERRUPT_PRIORITY_HIGH 1
#define INTERRUPT_PRIORITY_LOW  0

typedef unsigned short      uint8;
typedef   signed short      int8;
typedef unsigned int        uint16;
typedef   signed int        int16;
typedef unsigned long       uint32;
typedef   signed long       int32;
typedef unsigned long long  uint64;
typedef   signed long long  int64;
typedef unsigned short      byte;

typedef enum t_bool_enum
{
    FALSE = 0,
    TRUE =  1
} 
t_bool;

typedef enum t_operation_enum
{
    ERROR =   0,
    SUCCESS = 1
} 
t_operation;

#endif
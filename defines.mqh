#define DEBUGGING false

#include "None.mqh"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayString.mqh>
#include <Strings\String.mqh>
#include <Files\File.mqh>

#ifdef __MQL4__
   #define ERR_DEBUG_OK ERR_NO_ERROR
#else 
   #define ERR_DEBUG_OK ERR_SUCCESS
#endif 

#define TYPE_WEBREQUEST 99995462
#define TYPE_HEADERS 99995463
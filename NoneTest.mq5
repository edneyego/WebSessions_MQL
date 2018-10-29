//+------------------------------------------------------------------+
//|                                                     NoneTest.mq5 |
//|                                                      nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "None.mqh"
void OnStart()
  {
//---
   double nums[10];
   ARRAY_SET_NONE(nums);
   for(int i=0; i<10; i++)
      if(!IS_NONE(nums[i]))
         Print("ERROR");
         
   CObject *o = new CObject;
   Print(CheckPointer(o));
   SET_NONE(o);
   Print(CheckPointer(o));
   
  }
//+------------------------------------------------------------------+

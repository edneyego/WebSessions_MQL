//+------------------------------------------------------------------+
//|                                              testStringSplit.mq5 |
//|                                                      nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   string x = "1\n2\n3";
   string res[];
   StringSplit(x, '\n', res);
   ArrayPrint(res);
   
  }
//+------------------------------------------------------------------+

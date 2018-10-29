//+------------------------------------------------------------------+
//|                                                         none.mqh |
//|                                      Copyright 2018, nicholishen |
//|                                                    interwebs.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, nicholishen"
#property link      "interwebs.com"
#ifdef __MQL4__
#property strict
#endif 

#define NONE_DOUBLE  DBL_MAX
#define NONE_FLOAT   FLT_MAX
#define NONE_INT     INT_MAX
#define NONE_UINT    UINT_MAX
#define NONE_LONG    LONG_MAX
#define NONE_ULONG   ULONG_MAX
#define NONE_CHAR    CHAR_MAX
#define NONE_UCHAR   UCHAR_MAX
#define NONE_SHORT   SHORT_MAX
#define NONE_USHORT  USHORT_MAX
#define NONE_COLOR   clrNONE
#define NONE_DATETIME -1
#define NONE_POINTER NULL
#define NONE_STRING  "__NONE-*-*-STRING__"

class _NoneType
{
 public:
   static double   None(double _)     { return NONE_DOUBLE;}
   static float    None(float _)      { return NONE_FLOAT; }
   static int      None(int _)        { return NONE_INT;   }
   static uint     None(uint _)       { return NONE_UINT;  }
   static long     None(long _)       { return NONE_LONG;  }
   static ulong    None(ulong _)      { return NONE_ULONG; }
   static char     None(char _)       { return NONE_CHAR;  }
   static uchar    None(uchar _)      { return NONE_UCHAR; }
   static short    None(short _)      { return NONE_SHORT; }
   static ushort   None(ushort _)     { return NONE_USHORT;}
   static string   None(string _)     { return NONE_STRING;}
   static color    None(color _)      { return NONE_COLOR; }
   static datetime None(datetime _)   { return NONE_DATETIME;}
   template<typename T>
   static T        None(T _)          { return NONE_POINTER;}
   
   static bool    IsNone( const double   Value ) { return(Value == NONE_DOUBLE); }
   static bool    IsNone( const float    Value ) { return(Value == NONE_FLOAT); }
   static bool    IsNone( const int      Value ) { return(Value == NONE_INT); }
   static bool    IsNone( const uint     Value ) { return(Value == NONE_UINT); }
   static bool    IsNone( const long     Value ) { return(Value == NONE_LONG); }
   static bool    IsNone( const ulong    Value ) { return(Value == NONE_ULONG); }
   static bool    IsNone( const char     Value ) { return(Value == NONE_CHAR); }
   static bool    IsNone( const uchar    Value ) { return(Value == NONE_UCHAR); }
   static bool    IsNone( const short    Value ) { return(Value == NONE_SHORT); }
   static bool    IsNone( const ushort   Value ) { return(Value == NONE_USHORT); }
   static bool    IsNone( const color    Value ) { return(Value == NONE_COLOR); }
   static bool    IsNone( const datetime Value ) { return(Value == NONE_DATETIME); }
   static bool    IsNone( const string   Value ) { return(Value == NONE_STRING); }
   template<typename T>
   static bool    IsNone( const T         Value ) { return(Value == NONE_POINTER);}
   
   
};

#define NONE(T)  _NoneType::None((T)NULL)
#define IS_NONE(VALUE)  _NoneType::IsNone(VALUE)
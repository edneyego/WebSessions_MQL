#include "defines.mqh"
#include "dict.mqh"
#include "builder_base.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Payload : public BuilderBase
{
 public:
   virtual string         to_string();
   virtual bool           from_string(string key_value);
   virtual DictItem*      operator[](string key);
   virtual void           operator = (const string value){ this.from_string(value);}
   virtual Payload*        clear() { m_items.Reset(); return &this; }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DictItem* Payload::operator[](string key)
{
   if(m_items.Contains<DictItem*>(key))
      return m_items.Get<DictItem*>(key);
   DictItem *item = new DictItem();
   if(!m_items.Set(key, item)){
      delete item;
   }
   return item;
}

string Payload::to_string(void)
{
   ResetLastError();
   string res = "";
   string keys[];
   int total = m_items.Keys(keys);
   for(int i=0; i<total; i++){
      string value = (m_items.Get<DictItem*>(keys[i])).value();
      res += (keys[i] + "=" + value);
      if(i < total -1)
         res += "&";
      int de = GetLastError();
      if(GetLastError() != ERR_SUCCESS)
         DebugBreak();
   }
   CString str;
   str.Assign(res == "" ? res : "?"+res);
   if(GetLastError() != ERR_SUCCESS)
         DebugBreak();
   if(str.Len() > 0)
      str.Replace(" ", "%20");
   if(GetLastError() != ERR_SUCCESS)
         DebugBreak();
   res = str.Str();
   int de = GetLastError();
   if(de != ERR_SUCCESS)
      DebugBreak();
   return res;
}

bool Payload::from_string(string param_string)
{
   CString pstr;
   pstr.Assign(param_string);
   pstr.TrimLeft("?");
   string items[];
   int total = StringSplit(pstr.Str(), '&', items);
   if(total < 1)
      return false;
   for(int i=0; i<total; i++){
      CString str;
      str.Assign(items[i]);
      str.TrimLeft(" ");
      str.Replace(" ","%20");
      string key, value = NONE_STRING;
      int sep = str.Find(0, "=");
      if(sep >= 0){
         key = str.Left(sep);
         value = str.Right(str.Len() - sep - 1);
      }else{
         key = str.Str();
      }
      DictItem *item = new DictItem();
      item = value;
      if(!m_items.Set(key, item)){
         DebugBreak();
         return false;
      }
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

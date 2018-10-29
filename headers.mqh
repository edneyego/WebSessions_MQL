//#include "defines.mqh"
//#include "dict.mqh"
#include "builder_base.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class HeaderLine : public BuilderBase
{
   
 public:
   
   virtual string         to_string();
   virtual bool           from_string(string key_value);
   virtual DictItem*      operator[](string key);
   //virtual void           operator = (const string value){ this.from_string(value);}
   virtual HeaderLine*        clear() { m_items.Reset(); return &this; }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Headers : public BuilderBase
{
     
public:
   
   virtual string          to_string();
   virtual bool            from_string(string headers);
   virtual HeaderLine*     operator[](string key);
   virtual int             Type() const { return TYPE_HEADERS; }
   virtual bool            Load(const int file_handle);
   virtual bool            Load(CFile *file);
   virtual bool            Load(CFile &file);
   virtual bool            Save(const int file_handle);
   virtual Headers*        clear() { m_items.Reset(); return &this; }

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HeaderLine* Headers::operator[](string key)
{
   if(m_items.Contains<HeaderLine*>(key))
      return m_items.Get<HeaderLine*>(key);
   
   //HeaderLine *line = m_items.Get<HeaderLine*>(key);
   //if(CheckPointer(line))
   //   return line;
   HeaderLine *line = new HeaderLine();
   if(!m_items.Set(key, line))
      DebugBreak();
   return line;
}

string Headers::to_string(void)
{
   string res;
   //string keys[];
   CArrayString keys;
   int total = m_items.Keys(keys);
   for(int i=0; i<total; i++){
      HeaderLine * line = m_items.Get<HeaderLine*>(keys[i]);
      string value = line.to_string();
      if(value == NONE_STRING || value == NULL  || value == ""){
         res += keys[i];
      }else{
         res += keys[i] + ": " + value;
      }
      if(i < total -1)
         res += "\n";
   }
   return res;
}

bool Headers::from_string(string headers)
{
   if(headers == NULL)
      return false;
   if(DEBUGGING)
      Print(headers);
   string items[];
   int total = StringSplit(headers, '\n', items);
   if(total < 1)
      return false;
   for(int i=0; i<total; i++){
      CString str;
      str.Assign(items[i]);
      if(str.Len() > 1)
         str.TrimLeft("");
      //StringTrimLeft(items[i]);
      string key; 
      string value = NONE_STRING;
      int sep = str.Find(0, ":");
      if(sep >= 0){
         key = str.Left(sep);
         value = str.Right(str.Len() - sep - 1);
         //StringTrimLeft(value);
         CString v;
         v.Assign(value);
         if(str.Len() > 1)
            v.TrimLeft(" ");
         value = v.Str();
      }else{
         key = str.Str();
      }
      HeaderLine *header_line = new HeaderLine();
      header_line.from_string(value);
      if(!m_items.Set(key, header_line)){
         DebugBreak();
         return false;
      }
   }
   return true;
}

bool Headers::Load(const int file_handle)
{
   if(file_handle == INVALID_HANDLE)
      return false;
   string res = "";
   while(!FileIsEnding(file_handle)){  
      string read = FileReadString(file_handle);
      StringTrimRight(read);
      StringTrimLeft(read);
      res += read;
      if(!FileIsEnding(file_handle))
         res += "\n";
   }
   return this.from_string(res);
}

bool Headers::Load(CFile *file)
{
   return this.Load(file.Handle());
}

bool Headers::Load(CFile &file)
{
   return this.Load(&file);
}

bool Headers::Save(const int file_handle)
{
   if(file_handle == INVALID_HANDLE)
      return false;
   return FileWriteString(file_handle, this.to_string()) > 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DictItem* HeaderLine::operator[](string key)
{
   if(m_items.Contains<DictItem*>(key))
      return m_items.Get<DictItem*>(key);
   //DictItem *item = m_items.Get<DictItem*>(key);
   //if(CheckPointer(item))
   //   return item;
   DictItem *item = new DictItem();
   if(!m_items.Set(key, item))
      DebugBreak();
   return item;
}

string HeaderLine::to_string(void)
{
   string res = "";
   //string keys[];
   CArrayString keys;
   int total = m_items.Keys(keys);
   for(int i=0; i<total; i++){
      DictItem *item = m_items.Get<DictItem*>(keys[i]);
      string value = item.value();
      if(value == NONE_STRING || value == NULL  || value == ""){
         res += keys[i];
      }else{
         res += keys[i] + "=" + value;
      }
      if(i < total -1)
         res += "; ";
   }
   return res;
}

bool HeaderLine::from_string(string key_value)
{
   ResetLastError();
   string items[];
   int total = StringSplit(key_value, ';', items);
   if(total < 1)
      return false;
   for(int i=0; i<total; i++){
      CString str;
      str.Assign(items[i]);
      str.TrimLeft(" ");
      if(GetLastError() != ERR_DEBUG_OK)
         DebugBreak();
      string key; 
      string value = NONE_STRING;
      int sep = str.Find(0, "=");
      if(GetLastError() != ERR_DEBUG_OK)
         DebugBreak();
      if(sep >= 0){
         key = str.Left(sep);
         value = str.Right(str.Len() - sep - 1);
         if(GetLastError() != ERR_DEBUG_OK)
            DebugBreak();
      }else{
         key = str.Str();
      }
      if(GetLastError() != ERR_DEBUG_OK)
         DebugBreak();
      DictItem *header_item = new DictItem();
      header_item = value;
      if(!m_items.Set(key, header_item)){
         DebugBreak();
         return false;
      }
         
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

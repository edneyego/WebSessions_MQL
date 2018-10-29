#include "defines.mqh"
#include "Dictionary.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
class Dictionary : public CDictionary
{
 protected:
   CArrayString   m_keys;
 public:
   template <typename T>
   bool Set(string key, T value=NULL){
      if(value == NULL)
         value = NONE(T);
      if(CDictionary::Contains<T>(key))
         CDictionary::Delete<T>(key);
      if(CDictionary::Set(key, value)){
         if(m_keys.SearchLinear(key) >= 0)
            return true;
         return m_keys.Add(key);
      }
      return false;
   }
   int Keys(CArrayString &array){
      return this.Keys(&array);
   }
   int Keys(CArrayString *array){
      array.AssignArray(&m_keys);
      return array.Total();
   }
   int Keys(string &array[]){
      int total = ArrayResize(array, m_keys.Total());
      for(int i=0; i<total; i++)
         array[i] = m_keys[i];
      return total;
   }
   bool Reset(){
      m_keys.Clear();
      return CDictionary::Reset();
   }
};
////
//class KeyVal : public CObject
//{
//public:
//   string         key;
//   CObject*       val;
//   ~KeyVal(){ delete val; }
//   KeyVal(string k, CObject* v){key = k; val = v;}   
//};
//
//class Dictionary : public CArrayObj
//{
// 
// public:
//   template<typename T>
//   T Get(string key){
//      for(int i=this.Total()-1; i>=0; --i){
//         KeyVal* ptr = this.At(i);
//         if(ptr.key == key)
//            return (T)ptr.val;
//      }
//      return NULL;
//   }
//   bool Set(string key, CObject *value){
//      for(int i=this.Total()-1; i>=0; --i){
//         KeyVal* ptr = this.At(i);
//         if(ptr.key == key)
//            this.Delete(i);
//      }
//      KeyVal *kv = new KeyVal(key, value);
//      return this.Add(kv);
//   }
//   int Keys(string &array[]){
//      int total = ArrayResize(array, this.Total());
//      for(int i=0; i<total; i++)
//         array[i] = ((KeyVal*)this.At(i)).key;
//      return total;
//   }
//   
//};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class DictItem : public CObject
{
   string      m_value;
   int         m_inst;
   static int  s_inst;
 public:
   DictItem():m_value(NONE_STRING){
      m_inst = ++s_inst;
      if(DEBUGGING)
         Print("DictItem Created: ", m_inst);
   }
   ~DictItem(){
      if(DEBUGGING)
         Print("DictItem Destroyed: ", m_inst);
   }
   void operator = (string value) { m_value = value;}
   string value() const { return m_value;}
};
int DictItem::s_inst = 0;
#include "defines.mqh"
#include "dict.mqh"


class BuilderBase : public CObject
{
 protected:
   Dictionary           m_items;
 public:
   BuilderBase();
  ~BuilderBase();
   virtual string       to_string()                   { return NULL;  }
   virtual bool         from_string(string key_value) { return false; }
   //virtual void         clear();
   //virtual DictItem*    operator[](string key) { return NULL; }
   virtual void         operator = (const string value){ this.from_string(value);}
};

BuilderBase::BuilderBase(void)
{
 
}
BuilderBase::~BuilderBase(void)
{

}

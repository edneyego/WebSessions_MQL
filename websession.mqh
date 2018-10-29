#include "headers.mqh"
#include "payload.mqh"
#include "json.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class WebSession : public CObject
{
 protected:
   //--- MEMBERS
   string            m_base_url;
   string            m_endpoint;
   Headers          *m_headers_request;
   Headers          *m_headers_response;
   Json             *m_json;
   Payload          *m_payload;
   
   char              m_request[];
   char              m_response[];
   int               m_status_code;
   int               m_timeout;
   string            m_verb;
 public:
   virtual int       Type()                const override {  return TYPE_WEBREQUEST; }
   //--- Constructor: 
                     WebSession(const string base_url=NULL, const int timeout=5);
                    ~WebSession();
   //--- VERBS: performs a web-request, stores data in members, returns this
   virtual WebSession* GET();
   virtual WebSession* POST();
   virtual WebSession* PUT();
   virtual WebSession* PATCH();
   virtual WebSession* DELETE();
   
   //--- SETTERS: sets members, returns this
   virtual WebSession* base_url(const string base_url);
   virtual WebSession* request_body(const string body);
   virtual WebSession* request_body(Json *json);
   virtual WebSession* request_body(Json &json);
   virtual WebSession* clear_headers();
   virtual WebSession* clear_payload();
   virtual WebSession* endpoint(const string endpoint);
   virtual WebSession* full_url(const string full_url);
   virtual WebSession* headers_request(Headers *h);                     
   virtual WebSession* headers_response(Headers *h);
   virtual WebSession* headers_request(Headers &h);                     
   virtual WebSession* headers_response(Headers &h);
   virtual WebSession* payload(Payload *payload);
   virtual WebSession* payload(Payload &payload);
   virtual WebSession* timeout(const int timeout); 
   
   //--- GETTERS: the final method call of a chain, gets data from most recent request
   virtual string    base_url()                    const {  return m_base_url;         }
   virtual string    full_url(void)                const;
   virtual Headers*  headers_request()             const {  return m_headers_request;  }                     
   virtual Headers*  headers_response()            const {  return m_headers_response; }
   virtual Payload*  payload()                     const;
   virtual string    response()                    const;
   virtual int       status_code()                 const {  return m_status_code;      }
   virtual int       timeout()                     const {  return m_timeout;          }
   virtual Json*     json();
   
   //--- STATIC METHODS
   static string     nonce();
 protected:
   virtual int        _do_request(const string verb);
};

//+------------------------------------------------------------------+

WebSession::WebSession(const string base_url=NULL,const int timeout=5)
{
   m_base_url = base_url;
   m_timeout = timeout;
   this.clear_headers();
   this.clear_payload();
}
//+------------------------------------------------------------------+
WebSession::~WebSession()
{
   if(CheckPointer(m_headers_request)) 
      delete m_headers_request;
   if(CheckPointer(m_headers_response)) 
      delete m_headers_response;
   if(CheckPointer(m_payload)) 
      delete m_payload;
   if(CheckPointer(m_json)) 
      delete m_json;
}
//+------------------------------------------------------------------+
WebSession* WebSession::clear_headers(void)
{
   if(CheckPointer(m_headers_request))
      delete m_headers_request;
   if(CheckPointer(m_headers_response))
      delete m_headers_response;
   m_headers_request = new Headers();
   m_headers_response = new Headers();
   return &this;
}

WebSession* WebSession::clear_payload(void)
{
   if(CheckPointer(m_payload))
      delete m_payload;
   m_payload = new Payload();
   return &this;
}
//+------------------------------------------------------------------+
int WebSession::_do_request(const string verb)
{
   ResetLastError();
   string resp_headers = NULL;
   string urlz = this.full_url();
   if(GetLastError() != ERR_SUCCESS) {
      DebugBreak();
      ResetLastError();
   }
   string rheaders = m_headers_request.to_string();
   if(GetLastError() != ERR_SUCCESS) {
      DebugBreak();
      ResetLastError();
   }
   int r = WebRequest(
      verb, urlz, rheaders, 
      m_timeout, m_request, m_response, resp_headers
   );
   int debug_error = GetLastError();
   if(GetLastError() != ERR_SUCCESS){
      switch(debug_error){
         case ERR_FUNCTION_NOT_ALLOWED:
            Print(__FUNCTION__, ": Did you forget to whitelist the domain?");
            break;
         case ERR_WEBREQUEST_TIMEOUT:
            Print(__FUNCTION__, ": WebRequest timed out.");
            break;
         case ERR_WEBREQUEST_REQUEST_FAILED:
            printf("%s: HTTP request failed! Terminal Error: %d", __FUNCTION__, _LastError);
            break;
         default: break;
      }
      DebugBreak();
      return r;
   } 
   if(CheckPointer(m_headers_response)){
      //m_headers_response.clear();
      delete m_headers_response;
      m_headers_response = new Headers();
      m_headers_response.from_string(resp_headers);
   }
   return r;
}
//+------------------------------------------------------------------+
WebSession* WebSession::headers_request(Headers *h)
{
   if(CheckPointer(m_headers_request))
      delete m_headers_request;
   m_headers_request = h;
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::headers_response(Headers *h)
{
   if(CheckPointer(m_headers_response))
      delete m_headers_response;
   m_headers_response = h;
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::headers_request(Headers &h)
{
   return this.headers_request(&h);
}
//+------------------------------------------------------------------+
WebSession* WebSession::headers_response(Headers &h)
{
   return this.headers_response(&h);
}
//+------------------------------------------------------------------+
string WebSession::nonce(void)
{
   return string((int)TimeLocal()) + StringFormat("%03d",GetMicrosecondCount() % 1000);
}
//+------------------------------------------------------------------+
WebSession* WebSession::endpoint(const string endpoint)
{
   m_endpoint = endpoint;
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::base_url(const string base_url)
{
   m_base_url = base_url;
   return &this;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
WebSession* WebSession::full_url(const string full_url)
{
   m_base_url = full_url;
   m_endpoint = NULL;
   m_payload.clear();
   return &this;
}
//+------------------------------------------------------------------+
string WebSession::full_url() const
{
   string res = m_base_url + m_endpoint;
   string payload = m_payload.to_string();
   return res + payload;
}
//+------------------------------------------------------------------+
string WebSession::response(void) const
{
   return CharArrayToString(m_response);
}
//+------------------------------------------------------------------+
WebSession* WebSession::GET()
{
   m_status_code = this._do_request("GET");
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::POST()
{
   m_status_code = this._do_request("POST");
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::PUT()
{
   m_status_code = this._do_request("PUT");
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::DELETE()
{
   m_status_code = this._do_request("DELETE");
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::PATCH()
{
   m_status_code = this._do_request("PATCH");
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::timeout(const int timeout)       
{  
   m_timeout = timeout;
   return &this;
}
//+------------------------------------------------------------------+
WebSession* WebSession::request_body(const string body)
{
   StringToCharArray(body, m_request);
   return &this;
}

WebSession* WebSession::request_body(Json *json)
{
   this.request_body(json.Serialize());
   return &this;
}

WebSession* WebSession::request_body(Json &json)
{
   return this.request_body(&json);
}


WebSession* WebSession::payload(Payload *payload)
{
   if(CheckPointer(m_payload))
      delete m_payload;
   m_payload = payload;
   return &this;
}

WebSession* WebSession::payload(Payload &payload)
{
   return this.payload(&payload);
}

Payload* WebSession::payload(void) const
{
   return m_payload;
}

Json* WebSession::json(void)
{
   if(!CheckPointer(m_json))
      m_json = new Json();
   m_json.Deserialize(this.response());
   return m_json;
}
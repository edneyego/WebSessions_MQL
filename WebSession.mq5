//+------------------------------------------------------------------+
//|                                                 JsonRequests.mq5 |
//|                                                      nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#define TEST(FUNC, SESSION_OBJ) printf("%s:: %s",\
   FUNC(SESSION_OBJ) ? "passed" : "failed", #FUNC);\
   Sleep(1000);
#include "websession.mqh"



void OnStart()
{
   Print("_+_+_+_+_BEGIN REQUESTS TESTS+_+_+_+_+_");
   
   WebSession x("https://postman-echo.com");  //Constructor with base_url arg.
   TEST(test_get, x);
   TEST(test_post_form_data, x);
   TEST(test_basic_auth, x);
   
   // Testing bitfinex public API
   TEST(test_bfx_ticker, x);

   // Testing get headers from file
   TEST(test_headers_from_file, x);
   Print("_+_+_+_+_END REQUESTS TESTS+_+_+_+_+_"); 
}
//+------------------------------------------------------------------+


bool test_get(WebSession &x)
{
   x.clear_headers().clear_payload();
   x.payload()["foo"] = "bar";
   x.payload()["spam"] = "eggs";
   x.headers_request()["Content-Type"] = "application/json";
   if(x.endpoint("/get").GET().status_code() == 200
      && x.json()["args"]["foo"].ToStr() == "bar"
   ){
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
bool test_post_form_data(WebSession &x)
{
   x.clear_headers().clear_payload();
   x.headers_request()["Content-Type"] = "application/x-www-form-urlencoded";
   x.endpoint("/post").request_body("PostForm=MQLmessage");
   if(x.POST().status_code() == 200
      && x.json()["form"]["PostForm"].ToStr() == "MQLmessage"
   ){
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
bool test_basic_auth(WebSession &x)
{
   x.clear_headers().clear_payload().endpoint("/basic-auth");
   x.headers_request()["Authorization"] = "Basic cG9zdG1hbjpwYXNzd29yZA==";
   x.payload()["Username"] = "postman";
   x.payload()["Password"] = "password";
   if(x.GET().status_code() == 200
      && x.json()["authenticated"].ToBool()
   ){
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
bool test_bfx_ticker(WebSession &x)
{
   x.clear_headers().clear_payload();
   x.full_url("https://api.bitfinex.com/v2/ticker/tBTCUSD");
   if(x.GET().status_code() == 200
      && x.json()[7].ToDbl() > 0
   ){
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
bool test_headers_from_file(WebSession &x)
{
   x.clear_headers().clear_payload();
   CFile f;
   if(f.Open("headers.txt", FILE_TXT|FILE_READ) == INVALID_HANDLE){
      Print(__FUNCTION__, " Failed because file error ", _LastError);
      Print("Did you copy the file to ./Files and rename it \"headers.txt\"?");
      return false;
   }
   if(!x.headers_request().Load(f))
      return false;
   if(x.headers_request()["Host"].to_string() == "www.myfxbook.com")
      return true; 
   Print(x.headers_request().to_string());
   return false;
}
//+------------------------------------------------------------------+
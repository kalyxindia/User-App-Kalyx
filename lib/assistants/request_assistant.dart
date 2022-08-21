import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistants
{
  static Future<dynamic> receiveRequest(String url) async
  {
    http.Response httpResponse = await http.get(Uri.parse(url));

   try
   {
     if(httpResponse.statusCode == 200)
     {
       String resData = httpResponse.body;

       var decodeResponseData = jsonDecode(resData);

       return decodeResponseData;
     }
     else
     {
       return "Error Occurred, Failed. No Response.";
     }
   }catch(exp)
    {
      return exp.toString() + "Error Occurred, Failed. No Response.";
    }

  }
}
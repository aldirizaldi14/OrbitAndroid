import 'package:http/http.dart' as http;

String api_url = "http://192.168.1.11/api/";

Future<dynamic> apiLastUpdate(String user, String passw) async {
  try{
    final response = await http.post(api_url + "login", body: {'username': user, 'password': passw });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }catch(e){
    print(e);
    return '';
  }
}
import 'package:http/http.dart' as http;

String api_url = "http://192.168.1.11/";

Future<String> apiLastUpdate() async {
  try{
    final response = await http.get(api_url + "last_update");
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      return '';
    }
  }catch(e){
    return '';
  }

}
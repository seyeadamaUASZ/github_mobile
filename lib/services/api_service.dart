import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{
  String baseUrl = "https://api.github.com/search/users";
  search(String query)async {
    String url = formater(query);
    //print(url);
    // http.get(Uri.parse(url))
    //     .then((response){
    //       print(response.body);
    //       return json.decode(response.body);
    // })
    // .catchError((err){
    //      print(err);
    //      return null;
    // })
    // ;
    var response = await http.get(Uri.parse(url));
    if(response.statusCode==200 ||response.statusCode==201){
      return json.decode(response.body);
    }
    
  }
  formater(String query){
    return baseUrl=baseUrl+"?q=${query}&per_page=20&page=0";
  }

  Future<http.Response> checkRepos(String url)async{
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      return response;
    }
    return null;
  }

  }

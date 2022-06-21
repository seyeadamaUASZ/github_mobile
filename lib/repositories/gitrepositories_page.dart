import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/services/api_service.dart';

class GitRepositoriesPage extends StatefulWidget {
   String login;
   String avatarUrl;
   GitRepositoriesPage({this.login,this.avatarUrl});

  @override
  State<GitRepositoriesPage> createState() => _GitRepositoriesPageState();
}

class _GitRepositoriesPageState extends State<GitRepositoriesPage> {
  dynamic dataRepositories;
  ApiService apiS = ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRepositories();
  }

  void loadRepositories()async{
    String url = "https://api.github.com/users/${widget.login}/repos";
    //http.Response response = await http.get(Uri.parse(url));
    http.Response response = await apiS.checkRepos(url);
    print(response.body);
    if(response.statusCode==200){
      setState(() {
         dataRepositories = json.decode(response.body);
      });
     
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(  
        title: Text("Repositories ${widget.login}"),
        centerTitle: true,
        actions: [  
          CircleAvatar(  
            backgroundImage: NetworkImage(widget.avatarUrl),
          )
        ],
      ),
      body: Center(  
        child: ListView.separated(
          itemBuilder: (context,index)=> ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatarUrl),
                ),
                Text("${dataRepositories[index]['name']}"),
              ],
            ),
            ),
           
    
           separatorBuilder: (context, index) => Divider(height: 2,color: Colors.deepOrange,), 
           itemCount: dataRepositories==null ? 0 : dataRepositories.length
           )
      ),
    );
  }
}
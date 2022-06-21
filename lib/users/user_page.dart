import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/repositories/gitrepositories_page.dart';

class UsersPage extends StatefulWidget {
   UsersPage({Key key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
   String que;
   bool notvisible=false;
   String baseUrl = "https://api.github.com/search/users";
   //ApiService _apiService=ApiService();
   dynamic data=null;
   int currentPage = 0;
   int totalPages=0;
   int pageSize = 20;
   List<dynamic> listItems=[];
   ScrollController scrollController = ScrollController();

  TextEditingController query = TextEditingController();

  void _search(String query){
      String url = formater(query);
      print(url);
     http.get(Uri.parse(url))
         .then((response){
           //print(response.body);
           setState(() {
             data =  json.decode(response.body);
             listItems.addAll(data['items']);
             if(data['total_count']%pageSize==0){
               totalPages = data['total_count']~/pageSize;
             }else{
               totalPages = (data['total_count']/pageSize).floor() + 1;
             }
             

           });         
     })
     .catchError((err){
          print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        setState(() {
          if(currentPage < totalPages-1){
              ++currentPage;
              _search(que);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("users => $que =>$currentPage / $totalPages"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: notvisible,
                        onChanged: (value){
                          setState(() {
                            this.que=value;
                          });
                        },
                        controller: query,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon:Icon(
                              notvisible ==true ?
                              Icons.visibility_off
                                  :
                              Icons.visibility
                            ),
                            onPressed: (){
                              setState(() {
                                notvisible=!notvisible;
                              });

                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              width: 1,
                              color:Colors.deepOrange
                            )

                          )
                        ),
                      )
                  ),
                ),
                IconButton(
                    onPressed: (){
                      setState(() {
                        listItems=[];
                        currentPage=0;
                        this.que= query.text;    
                        _search(this.que);
                       
                      });
                    },
                    icon: Icon(Icons.search,color:Colors.deepOrange)
                )
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(height: 2,color: Colors.deepOrange,),
                controller: scrollController,
                itemCount:listItems.length,
                itemBuilder: (context,index){
                  return ListTile(  
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>GitRepositoriesPage(login: listItems[index]['login'],avatarUrl: listItems[index]['avatar_url'],)));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(listItems[index]['avatar_url']),
                              radius: 40,
                            ),
                            SizedBox(width: 20,),
                            Text("${listItems[index]['login']}"),
                           
                          ],
                        ),
                         CircleAvatar(
                              child: Text("${listItems[index]['score']}"),
                            )
                      ],
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
  

  formater(String query){
    return baseUrl=baseUrl+"?q=${query}&per_page=${pageSize}&page=${currentPage}";
  }

}

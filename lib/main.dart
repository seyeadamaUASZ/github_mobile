import 'package:flutter/material.dart';
import 'package:untitled/users/home_page.dart';
import 'package:untitled/users/user_page.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      routes: {
        "/":(context)=>HomePage(),
        "/users":(context)=>UsersPage()
      },
      initialRoute: "/users",

    );
  }
}




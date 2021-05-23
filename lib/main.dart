import 'package:contacts/pages/mainPage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/mainPage": (context) => ContactsUserMainPage(),
      },
      title: 'Contact Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsUserMainPage(),
    );
  }
}

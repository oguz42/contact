import 'package:contacts/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/contact_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsUserMainPage(),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:untitled_int20h_mobile_project/screens/login_screen.dart';


void main() => runApp(Login());


class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

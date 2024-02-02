import 'package:flutter/material.dart';

class welcomeScreen extends StatefulWidget {
  final String email;
  const welcomeScreen({
    super.key,required this.email
  });

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login Succesfully with google Auth \n Welcome ${widget.email}",style:TextStyle(fontSize:25),),
      ),
    );
  }
}

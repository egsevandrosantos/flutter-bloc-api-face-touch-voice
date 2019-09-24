import 'package:flutter/material.dart';
import 'package:my_project_bloc/src/ui/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
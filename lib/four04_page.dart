import 'package:flutter/material.dart';
class Four04Page extends StatelessWidget {
  final String message;
  Four04Page(this.message);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Page Not Found')),
    body: Center(child: Text(message)),
  );
}
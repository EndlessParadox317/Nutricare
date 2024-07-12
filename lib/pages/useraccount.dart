import 'package:flutter/material.dart';
import 'package:nutricare/firebasestuff/authentication.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User Account'),
      ),
        floatingActionButton:ElevatedButton(
          onPressed: () async {
            await Authentication().signOut();
            Navigator.pushReplacementNamed(context, '/Login');
          },
          child: Text('Logout'),
        ),

    );
  }
}
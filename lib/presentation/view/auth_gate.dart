import 'package:flutter/material.dart';
import 'package:stepwise/core/controller/auth_controller.dart';
import 'package:stepwise/presentation/view/authentication/login.dart';
import 'package:stepwise/presentation/view/interface/interface.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    //  Using the stream builder method to get data from the stream
    return StreamBuilder(
      //  Checking the stream for the authentication flow state changes
      stream: AuthController().auth.authStateChanges(),
      //  Building the widget tree
      builder: (context, snapshot) {
        //  Checking if the snapshot has data
        if (snapshot.hasData) {
          //  If the snapshot has data that means the user is authenticatied
          //  and will be directed to interface page of the application
          return const InterfacePage();
        } else {
          //  If the snapshot does not have data that means the user is not authenticatied
          //  and will be directed to login page of the application
          return const LoginPage();
        }
      },
    );
  }
}

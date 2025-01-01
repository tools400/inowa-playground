import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import '/src/ui/authentication/auth_screen.dart';
import '/src/ui/authentication/verification_screen.dart';
import '/src/ui/device_list/boulder_list.dart';
import '/src/ui/home/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, user) {
        if (!user.hasData) {
          return AuthScreen();
        } else if (!user.data!.emailVerified) {
          return VerificationScreen();
        } else {
          return HomeScreen();
/*
          return HomeScreen();
*/
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'package:inowa/src/ui/home/boulder_list_screen.dart';
import 'package:inowa/src/ui/home_OBSOLETE/home_screen.dart';

import '/src/ui/authentication/auth_screen.dart';
import '/src/ui/authentication/verification_screen.dart';

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
          return BoulderListScreen();
//          return HomeScreen();
        }
      },
    );
  }
}

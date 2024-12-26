import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:inowa/main.dart';
import 'package:inowa/src/ui/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/flutterfire_300x.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? Text(AppLocalizations.of(context)!.txt_Welcome_to +
                        packageInfo.appName +
                        AppLocalizations.of(context)!.txt_please_sign_in)
                    : Text(AppLocalizations.of(context)!.txt_Welcome_to +
                        packageInfo.appName +
                        AppLocalizations.of(context)!.txt_please_sign_up),
              );
            },
/*
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
*/
          );
        }

        return const HomeScreen();
      },
    );
  }
}

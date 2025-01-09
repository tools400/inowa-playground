import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inowa/src/ui/widgets/email_text.dart';
import 'package:inowa/src/ui/widgets/error_banner.dart';
import 'package:inowa/src/ui/widgets/password_text.dart';
import 'package:inowa/src/ui/widgets/reset_password_link.dart';
import 'package:inowa/src/ui/widgets/scaffold_snackbar.dart';
import 'package:provider/provider.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/settings/ui_settings.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';

/// The mode of the current auth session, either [AuthMode.login] or [AuthMode.register].
// ignore: public_member_api_docs
enum AuthMode {
  login,
  register;

  String buttonLabel(BuildContext context) => this == AuthMode.login
      ? AppLocalizations.of(context)!.login
      : AppLocalizations.of(context)!.register;
}

/// Entrypoint example for various sign-in flows with Firebase.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';

  AuthMode mode = AuthMode.login;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<UIModel>(builder: (_, uiModel, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(mode == AuthMode.login
                ? AppLocalizations.of(context)!.hdg_Login
                : AppLocalizations.of(context)!.hdg_Registration),
            backgroundColor: ColorTheme.inversePrimary(context),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ErrorBanner(
                            errorMessage: error,
                            onClearError: clearError,
                          ),
                          Column(
                            // Anmeldedaten: Email & Passwort
                            children: [
                              EmailText(controller: emailController),
                              VSpace(),
                              PasswordText(
                                  errorText:
                                      AppLocalizations.of(context)!.required,
                                  controller: passwordController),
                            ],
                          ),
                          // 'Sign in' button...
                          VSpace(flex: 2),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _emailAndPassword,
                              child: Text(mode.buttonLabel(context)),
                            ),
                          ),
                          // 'Passwort vergessen' Button...
                          if (mode == AuthMode.login) ...[
                            VSpace(),
                            ResetPasswordLink(onPressed: _resetPassword),
                          ],
                          // Umschalten: anmelden/registrieren
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                TextSpan(
                                  text: mode == AuthMode.login
                                      ? '${AppLocalizations.of(context)!.txt_don_t_have_an_account} '
                                      : '${AppLocalizations.of(context)!.txt_you_have_an_account} ',
                                ),
                                TextSpan(
                                  text: mode == AuthMode.login
                                      ? AppLocalizations.of(context)!
                                          .register_now
                                      : AppLocalizations.of(context)!
                                          .click_to_login,
                                  style: const TextStyle(
                                    color: ColorTheme.linkColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      toggleMode();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });

  /// Führt die Anmeldung oder Registrierung aus.
  Future<void> _emailAndPassword() async {
    var isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      setError(AppLocalizations.of(context)!.err_missing_or_incorrect_values);
      return;
    } else {
      clearError();
    }

    try {
      if (mode == AuthMode.login) {
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else if (mode == AuthMode.register) {
        await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setError((e).message ?? '');
    } catch (e) {
      setError(e.toString());
    }
  }

  /// Setzt das Passwort zurück.
  Future _resetPassword() async {
    clearError();

    String? email;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                email = null;
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.send),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.enter_your_email),
              VSpace(),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
              ),
            ],
          ),
        );
      },
    );

    if (email != null) {
      sendPasswordResetEmail(email!);
    }
  }

  /// Sendet eine Email zum Zurücksetzten des Passworts.
  void sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldSnackbar.of(context)
          .show(AppLocalizations.of(context)!.txt_password_reset_email_is_sent);
    } catch (e) {
      setError(AppLocalizations.of(context)!.err_error_resetting);
    }
  }

  /// Schaltet den Modus zwischen "Anmeldung" und "Registrierung" um.
  void toggleMode() {
    clearError();

    setState(() {
      mode = mode == AuthMode.login ? AuthMode.register : AuthMode.login;
    });
  }

  /// Löscht das Fehler-Banner.
  void clearError() {
    setError('');
  }

  /// Zeigt das Fehlerbanner an.
  void setError(String errorText) {
    setState(() {
      error = errorText;
    });
  }
}

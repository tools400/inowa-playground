import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/src/ble/ble_logger.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inowa/main.dart';
import '/src/settings/ui_settings.dart';
import '../settings/internal/color_theme.dart';
import '/src/ui/widgets/widgets.dart';

/// Diese Klasse pflegt die Einstellungen der App.
/// Basiert auf: [Simple Settings Page](https://www.fluttertemplates.dev/widgets/must_haves/settings_page#settings_page_2).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController passwordController = TextEditingController();
  late User user;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  late BleLogger logger;

  @override
  void initState() {
    user = auth.currentUser!;
    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<UIModel, BleLogger>(builder: (_, uiModel, bleLogger, __) {
        // Sprache für den Versand von Google E-Mails.
        auth.setLanguageCode(uiModel.locale.languageCode);

        logger = bleLogger;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.mnu_Profile),
            backgroundColor: ColorTheme.inversePrimary(context),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Column(
                      children: [
                        ErrorBanner(
                          error: error,
                        ),
                        const VSpace(),
                        Text(
                          isEmailVerified
                              ? AppLocalizations.of(context)!.txt_Email_Verified
                              : AppLocalizations.of(context)!
                                  .txt_Email_has_not_been_verified,
                          style: TextStyle(
                            color: isEmailVerified
                                ? ColorTheme.ok(context)
                                : ColorTheme.error(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isEmailVerified) ...[
                          VSpace(),
                          ElevatedButton(
                            onPressed: sendEmailAndWaitForResponse,
                            child: Text(
                                AppLocalizations.of(context)!.verify_email),
                          ),
                        ],
                        const VSpace(flex: 2),
                        ElevatedButton(
                          onPressed: _signOut,
                          child: Text(AppLocalizations.of(context)!.sign_out),
                        ),
                        const VSpace(flex: 2),
                        ElevatedButton(
                          onPressed: _deleteProfile,
                          child: Text(
                              AppLocalizations.of(context)!.delete_profile),
                        ),
                      ],
                    ),
                  ),
                  const VSpace(flex: 2),
                  FractionallySizedBox(
                    widthFactor: .5,
                    child: PasswordText(
                      errorText: AppLocalizations.of(context)!.required,
                      controller: passwordController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

  bool get isEmailVerified {
    return user.emailVerified;
  }

  /// Example code for sign out.
  Future<void> _signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pop(context);
  }

  /// Sendet eine Email zur Überprüfung der Email Adresse und wartet auf eine Antwort.
  Future<void> sendEmailAndWaitForResponse() async {
    await sendVerificationEmail();
    await waitForEmailVerification();
  }

  /// Sendet eine Email zur Überprüfung der Email Adresse.
  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();

      ScaffoldSnackbar.of(context).show(
          AppLocalizations.of(context)!.txt_Verification_email_has_been_sent);
    }
  }

  /// Wartet darauf, dass der Benutzer den Link für Verifizierung seiner
  /// E-Mail Adresse geklickt hat.
  Future<void> waitForEmailVerification() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Refresh the user data
      await user.reload();

      if (isEmailVerified) {
        timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  /// Example code for delete user profile.
  Future<void> _deleteProfile() async {
    clearError();
    var isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    // Einholen Bestätigung zum Löschen des Benutzerprofils
    if (!await confirm(context,
        content: Text(
            AppLocalizations.of(context)!.txt_Delete_user_profile_continue))) {
      logger.debug('Operation canceled by the user.');
      return;
    }

    try {
      // Erstellen Anmeldedaten
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email ?? '', password: passwordController.text);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      // Löschen Benutzerprofil
      await FirebaseAuth.instance.currentUser!.delete();

      // Abmelden
      _signOut;

      // Seite schließen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setError(e.message ?? e.toString());
    } catch (e) {
      logger.error(e.toString());
    }
  }

  void clearError() {
    setError('');
  }

  void setError(String errorText) {
    setState(() {
      error = errorText;
    });
  }
}

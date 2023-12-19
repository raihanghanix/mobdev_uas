// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_app_demo/routes/home.dart';
import 'package:local_notification_app_demo/routes/register.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:local_notification_app_demo/widgets/logo.dart';
import '../utils/custom_theme.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackbar.danger(context, "Email dan password kosong!");
    } else if (!_emailController.text.contains('@')) {
      CustomSnackbar.danger(context, "Email tidak valid!");
    } else {
      final data = await DBController(context: context).login(
        _emailController.text,
        _passwordController.text,
      );
      if (data != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userId: data,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(shape36),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: shape36,
            children: [
              const Logo(withText: true, text: "Login"),
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: text16,
                        color: textLight,
                      ),
                    ),
                  ),
                  SizedBox(height: shape16),
                  TextField(
                    controller: _passwordController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(shape8),
                        borderSide: BorderSide(color: textLight),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: text16,
                        color: textLight,
                      ),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              Column(
                children: [
                  FilledButton(
                    onPressed: _handleLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(shape8),
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      padding: EdgeInsets.all(shape16),
                    ),
                    child: Text(
                      "Masuk",
                      style: CustomTextStyle().heading16(bgColor),
                    ),
                  ),
                  SizedBox(height: shape16),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: bgColor,
                      foregroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(shape8),
                        ),
                        side: BorderSide(color: primaryColor),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      padding: EdgeInsets.all(shape16),
                    ),
                    child: Text(
                      "Daftar",
                      style: CustomTextStyle().heading16(primaryColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

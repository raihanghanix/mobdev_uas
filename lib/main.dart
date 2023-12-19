import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/home.dart';
import 'package:local_notification_app_demo/routes/login.dart';
import 'package:local_notification_app_demo/utils/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_notification_app_demo/utils/file_controller.dart';
import 'package:local_notification_app_demo/widgets/loading.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<dynamic> _checkFile(BuildContext context) async {
    final file = await FileController(context: context).readFile("user.json");
    if (file.isEmpty) return null;
    final Map<String, dynamic> json = await jsonDecode(file);
    final userId = json['userId'];
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productiv',
      home: FutureBuilder(
        future: _checkFile(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState.name == 'waiting') {
            return const Scaffold(
              body: Center(
                child: LoadingIndicator(),
              ),
            );
          }
          return Scaffold(
            body: snapshot.data != null
                ? Home(
                    userId: snapshot.data,
                  )
                : const Login(),
          );
        },
      ),
      theme: applyTheme(),
    );
  }
}

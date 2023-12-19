// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/alarm.dart';
import 'package:local_notification_app_demo/routes/home_layout.dart';
import 'package:local_notification_app_demo/routes/profile.dart';
import 'package:local_notification_app_demo/routes/quotes.dart';
import 'package:local_notification_app_demo/routes/schedule.dart';
import 'package:local_notification_app_demo/routes/todo.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:local_notification_app_demo/widgets/loading.dart';
import 'package:local_notification_app_demo/widgets/logo.dart';
import '../utils/custom_theme.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      final data =
          await DBController(context: context).getUserById(widget.userId);
      setState(() {
        userData = data[0];
      });
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateUserData(Map<String, dynamic> newUserData) {
    if (mounted) {
      setState(() {
        userData = newUserData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: LoadingIndicator(),
        ),
      );
    }
    return DefaultTabController(
      // initialIndex: 2,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Productiv",
            style: CustomTextStyle().normal16(textDark),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Logo(size: 24),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: IconButton(
                color: secondaryColor,
                iconSize: 26,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        userData: userData,
                        updateUserData: updateUserData,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.account_circle,
                  color: primaryColor,
                ),
              ),
            ),
          ],
          shape: BorderDirectional(
            bottom: BorderSide(color: borderColor),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.edit_square)),
              Tab(icon: Icon(Icons.work_history)),
              Tab(icon: Icon(Icons.alarm)),
              Tab(icon: Icon(Icons.chat_bubble)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeLayout(
              userData: userData,
              updateUserData: updateUserData,
            ),
            Todo(
              userData: userData,
              updateUserData: updateUserData,
            ),
            Schedule(
              userData: userData,
              updateUserData: updateUserData,
            ),
            Alarm(
              userData: userData,
              updateUserData: updateUserData,
            ),
            const Quotes(),
          ],
        ),
      ),
    );
  }
}

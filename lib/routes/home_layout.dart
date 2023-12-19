// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_notification_app_demo/routes/alarm_item.dart';
import 'package:local_notification_app_demo/routes/random_quote.dart';
import 'package:local_notification_app_demo/routes/schedule_item.dart';
import 'package:local_notification_app_demo/routes/todo_item.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import '../utils/custom_theme.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) updateUserData;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  List<dynamic> todo = [];
  List<dynamic> schedule = [];
  List<dynamic> alarm = [];

  @override
  void initState() {
    super.initState();
    getTodo();
    getSchedule();
    getAlarm();
  }

  void getTodo() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      final data = await supabase
          .from('todo')
          .select()
          .eq('user_id', widget.userData['id'])
          .order('created_at', ascending: false)
          .limit(3);
      if (mounted) {
        setState(() {
          todo = data;
        });
      }
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  void getSchedule() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      final data = await supabase
          .from('schedule')
          .select()
          .eq('user_id', widget.userData['id'])
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          schedule = data;
        });
      }
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  void getAlarm() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      final data = await supabase
          .from('alarm')
          .select()
          .eq('user_id', widget.userData['id'])
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          alarm = data;
        });
      }
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(logo32),
      child: Column(
        children: [
          const RandomQuote(),
          const SizedBox(height: 32),
          todo.isEmpty && schedule.isEmpty && alarm.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 128 - 32),
                    SvgPicture.asset(
                      'assets/images/no_data.svg',
                      width: 128,
                    ),
                    SizedBox(height: shape16),
                    Text(
                      "Tidak Ada Data",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle().heading24(textDark),
                    ),
                    SizedBox(height: shape16),
                    Text(
                      "Silahkan tambahkan todo list, jadwal, atau alarm pada tab di sebelah.",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle().normal12(textLight),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Todo',
                      style: CustomTextStyle().heading24(textDark),
                    ),
                    SizedBox(height: shape16),
                    Wrap(
                      runSpacing: shape8,
                      children: List.generate(
                        todo.length,
                        (index) => TodoItem(
                          details: todo[index],
                          getTodo: getTodo,
                        ),
                      ),
                    ),
                    SizedBox(height: shape16),
                    Text(
                      'Jadwal',
                      style: CustomTextStyle().heading24(textDark),
                    ),
                    SizedBox(height: shape16),
                    Wrap(
                      runSpacing: shape8,
                      children: List.generate(
                        schedule.length,
                        (index) => ScheduleItem(
                          details: schedule[index],
                          getSchedule: getSchedule,
                        ),
                      ),
                    ),
                    SizedBox(height: shape16),
                    Text(
                      'Alarm',
                      style: CustomTextStyle().heading24(textDark),
                    ),
                    SizedBox(height: shape16),
                    Wrap(
                      runSpacing: shape8,
                      children: List.generate(
                        alarm.length,
                        (index) => AlarmItem(
                          details: alarm[index],
                          getAlarm: getAlarm,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/add_alarm.dart';
import 'package:local_notification_app_demo/routes/alarm_item.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import '../utils/custom_theme.dart';

class Alarm extends StatefulWidget {
  const Alarm({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) updateUserData;

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  List<dynamic> alarm = [];

  @override
  void initState() {
    super.initState();
    getAlarm();
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

  void addAlarm() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    final uuid = const Uuid().v4();
    try {
      await supabase.from('alarm').insert({
        'id': uuid,
        'user_id': widget.userData['id'],
        'time': DateTime.now().toLocal().toIso8601String(),
        'is_active': false,
        'created_at': DateTime.now().toLocal().toIso8601String(),
        'updated_at': DateTime.now().toLocal().toIso8601String(),
      });
      getAlarm();
      final List<dynamic> query =
          await supabase.from('alarm').select().eq('id', uuid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddAlarm(
            details: query[0],
            getAlarm: getAlarm,
            title: "Tambah Alarm",
          ),
        ),
      );
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(shape32),
      children: [
        Text(
          'Alarm',
          style: CustomTextStyle().heading24(textDark),
        ),
        SizedBox(height: shape16),
        FilledButton(
          onPressed: addAlarm,
          style: FilledButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(shape8),
              ),
            ),
            minimumSize: const Size(double.infinity, 60),
            padding: EdgeInsets.all(shape16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              SizedBox(width: shape8),
              Text(
                "Tambah Alarm",
                style: CustomTextStyle().heading16(bgColor),
              ),
            ],
          ),
        ),
        SizedBox(height: shape32),
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
    );
  }
}

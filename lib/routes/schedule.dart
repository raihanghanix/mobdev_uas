// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/add_schedule.dart';
import 'package:local_notification_app_demo/routes/schedule_item.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import '../utils/custom_theme.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) updateUserData;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<dynamic> schedule = [];

  @override
  void initState() {
    super.initState();
    getSchedule();
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

  void addSchedule() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    final uuid = const Uuid().v4();
    try {
      await supabase.from('schedule').insert({
        'id': uuid,
        'user_id': widget.userData['id'],
        'title': "Jadwal Baru",
        'deadline': DateTime.now().toLocal().toIso8601String(),
        'is_active': false,
        'desc': "Deskripsi jadwal",
        'created_at': DateTime.now().toLocal().toIso8601String(),
        'updated_at': DateTime.now().toLocal().toIso8601String(),
      });
      getSchedule();
      final List<dynamic> query =
          await supabase.from('schedule').select().eq('id', uuid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSchedule(
            details: query[0],
            getSchedule: getSchedule,
            title: "Tambah Jadwal",
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
          'Jadwal',
          style: CustomTextStyle().heading24(textDark),
        ),
        SizedBox(height: shape16),
        FilledButton(
          onPressed: addSchedule,
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
                "Tambah Jadwal",
                style: CustomTextStyle().heading16(bgColor),
              ),
            ],
          ),
        ),
        SizedBox(height: shape32),
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
      ],
    );
  }
}

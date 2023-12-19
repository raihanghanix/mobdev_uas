// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/add_schedule.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import '../utils/custom_theme.dart';

class ScheduleItem extends StatefulWidget {
  const ScheduleItem({
    super.key,
    required this.details,
    required this.getSchedule,
  });

  final Map<String, dynamic> details;
  final Function getSchedule;

  @override
  State<ScheduleItem> createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  DateTime getDate() {
    final timestamp = widget.details['deadline'];
    final dateTimeString = timestamp.substring(0, 19);
    final parsedDateTime = DateTime.parse(dateTimeString);
    return parsedDateTime;
  }

  void deleteSchedule() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      await supabase.from('schedule').delete().eq('id', widget.details['id']);
      await widget.getSchedule();
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSchedule(
                  details: widget.details,
                  getSchedule: widget.getSchedule,
                  title: "Edit Jadwal",
                ),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(shape16),
            minimumSize: Size(280, shape32),
            foregroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(shape8),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.details['title'],
                style: CustomTextStyle().normal16(textDark),
              ),
              SizedBox(height: shape16),
              Text(
                "Tenggat: ${getDate().day}/${getDate().month}/${getDate().year}, ${getDate().hour}:${getDate().minute}",
                style: CustomTextStyle().heading12(primaryColor),
              ),
              SizedBox(height: shape16),
              Text(
                widget.details['is_active'] ? "Alarm hidup" : "Alarm mati",
                style: CustomTextStyle().normal10(textLight),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: deleteSchedule,
          padding: EdgeInsets.zero,
          color: dangerColor,
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }
}

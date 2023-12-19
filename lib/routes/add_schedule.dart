// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/Services/notifi_service.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import '../utils/custom_theme.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({
    super.key,
    required this.details,
    required this.getSchedule,
    required this.title,
  });

  final Map<String, dynamic> details;
  final Function getSchedule;
  final String title;

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final title = TextEditingController();
  final desc = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    title.text = widget.details['title'];
    desc.text = widget.details['desc'];
    isActive = widget.details['is_active'];

    final deadline = DateTime.parse(widget.details['deadline']);
    selectedDate = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
      deadline.hour,
      deadline.minute,
    );
    selectedTime = TimeOfDay(
      hour: deadline.hour,
      minute: deadline.minute,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  DateTime getDate() {
    final timestamp = widget.details['updated_at'];
    final dateTimeString = timestamp.substring(0, 19);
    final parsedDateTime = DateTime.parse(dateTimeString);
    return parsedDateTime;
  }

  void updateSchedule() async {
    if (DateTime.now().day > selectedDate.day) {
      CustomSnackbar.danger(context, "Tanggal telah lewat!");
    } else if (DateTime.now().day == selectedDate.day &&
        TimeOfDay.now().hour > selectedTime.hour) {
      CustomSnackbar.danger(context, "Waktu telah lewat!");
    } else if (DateTime.now().day == selectedDate.day &&
        TimeOfDay.now().minute > selectedTime.minute) {
      CustomSnackbar.danger(context, "Waktu telah lewat!");
    } else {
      final SupabaseClient supabase =
          DBController(context: context).supabase(context);
      try {
        await supabase.from('schedule').update({
          'title': title.text,
          'deadline': DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          ).toLocal().toIso8601String(),
          'is_active': isActive,
          'desc': desc.text,
          'updated_at': DateTime.now().toLocal().toIso8601String(),
        }).eq(
          'id',
          widget.details['id'],
        );
        await widget.getSchedule();
        NotificationService().showScheduledNotification(
            title: title.text,
            body: desc.text,
            formattedString: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            ).toUtc().add(const Duration(hours: 7)).toString());
        Navigator.of(context).pop();
      } catch (e) {
        CustomSnackbar.danger(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: CustomTextStyle().heading16(textDark),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: updateSchedule,
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
        ),
        shape: BorderDirectional(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(shape36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextInput(title: title),
            SizedBox(height: shape8),
            Text(
              "Terakhir dilihat: ${getDate().day}/${getDate().month}/${getDate().year}, ${getDate().hour}:${getDate().minute}",
              style: CustomTextStyle().normal12(textLight),
            ),
            SizedBox(height: shape36),
            Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(shape16),
                ),
              ),
              padding: EdgeInsets.all(shape8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: CustomTextStyle().normal16(textLight),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      _selectDate(context);
                    },
                    style: IconButton.styleFrom(backgroundColor: primaryColor),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ),
            SizedBox(height: shape16),
            Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(shape16),
                ),
              ),
              padding: EdgeInsets.all(shape8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      '${selectedTime.hour}:${selectedTime.minute}',
                      style: CustomTextStyle().normal16(textLight),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      _selectTime(context);
                    },
                    style: IconButton.styleFrom(backgroundColor: primaryColor),
                    icon: const Icon(Icons.alarm),
                  ),
                ],
              ),
            ),
            SizedBox(height: shape36),
            Text(
              "Alarm",
              style: CustomTextStyle().heading16(textDark),
            ),
            SizedBox(height: shape16),
            Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.all(shape8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isActive = false;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: !isActive ? dangerColor : bgColor,
                      ),
                      child: Text(
                        "Mati",
                        style: CustomTextStyle().normal16(
                          !isActive ? bgColor : textDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: shape8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isActive = true;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: isActive ? successColor : bgColor,
                      ),
                      child: Text(
                        "Hidup",
                        style: CustomTextStyle()
                            .normal16(isActive ? bgColor : textDark),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: shape36),
            Text(
              "Deskripsi",
              style: CustomTextStyle().heading16(textDark),
            ),
            CustomTextInput(title: desc, isDesc: true),
          ],
        ),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({super.key, required this.title, this.isDesc = false});
  final TextEditingController title;
  final bool isDesc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: title,
      style: isDesc
          ? CustomTextStyle().normal12(textLight)
          : CustomTextStyle().heading24(textDark),
      cursorColor: textDark,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: bgColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: bgColor),
        ),
      ),
    );
  }
}

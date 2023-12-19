// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import '../utils/custom_theme.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({
    super.key,
    required this.details,
    required this.getTodo,
    required this.title,
  });

  final Map<String, dynamic> details;
  final Function getTodo;
  final String title;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final time = DateTime.now();
  final title = TextEditingController(text: "");
  List<dynamic> content = [];
  List<dynamic> isChecked = [];

  @override
  void initState() {
    super.initState();
    title.text = widget.details['title'];
    content = widget.details['content'];
    isChecked = widget.details['is_checked'];
  }

  DateTime getDate() {
    final timestamp = widget.details['updated_at'];
    final dateTimeString = timestamp.substring(0, 19);
    final parsedDateTime = DateTime.parse(dateTimeString);
    return parsedDateTime;
  }

  void updateTodo() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      await supabase.from('todo').update({
        'title': title.text,
        'updated_at': DateTime.now().toLocal().toIso8601String(),
        'content': content,
        'is_checked': isChecked,
      }).eq(
        'id',
        widget.details['id'],
      );
      await widget.getTodo();
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
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
          onPressed: updateTodo,
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
            SizedBox(height: shape32),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (content.length > 1 || isChecked.length > 1) {
                        setState(() {
                          content.removeLast();
                          isChecked.removeLast();
                        });
                      }
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
                      minimumSize: const Size(double.infinity, 32),
                      padding: EdgeInsets.all(shape16),
                    ),
                    child: Text(
                      "-",
                      style: CustomTextStyle().heading16(
                        primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: shape8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        content.add("Item todo");
                        isChecked.add(false);
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(shape8),
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 32),
                      padding: EdgeInsets.all(shape16),
                    ),
                    child: Text(
                      "+",
                      style: CustomTextStyle().heading16(
                        bgColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: shape32),
            Column(
              children: List.generate(
                content.length,
                (index) => Row(
                  children: [
                    Checkbox(
                      value: isChecked[index],
                      onChanged: (value) {
                        setState(() {
                          isChecked[index] = value;
                        });
                      },
                      activeColor: primaryColor,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(shape36),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: content[index],
                        ),
                        onChanged: (value) {
                          content[index] = value;
                        },
                        maxLines: null,
                        style: CustomTextStyle().normal16(textDark),
                        cursorColor: textDark,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: bgColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: bgColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    required this.title,
  });

  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: title,
      style: CustomTextStyle().heading24(textDark),
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

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/add_todo.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import '../utils/custom_theme.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.details, required this.getTodo});

  final Map<String, dynamic> details;
  final Function getTodo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  DateTime getDate() {
    final timestamp = widget.details['updated_at'];
    final dateTimeString = timestamp.substring(0, 19);
    final parsedDateTime = DateTime.parse(dateTimeString);
    return parsedDateTime;
  }

  void deleteTodo() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      await supabase.from('todo').delete().eq('id', widget.details['id']);
      await widget.getTodo();
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> isChecked = [...widget.details['is_checked']];
    final filteredList = isChecked.where((bool element) => element).toList();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodo(
                  details: widget.details,
                  getTodo: widget.getTodo,
                  title: "Edit Todo",
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
                "${filteredList.length} dari ${widget.details['content'].length} selesai",
                style: CustomTextStyle().heading12(primaryColor),
              ),
              SizedBox(height: shape16),
              Text(
                "${getDate().day}/${getDate().month}/${getDate().year}, ${getDate().hour}:${getDate().minute}",
                style: CustomTextStyle().normal10(textLight),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: deleteTodo,
          padding: EdgeInsets.zero,
          color: dangerColor,
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }
}

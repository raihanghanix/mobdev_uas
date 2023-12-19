// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/add_todo.dart';
import 'package:local_notification_app_demo/routes/todo_item.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/utils/db_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import '../utils/custom_theme.dart';

class Todo extends StatefulWidget {
  const Todo({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) updateUserData;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<dynamic> todo = [];

  @override
  void initState() {
    super.initState();
    getTodo();
  }

  void getTodo() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    try {
      final data = await supabase
          .from('todo')
          .select()
          .eq('user_id', widget.userData['id'])
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          todo = data;
        });
      }
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
    }
  }

  void addTodo() async {
    final SupabaseClient supabase =
        DBController(context: context).supabase(context);
    final uuid = const Uuid().v4();
    try {
      await supabase.from('todo').insert({
        'id': uuid,
        'user_id': widget.userData['id'],
        'title': "Todo Baru",
        'content': ["Item todo"],
        'is_checked': [false],
        'created_at': DateTime.now().toLocal().toIso8601String(),
        'updated_at': DateTime.now().toLocal().toIso8601String(),
      });
      getTodo();
      final List<dynamic> query =
          await supabase.from('todo').select().eq('id', uuid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTodo(
            details: query[0],
            getTodo: getTodo,
            title: "Tambah Todo",
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
          'Todo',
          style: CustomTextStyle().heading24(textDark),
        ),
        SizedBox(height: shape16),
        FilledButton(
          onPressed: addTodo,
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
                "Tambah Todo",
                style: CustomTextStyle().heading16(bgColor),
              ),
            ],
          ),
        ),
        SizedBox(height: shape32),
        Wrap(
          runSpacing: shape8,
          children: List.generate(
            todo.length,
            (index) => TodoItem(details: todo[index], getTodo: getTodo),
          ),
        ),
      ],
    );
  }
}

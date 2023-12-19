// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/utils/file_controller.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class DBController {
  DBController({required this.context});
  final BuildContext context;

  final url = dotenv.env['SUPABASE_URL'] ?? 'url';
  final key = dotenv.env['SUPABASE_KEY'] ?? 'key';

  SupabaseClient supabase(BuildContext context) {
    try {
      final SupabaseClient supabase = SupabaseClient(url, key);
      return supabase;
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getUser(String email) async {
    try {
      final List<dynamic> user =
          await supabase(context).from('user2').select().eq('email', email);
      return user;
    } catch (e) {
      return CustomSnackbar.danger(context, e.toString());
    }
  }

  Future<dynamic> getUserById(String id) async {
    try {
      final List<dynamic> user =
          await supabase(context).from('user2').select().eq('id', id);
      return user;
    } catch (e) {
      return CustomSnackbar.danger(context, e.toString());
    }
  }

  Future<dynamic> register(String email, String password) async {
    try {
      final List<dynamic> user = await getUser(email);
      final uuid = const Uuid().v4();
      if (user.isNotEmpty) {
        CustomSnackbar.danger(context, "Email sudah terdaftar!");
        return null;
      }
      await supabase(context).from('user2').insert({
        'id': uuid,
        'email': email,
        'password': password,
        'created_at': DateTime.now().toLocal().toIso8601String(),
        'updated_at': DateTime.now().toLocal().toIso8601String(),
      });
      await FileController(context: context).writeFile(
        'user.json',
        jsonEncode({'userId': uuid}),
      );
      return uuid;
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      return null;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final List<dynamic> user = await getUser(email);
      if (user.isEmpty) {
        CustomSnackbar.danger(context, "Email tidak terdaftar!");
        return null;
      } else if (user.isNotEmpty && password != user[0]['password']) {
        CustomSnackbar.danger(context, "Email atau password salah!");
        return null;
      }
      await FileController(context: context).writeFile(
        'user.json',
        jsonEncode({'userId': user[0]['id']}),
      );
      return user[0]['id'];
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      return false;
    }
  }

  Future<dynamic> changeEmail(String email, String userId) async {
    try {
      await supabase(context).from('user2').update({'email': email}).eq(
        'id',
        userId,
      );
      return true;
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      return false;
    }
  }
}

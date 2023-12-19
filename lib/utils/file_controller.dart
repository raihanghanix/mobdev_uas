// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';

class FileController {
  FileController({required this.context});

  final BuildContext context;

  Future<String> getPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      throw Exception(e.toString());
    }
  }

  Future<File> writeFile(String filename, String content) async {
    try {
      final path = await getPath();
      final file = File('$path/$filename');
      return file.writeAsString(content);
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> readFile(String filename) async {
    try {
      final path = await getPath();
      final file = File('$path/$filename');
      if (file.existsSync()) {
        final contents = await file.readAsString();
        return contents;
      }
      return "";
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> deleteFile(String filename) async {
    try {
      final path = await getPath();
      final file = File('$path/$filename');
      if (file.existsSync()) file.delete();
    } catch (e) {
      CustomSnackbar.danger(context, e.toString());
      throw Exception(e.toString());
    }
  }
}

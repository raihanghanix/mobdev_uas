import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import '../utils/custom_theme.dart';

class CustomSnackbar {
  CustomSnackbar.success(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: successColor,
        padding: EdgeInsets.all(shape16),
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: CustomTextStyle().heading12(bgColor),
        ),
      ),
    );
  }
  CustomSnackbar.danger(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: dangerColor,
        padding: EdgeInsets.all(shape16),
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: CustomTextStyle().heading12(bgColor),
        ),
      ),
    );
  }
}

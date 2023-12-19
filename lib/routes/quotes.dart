import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/routes/quotes_item.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import '../utils/custom_theme.dart';

class Quotes extends StatelessWidget {
  const Quotes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(shape32),
      children: [
        Text(
          'Quotes',
          style: CustomTextStyle().heading24(textDark),
        ),
        SizedBox(height: shape32),
        Wrap(
          runSpacing: shape8,
          children: List.generate(
            5,
            (index) => const QuotesItem(),
          ),
        ),
      ],
    );
  }
}

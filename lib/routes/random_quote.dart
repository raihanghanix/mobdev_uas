import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import '../utils/custom_theme.dart';

class RandomQuote extends StatefulWidget {
  const RandomQuote({super.key});

  @override
  State<RandomQuote> createState() => _QuoteState();
}

class _QuoteState extends State<RandomQuote> {
  String author = "Loading...";
  String text = "Loading...";
  bool isLoading = false;

  Future<dynamic> getQuote() async {
    const url = "https://zenquotes.io/api/quotes";
    final res = await http.get(
      Uri.parse(url),
    );
    final List<dynamic> body = jsonDecode(res.body);
    Random random = Random();
    int randomNumber = random.nextInt(body.length);
    if (mounted) {
      setState(() {
        author = "~ ${body[randomNumber]['a']} ~";
        text = "“${body[randomNumber]['q']}”";
      });
    }
    return body;
  }

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: borderColor,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(shape8),
        ),
      ),
      padding: EdgeInsets.all(shape16),
      child: Column(
        children: [
          Text(
            'Random Quote',
            textAlign: TextAlign.center,
            style: CustomTextStyle().heading16(bgColor),
          ),
          SizedBox(height: shape8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: CustomTextStyle().heading12(bgColor),
          ),
          SizedBox(height: shape8),
          Text(
            author,
            textAlign: TextAlign.center,
            style: CustomTextStyle().normal12(bgColor),
          ),
        ],
      ),
    );
  }
}

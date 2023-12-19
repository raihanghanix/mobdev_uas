import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import 'package:local_notification_app_demo/widgets/custom_snackbar.dart';
import '../utils/custom_theme.dart';

class QuotesItem extends StatefulWidget {
  const QuotesItem({super.key});

  @override
  State<QuotesItem> createState() => _QuotesItemState();
}

class _QuotesItemState extends State<QuotesItem> {
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

  void handleClick(BuildContext context) {
    FlutterClipboard.copy("$text $author")
        .then(
          (value) => CustomSnackbar.success(context, "Berhasil disalin!"),
        )
        .catchError(
          (error) => CustomSnackbar.danger(context, "Gagal menyalin!"),
        );
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            handleClick(context);
          },
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(shape16),
            minimumSize: Size(280, shape32),
            maximumSize: const Size(280, 140),
            foregroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(shape8),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: CustomTextStyle().normal12(textDark),
              ),
              SizedBox(height: shape16),
              Text(
                author,
                style: CustomTextStyle().normal12(textLight),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            handleClick(context);
          },
          padding: EdgeInsets.zero,
          color: primaryColor,
          icon: const Icon(Icons.copy),
        )
      ],
    );
  }
}

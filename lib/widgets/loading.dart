import 'package:flutter/material.dart';
import '../utils/custom_theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: null,
      color: primaryColor,
    );
  }
}

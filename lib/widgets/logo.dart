import 'package:flutter/material.dart';
import 'package:local_notification_app_demo/utils/custom_text_style.dart';
import '../utils/custom_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.withText = false,
    this.text = "",
    this.size = 64,
  });

  final bool withText;
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (withText) {
      return Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: shape16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(shape16),
            child: SvgPicture.asset('assets/images/logo.svg', width: size),
          ),
          Text(
            text,
            style: CustomTextStyle().heading36(textDark),
          ),
        ],
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(shape16),
      child: SvgPicture.asset('assets/images/logo.svg', width: size),
    );
  }
}

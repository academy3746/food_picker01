import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  const SectionText({
    super.key,
    required this.textContent,
    this.textSize,
    this.textColor,
    this.textWeight,
  });

  final String textContent;

  final double? textSize;

  final Color? textColor;

  final FontWeight? textWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent,
      style: TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: textWeight,
      ),
    );
  }
}

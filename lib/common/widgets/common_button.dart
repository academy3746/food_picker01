import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.btnText,
    this.btnBackgroundColor,
    this.textColor,
    required this.btnAction,
  });

  final String btnText;

  final Color? btnBackgroundColor;

  final Color? textColor;

  final Function btnAction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => btnAction.call(),
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.size6),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          color: textColor,
          fontSize: Sizes.size18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

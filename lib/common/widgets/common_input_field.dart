import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.enabled,
    required this.readOnly,
    this.onTap,
    this.onFieldSubmitted,
    this.hintText,
    required this.obscureText,
    this.initialValue,
    required this.maxLines,
    this.maxLength,
    required this.validator,
  });

  final TextEditingController controller;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final bool? enabled;

  final bool readOnly;

  final Function()? onTap;

  final Function(String value)? onFieldSubmitted;

  final String? hintText;

  final bool obscureText;

  final String? initialValue;

  final int maxLines;

  final int? maxLength;

  final FormFieldValidator validator;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Sizes.size10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.grey.shade500,
            ),
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.redAccent,
            ),
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
        ),
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        onTap: widget.readOnly ? widget.onTap : null,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.obscureText,
        initialValue: widget.initialValue,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        validator: (value) => widget.validator(value),
      ),
    );
  }
}

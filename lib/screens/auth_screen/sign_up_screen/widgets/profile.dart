// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class BuildProfile extends StatelessWidget {
  const BuildProfile({
    super.key,
    this.profileImg,
  });

  final File? profileImg;

  @override
  Widget build(BuildContext context) {
    if (profileImg == null) {
      return Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade400,
          radius: Sizes.size48,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: Sizes.size48,
          ),
        ),
      );
    } else {
      return Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade400,
          radius: Sizes.size48,
          backgroundImage: FileImage(profileImg!),
        ),
      );
    }
  }
}

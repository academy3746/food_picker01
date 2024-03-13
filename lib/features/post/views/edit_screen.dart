import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static const String routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostAppBar(
        title: '맛집 등록하기',
        isLeading: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(Sizes.size20),
      ),
    );
  }
}

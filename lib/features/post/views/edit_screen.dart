import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/image_uploader.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static const String routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  /// 이미지 파일 업로드 객체
  File? storeImg;

  /// 파일 업로드 기능 수행
  late ImageUploader uploader;

  @override
  void initState() {
    super.initState();

    uploader = ImageUploader(
      context: context,
      imgFile: storeImg,
      onImageUploaded: _onImageUploaded,
    );
  }

  /// ImageUploader 콜백 동작 별도 처리
  void _onImageUploaded(File? file) {
    setState(() {
      storeImg = file;
    });
  }

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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              /// 사진 등록
              GestureDetector(
                onTap: () async {
                  await uploader.showImageUploadBottomSheet();
                },
                child: uploader.postImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

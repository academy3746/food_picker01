import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static const String routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  /// 갤러리 경로 접근 객체
  File? storeImg;

  /// 사진 등록 Bottom Sheet Dialog
  Future<void> _showImageUpload() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            top: Sizes.size10,
            bottom: Sizes.size10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await _takePhoto();
                },
                child: const Text(
                  '촬영하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await _getGalleryImage();
                },
                child: const Text(
                  '갤러리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await _deleteImage();
                },
                child: const Text(
                  '사진 삭제',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 사진 촬영
  Future<void> _takePhoto() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );

    if (image != null) {
      setState(() {
        storeImg = File(image.path);
      });
    }
  }

  /// 갤러리에서 사진 선택
  Future<void> _getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (image != null) {
      setState(() {
        storeImg = File(image.path);
      });
    }
  }

  /// 사진 삭제
  Future<void> _deleteImage() async {
    setState(() {
      storeImg = null;
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
                  await _showImageUpload();
                },
                child: postImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 맛집 사진 등록
  Widget postImage() {
    return Container(
      height: Sizes.size150,
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.size6),
        ),
      ),
      child: const Icon(
        Icons.image_search_rounded,
        color: Colors.white,
        size: Sizes.size96,
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  final BuildContext context;

  final File? imgFile;

  final void Function(File? image) onImageUploaded;

  ImageUploader({
    required this.context,
    required this.imgFile,
    required this.onImageUploaded,
  });

  /// 사진 촬영
  Future<void> takePhoto() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );

    if (image != null) {
      onImageUploaded(File(image.path));
    }
  }

  /// 갤러리에서 이미지 선택
  Future<void> getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (image != null) {
      onImageUploaded(File(image.path));
    }
  }

  /// 삭제
  Future<void> deleteImage() async {
    onImageUploaded(null);
  }

  /// 이미지 업로드 관련 BottomSheet Modal Pop Up
  Future<void> showImageUploadBottomSheet() async {
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

                  await takePhoto();
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

                  await getGalleryImage();
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

                  await deleteImage();
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
}

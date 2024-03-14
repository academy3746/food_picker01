// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:daum_postcode_search/data_model.dart';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/app_snackbar.dart';
import 'package:food_picker/common/utils/common_button.dart';
import 'package:food_picker/common/utils/common_input_field.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/common/utils/image_uploader.dart';
import 'package:food_picker/data/model/food_store.dart';
import 'package:food_picker/features/post/views/post_webview_screen.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static const String routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  /// 이미지 파일 업로드 객체 생성
  File? storeImg;

  /// 프로필 이미지 주소
  String? imageUrl;

  /// 파일 업로드 기능 수행
  late ImageUploader uploader;

  /// Text Input Field Controller 객체 생성
  final _storeAddrController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeCommentController = TextEditingController();

  /// Validate Text Input Field
  final _formKey = GlobalKey<FormState>();

  /// 다음 주소 API 객체 선언
  DataModel? dataModel;

  /// Initialize Supabase Console
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    uploader = ImageUploader(
      context: context,
      imgFile: storeImg,
      onImageUploaded: _onImageUploaded,
    );
  }

  /// 소프트 키보드 비활성화
  void _keyboardDismiss() {
    FocusScope.of(context).unfocus();
  }

  /// ImageUploader 콜백 동작 별도 처리
  void _onImageUploaded(File? file) {
    setState(() {
      storeImg = file;
    });
  }

  /// 입력필드 검증
  _storeAddrValidation(value) {
    if (value.isEmpty) {
      return '맛집의 주소를 입력해 주세요!';
    }

    return null;
  }

  /// 맛집 별명 검증
  _storeNameValidation(value) {
    if (value.isEmpty) {
      return '맛집의 별명을 입력해 주세요!';
    }

    return null;
  }

  /// 맛집 메모 검증
  _storeCommentValidation(value) {
    if (value.isEmpty) {
      return '맛집 관련 설명을 입력해 주세요!';
    }

    return null;
  }

  /// Data INSERT on `food_store` Table
  Future<bool> _editFoodStoreInfo(String storeAddrValue, String storeNameValue,
      String storeCommentValue) async {
    /// 1. 이미지 업로드
    if (storeImg != null) {
      var now = DateTime.now();

      var path = 'stores/_$now.jpg';

      final imgFile = storeImg;

      await _supabase.storage.from('food_pick').upload(
            path,
            imgFile!,
            fileOptions: const FileOptions(upsert: true),
          );

      imageUrl = _supabase.storage.from('food_pick').getPublicUrl(path);
    }

    /// 2. Naver Geocoding API 활용 주소 변환
    final String naverApiUrl =
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=${_storeAddrController.text}';

    final naverApiResponse = await http.get(
      Uri.parse(naverApiUrl),
      headers: <String, String>{
        'X-NCP-APIGW-API-KEY-ID': '0ldmdl71hs',
        'X-NCP-APIGW-API-KEY': 'X8A2rJntOPYTSYlax8wtstKlOlJ12hcykYusUzyX',
        'Accept': 'application/json',
      },
    );

    if (naverApiResponse.statusCode == 200) {
      Map<String, dynamic> fromNaver = jsonDecode(naverApiResponse.body);

      if (fromNaver['meta']['totalCount'] == 0) {
        if (!mounted) return false;
        var snackbar = AppSnackbar(
          context: context,
          msg: '위치 계산이 잘못 되었습니다.',
        );

        snackbar.showSnackbar(context);

        return false;
      }

      double lat = double.parse(fromNaver['addresses'][0]['y']);
      double lng = double.parse(fromNaver['addresses'][0]['x']);

      /// 3. DB INSERT
      await _supabase.from('food_store').insert(
            FoodStoreModel(
              storeImgUrl: imageUrl,
              latitude: lat,
              longitude: lng,
              storeAddress: storeAddrValue,
              uid: _supabase.auth.currentUser!.id,
              storeName: storeNameValue,
              storeComment: storeCommentValue,
            ).toMap(),
          );

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostAppBar(
        title: '맛집 등록하기',
        isLeading: true,
      ),
      body: GestureDetector(
        onTap: _keyboardDismiss,
        child: Container(
          margin: const EdgeInsets.all(Sizes.size20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 사진 등록
                  GestureDetector(
                    onTap: () async {
                      await uploader.showImageUploadBottomSheet();
                    },
                    child: postImage(),
                  ),

                  /// 맛집 위치
                  Container(
                    margin: const EdgeInsets.only(top: Sizes.size24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          textContent: '맛집 위치 (도로명 주소)',
                          textSize: Sizes.size20,
                          textColor: Colors.black,
                          textWeight: FontWeight.w700,
                        ),
                        InputField(
                          controller: _storeAddrController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          readOnly: true,
                          onTap: () async {
                            /// Navigate PostCode WebView Screen
                            var result = await Navigator.pushNamed(
                              context,
                              WebViewScreen.routeName,
                            );

                            if (result != null) {
                              setState(() {
                                dataModel = result as DataModel?;

                                _storeAddrController.text =
                                    dataModel?.roadAddress ??
                                        '올바른 주소를 선택해 주세요!';
                              });
                            }
                          },
                          hintText: '터치 & 주소 입력',
                          obscureText: false,
                          maxLines: 1,
                          validator: (value) => _storeAddrValidation(value),
                        ),
                      ],
                    ),
                  ),

                  /// 맛집 별명
                  Container(
                    margin: const EdgeInsets.only(top: Sizes.size24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          textContent: '맛집 별명',
                          textSize: Sizes.size20,
                          textColor: Colors.black,
                          textWeight: FontWeight.w700,
                        ),
                        InputField(
                          controller: _storeNameController,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          readOnly: false,
                          onTap: null,
                          hintText: '맛집의 별명을 입력해 주세요',
                          obscureText: false,
                          maxLines: 1,
                          validator: (value) => _storeNameValidation(value),
                        ),
                      ],
                    ),
                  ),

                  /// 맛집 설명
                  Container(
                    margin: const EdgeInsets.only(top: Sizes.size24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          textContent: '맛집 설명',
                          textSize: Sizes.size20,
                          textColor: Colors.black,
                          textWeight: FontWeight.w700,
                        ),
                        InputField(
                          controller: _storeCommentController,
                          textInputAction: TextInputAction.newline,
                          enabled: true,
                          readOnly: false,
                          onTap: null,
                          hintText: '맛집 관련 설명을 입력해 주세요',
                          obscureText: false,
                          maxLines: 5,
                          maxLength: 1000,
                          validator: (value) => _storeCommentValidation(value),
                        ),
                      ],
                    ),
                  ),

                  /// 작성 완료 Button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.size68,
                    margin: const EdgeInsets.symmetric(vertical: Sizes.size32),
                    child: CommonButton(
                      btnBackgroundColor: Theme.of(context).primaryColor,
                      btnText: '작성 완료',
                      textColor: Colors.white,
                      btnAction: () async {
                        var storeAddrValue = _storeAddrController.text;
                        var storeNameValue = _storeNameController.text;
                        var storeCommentValue = _storeCommentController.text;

                        /// 1. Validation
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        /// 2. DB INSERT
                        bool success = await _editFoodStoreInfo(
                          storeAddrValue,
                          storeNameValue,
                          storeCommentValue,
                        );

                        if (!context.mounted) return;

                        if (!success) {
                          var snackbar = AppSnackbar(
                            context: context,
                            msg: '게시물 등록 중 문제가 발생하였습니다.',
                          );

                          snackbar.showSnackbar(context);

                          Navigator.pop(context);

                          return;
                        } else {
                          var snackbar = AppSnackbar(
                            context: context,
                            msg: '게시물을 정상적으로 등록하였습니다.',
                          );

                          snackbar.showSnackbar(context);

                          Navigator.pop(
                            context,
                            'edit_completed',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 사진 등록 Container
  Widget postImage() {
    if (storeImg == null) {
      return Center(
        child: Container(
          height: Sizes.size250,
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            color: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.size6),
            ),
          ),
          child: const Icon(
            Icons.image_search_rounded,
            color: Colors.white,
            size: Sizes.size96,
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          height: Sizes.size250,
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(Sizes.size6),
            ),
          ),
          child: Image.file(
            storeImg!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

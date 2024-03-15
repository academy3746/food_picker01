// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/app_snackbar.dart';
import 'package:food_picker/common/utils/common_button.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/features/post/models/favorite_store.dart';
import 'package:food_picker/features/auth/models/member.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/widgets/data_container.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.model,
  });

  static const String routeName = '/detail';

  final FoodStoreModel model;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  /// Initialize Supabase Console
  final _supabase = Supabase.instance.client;

  /// 글쓴이 닉네임 멤버 변수 생성
  String? _memberNick;

  /// 찜하기 상태 Boolean
  bool _favorite = false;

  /// 게시물 글쓴이 확인
  Future<void> _getUploaderName() async {
    final memberMap = await _supabase.from('member').select().eq(
          'uid',
          widget.model.uid,
        );

    MemberModel memberModel =
        memberMap.map((data) => MemberModel.fromMap(data)).single;

    setState(() {
      _memberNick = memberModel.name;
    });
  }

  /// 게시물 찜하기
  Future<void> _likeThisStore() async {
    await _supabase.from('favorite_store').upsert(
          FavoriteModel(
            foodStoreIdx: widget.model.idx!,
            favoriteUid: _supabase.auth.currentUser!.id,
          ).toMap(),
        );
  }

  /// 게시물 찜하기 취소
  Future<void> _dislikeThisStore() async {
    await _supabase
        .from('favorite_store')
        .delete()
        .eq(
          'food_store_idx',
          widget.model.idx!,
        )
        .eq(
          'favorite_uid',
          _supabase.auth.currentUser!.id,
        );
  }

  /// 게시물 찜하기 상태 확인
  Future<void> _getFavorite() async {
    final favoriteMap = await _supabase
        .from('favorite_store')
        .select()
        .eq(
          'food_store_idx',
          widget.model.idx!,
        )
        .eq(
          'favorite_uid',
          _supabase.auth.currentUser!.id,
        );

    if (favoriteMap.isNotEmpty) {
      setState(() {
        _favorite = true;
      });
    } else {
      setState(() {
        _favorite = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getUploaderName();

    _getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostAppBar(
        title: widget.model.storeName,
        isLeading: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.all(Sizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 이미지 파일
              postImage(),

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
                    DataContainer(foodStoreModel: widget.model.storeAddress),
                  ],
                ),
              ),

              /// 글쓴이
              Container(
                margin: const EdgeInsets.only(top: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      textContent: '글쓴이',
                      textSize: Sizes.size20,
                      textColor: Colors.black,
                      textWeight: FontWeight.w700,
                    ),
                    DataContainer(foodStoreModel: _memberNick ?? ''),
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
                    DataContainer(foodStoreModel: widget.model.storeComment),
                  ],
                ),
              ),

              /// 찜하기 Button
              _favorite
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: Sizes.size68,
                      margin:
                          const EdgeInsets.symmetric(vertical: Sizes.size32),
                      child: CommonButton(
                        btnBackgroundColor: Colors.grey.shade400,
                        btnText: '해제하기',
                        textColor: Colors.white,
                        btnAction: () async {
                          var snackbar = AppSnackbar(
                            context: context,
                            msg: '찜하기를 해제하였습니다!',
                          );

                          snackbar.showSnackbar(context);

                          await _dislikeThisStore();

                          await _getFavorite();
                        },
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: Sizes.size68,
                      margin:
                          const EdgeInsets.symmetric(vertical: Sizes.size32),
                      child: CommonButton(
                        btnBackgroundColor: Theme.of(context).primaryColor,
                        btnText: '찜하기',
                        textColor: Colors.white,
                        btnAction: () async {
                          var snackbar = AppSnackbar(
                            context: context,
                            msg: '해당 맛집을 찜했어요!',
                          );

                          snackbar.showSnackbar(context);

                          await _likeThisStore();

                          await _getFavorite();
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// 사진 Container
  Widget postImage() {
    if (widget.model.storeImgUrl == null) {
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
          child: Image.network(
            widget.model.storeImgUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/features/post/models/favorite_store.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreInfoList extends StatefulWidget {
  const StoreInfoList({
    super.key,
    required this.model,
  });

  final FoodStoreModel model;

  @override
  State<StoreInfoList> createState() => _StoreInfoListState();
}

class _StoreInfoListState extends State<StoreInfoList> {
  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;

  /// 찜 상태 Model 객체 선언
  List<FavoriteModel> myFavoriteList = [];

  /// 찜 여부 Boolean
  bool status = false;

  @override
  void initState() {
    super.initState();

    myFavoriteInfo();
  }

  /// 찜 User GET
  Future<void> myFavoriteInfo() async {
    final myFavoriteMap = await _supabase.from('favorite_store').select().eq(
      'favorite_uid',
      _supabase.auth.currentUser!.id,
    );

    setState(() {
      myFavoriteList = myFavoriteMap
          .map(
            (data) => FavoriteModel.fromMap(data),
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Sizes.size20),
      padding: const EdgeInsets.all(Sizes.size12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.size6),
          side: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /// 맛집 별명
                Expanded(
                  child: Text(
                    widget.model.storeName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                /// 맛집 찜 여부 상태
                _favoriteState(widget.model),
              ],
            ),

            /// 맛집 설명
            Container(
              margin: const EdgeInsets.only(
                top: Sizes.size10,
                bottom: Sizes.size10,
              ),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                widget.model.storeComment,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16,
                ),
              ),
            ),

            /// 맛집 주소
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(top: Sizes.size10),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.model.storeAddress,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 해당 맛집 찜 여부
  Widget _favoriteState(FoodStoreModel model) {
    for (FavoriteModel favoriteModel in myFavoriteList) {
      if (favoriteModel.foodStoreIdx == model.idx) {
        setState(() {
          status = true;
        });

        break;
      }
    }

    if (!status) {
      return const FaIcon(
        color: Colors.pinkAccent,
        FontAwesomeIcons.heart,
        size: Sizes.size32,
      );
    } else {
      return const FaIcon(
        color: Colors.pinkAccent,
        FontAwesomeIcons.solidHeart,
        size: Sizes.size32,
      );
    }
  }
}

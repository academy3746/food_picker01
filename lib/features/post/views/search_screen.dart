import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/features/post/models/favorite_store.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/views/detail_screen.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.foodStoreList,
  });

  static const String routeName = '/search';

  final List<FoodStoreModel> foodStoreList;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;

  /// 찜 상태 Model 객체 선언
  List<FavoriteModel> myFavoriteList = [];

  @override
  void initState() {
    super.initState();

    _getMyFavoriteInfo();
  }

  /// 찜 User GET
  Future<void> _getMyFavoriteInfo() async {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostAppBar(
        title: '검색 결과',
        isLeading: true,
      ),
      body: ListView.builder(
        itemCount: widget.foodStoreList.length,
        itemBuilder: (context, index) {
          var foodStoreModel = widget.foodStoreList[index];

          return GestureDetector(
            onTap: () async {
              var result = await Navigator.pushNamed(
                context,
                DetailScreen.routeName,
                arguments: foodStoreModel,
              );

              if (result != null) {
                if (result == 'back_from_detail') {
                  await _getMyFavoriteInfo();
                }
              }
            },
            child: storeInfoList(foodStoreModel),
          );
        },
      ),
    );
  }

  /// 검색 결과에 따른 맛집 리스트 위젯
  Widget storeInfoList(FoodStoreModel model) {
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
                    model.storeName,
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
                favoriteState(model),
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
                model.storeComment,
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
                  model.storeAddress,
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

  /// 찜 상태 확인 위젯
  Widget favoriteState(FoodStoreModel model) {
    var status = false;

    for (FavoriteModel favoriteModel in myFavoriteList) {
      if (favoriteModel.foodStoreIdx == model.idx) {
        status = true;

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

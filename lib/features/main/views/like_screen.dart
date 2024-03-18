import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/views/detail_screen.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  static const String routeName = '/like';

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;

  /// 찜한 맛집 List 호출
  Future<List<FoodStoreModel>> _getMyFavoriteStore() async {
    List<FoodStoreModel> foodStoreList = [];

    final foodStoreMap = await _supabase
        .from('food_store')
        .select(
          '*, favorite_store!inner(*)',
        )
        .eq(
          'favorite_store.favorite_uid',
          _supabase.auth.currentUser!.id,
        );

    foodStoreList = foodStoreMap
        .map(
          (data) => FoodStoreModel.fromMap(data),
        )
        .toList();

    return foodStoreList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostAppBar(
        title: '찜한 맛집',
        isLeading: false,
      ),
      body: FutureBuilder(
        future: _getMyFavoriteStore(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              var foodStoreModel = snapshot.data![index];

              return GestureDetector(
                onTap: () async {
                  var result = await Navigator.pushNamed(
                    context,
                    DetailScreen.routeName,
                    arguments: foodStoreModel,
                  );

                  if (result != null) {
                    if (result == 'back_from_detail') {
                      setState(() {});
                    }
                  }
                },
                child: storeInfoList(foodStoreModel),
              );
            },
          );
        },
      ),
    );
  }

  /// 찜 맛집 리스트 위젯
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

                /// 찜 Icon
                const FaIcon(
                  color: Colors.pinkAccent,
                  FontAwesomeIcons.solidHeart,
                  size: Sizes.size32,
                ),
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
}

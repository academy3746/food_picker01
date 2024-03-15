import 'package:flutter/material.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/views/detail_screen.dart';
import 'package:food_picker/features/post/widgets/post_app_bar.dart';
import 'package:food_picker/features/post/widgets/store_info_container.dart';

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
            onTap: () {
              Navigator.pushNamed(
                context,
                DetailScreen.routeName,
                arguments: foodStoreModel,
              );
            },
            child: StoreInfoList(model: foodStoreModel),
          );
        },
      ),
    );
  }
}

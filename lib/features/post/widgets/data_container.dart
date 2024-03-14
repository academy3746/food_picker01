import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class DataContainer extends StatelessWidget {
  const DataContainer({
    super.key,
    required this.foodStoreModel,
  });

  final String foodStoreModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Sizes.size10),
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.size8),
          side: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.size16),
        child: Text(
          foodStoreModel,
          style: const TextStyle(
            fontSize: Sizes.size16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

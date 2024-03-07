import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    required this.isLeading,
    this.backBtn,
    this.actions,
  });

  final String title;

  final bool isLeading;

  final Function? backBtn;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: Sizes.size48,
      automaticallyImplyLeading: isLeading,
      titleSpacing: isLeading ? 0 : Sizes.size16,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: isLeading
          ? GestureDetector(
              onTap: () {
                backBtn != null ? backBtn!.call() : Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: Sizes.size20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

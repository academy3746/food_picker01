import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';

class PostAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostAppBar({
    super.key,
    required this.title,
    required this.isLeading,
    this.backBtn,
    this.actions,
    this.centerTitle,
  });

  final String title;

  final bool isLeading;

  final void Function()? backBtn;

  final List<Widget>? actions;

  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: Theme.of(context).primaryColor,
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
                color: Colors.white,
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: Sizes.size20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

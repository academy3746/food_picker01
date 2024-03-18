import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/common_app_bar.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/features/auth/models/member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  static const String routeName = '/info';

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;

  /// 접속중인 단일 사용자 정보 호출
  Future<MemberModel> _getUserInfo() async {
    final userMap = await _supabase.from('member').select().eq(
          'uid',
          _supabase.auth.currentUser!.id,
        );

    final currentUser = userMap
        .map(
          (data) => MemberModel.fromMap(data),
        )
        .single;

    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: '프로필',
        isLeading: false,
      ),
      body: FutureBuilder(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          var userModel = snapshot.data;

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
                    fontWeight: FontWeight.w600),
              ),
            );
          }

          return myProfile(userModel!);
        },
      ),
    );
  }

  /// 회원 정보 위젯
  Widget myProfile(MemberModel model) {
    return Container(
      margin: const EdgeInsets.all(Sizes.size20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Card
          Container(
            margin: const EdgeInsets.only(bottom: Sizes.size32),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
              vertical: Sizes.size24,
            ),
            decoration: ShapeDecoration(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.size10),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
            ),
            child: Row(
              children: [
                /// 프로필 사진
                ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: model.profileUrl != null
                      ? Image.network(
                          model.profileUrl.toString(),
                          width: Sizes.size52,
                          height: Sizes.size52,
                          fit: BoxFit.cover,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.user,
                          size: Sizes.size52,
                        ),
                ),
                Gaps.h20,

                /// 회원명 및 이메일
                Container(
                  margin: const EdgeInsets.only(bottom: Sizes.size8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: model.name,
                        textColor: Colors.black,
                        textWeight: FontWeight.w700,
                        textSize: Sizes.size16,
                      ),
                      CommonText(
                        textContent: model.email,
                        textColor: Colors.grey.shade500,
                        textSize: Sizes.size12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Introduce
          const CommonText(
            textContent: '자기소개',
            textColor: Colors.black,
            textSize: Sizes.size20,
            textWeight: FontWeight.w700,
          ),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: Sizes.size20),
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16,
                  vertical: Sizes.size24,
                ),
                decoration: ShapeDecoration(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Sizes.size10),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: CommonText(
                  textContent: model.introduce,
                  textColor: Colors.black,
                  textSize: Sizes.size16,
                  textWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

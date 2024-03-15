// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/common_button.dart';
import 'package:food_picker/common/utils/common_input_field.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/views/detail_screen.dart';
import 'package:food_picker/features/post/views/edit_screen.dart';
import 'package:food_picker/features/post/views/search_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 지도 객체 생성
  late NaverMapController mapController;

  /// 중심 좌표 전환 관련 Completer 객체 생성
  Completer<NaverMapController> mapCompleter = Completer();

  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;

  /// 검색 입력필드 Controller 객체 생성
  final TextEditingController _searchController = TextEditingController();

  /// Food Store Model 객체 생성
  List<FoodStoreModel>? _storeList;

  /// Food Store Model Future 객체 생성
  Future<List<FoodStoreModel>>? _dataStoreFuture;

  @override
  void initState() {
    super.initState();

    _dataStoreFuture = _fetchStoreData();
  }

  /// Food Store 데이터 출력
  Future<List<FoodStoreModel>>? _fetchStoreData() async {
    /// 1. Supabase Database Access
    final storeListMap = await _supabase.from('food_store').select();

    /// 2. JSON Parsing
    List<FoodStoreModel> storeList =
        storeListMap.map((data) => FoodStoreModel.fromMap(data)).toList();

    return storeList;
  }

  /// 위치 정보 획득
  Future<NCameraPosition> _getMyLocation() async {
    /// 1. 위치 권한 요청
    bool service;

    LocationPermission permission;

    service = await Geolocator.isLocationServiceEnabled();

    if (!service) {
      return Future.error('GPS 서비스를 사용할 수 없습니다!');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    /// 2. 위치 정보 획득
    Position position = await Geolocator.getCurrentPosition();

    return NCameraPosition(
      target: NLatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 16,
    );
  }

  /// 마커 생성
  Future<void> _buildMarkersOnMap() async {
    mapController.clearOverlays();

    for (FoodStoreModel model in _storeList!) {
      final marker = NMarker(
        id: model.idx.toString(),
        position: NLatLng(
          model.latitude,
          model.longitude,
        ),
        caption: NOverlayCaption(text: model.storeName),
      );

      marker.setOnTapListener((overlay) {
        _showBottomSummaryDialog(model);
      });

      mapController.addOverlay(marker);
    }
  }

  /// 맛집 상세 정보 출력 (Pop Up)
  void _showBottomSummaryDialog(FoodStoreModel model) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.size10),
          topLeft: Radius.circular(Sizes.size10),
        ),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(Sizes.size20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      CommonText(
                        textContent: model.storeName,
                        textColor: Colors.black,
                        textSize: Sizes.size24,
                        textWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: Sizes.size24,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v12,

                  /// Body Image
                  model.storeImgUrl?.isNotEmpty == true
                      ? CircleAvatar(
                          radius: Sizes.size44,
                          backgroundImage: NetworkImage(model.storeImgUrl!),
                        )
                      : const Icon(
                          Icons.image_not_supported_outlined,
                          size: Sizes.size44,
                        ),
                  Gaps.v12,

                  /// Comment
                  Text(
                    model.storeComment,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gaps.v12,

                  /// Navigate to Detail Screen
                  SizedBox(
                    height: Sizes.size58,
                    width: MediaQuery.of(context).size.width,
                    child: CommonButton(
                      btnBackgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      btnText: '자세히 보기',
                      btnAction: () async {
                        Navigator.of(context).pop();

                        await Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: model,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// 검색 입력필드 검증
  _searchValidator(value) {
    if (value.isEmpty) {
      return '올바른 검색어를 입력해 주세요!';
    }
    return null;
  }

  /// 검색 결과 리턴
  Future<void> _navigateToSearchScreen(String value) async {
    final foodStoreMap = await _supabase
        .from('food_store')
        .select()
        .like('store_name', '%$value%');

    List<FoodStoreModel> foodStoreSearchList = foodStoreMap
        .map(
          (data) => FoodStoreModel.fromMap(data),
        )
        .toList();

    if (!mounted) return;

    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: foodStoreSearchList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dataStoreFuture,
        builder: (context, snapshot) {
          _storeList = snapshot.data;

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'COMM ERR: ${snapshot.error}',
                style: const TextStyle(fontSize: Sizes.size20),
              ),
            );
          }

          return Stack(
            children: [
              /// Naver 지도 화면 렌더링
              NaverMap(
                onMapReady: (controller) async {
                  mapController = controller;

                  /// 1. 현재 위치 정보 추출
                  NCameraPosition myPosition = await _getMyLocation();

                  /// 2. 마커 생성
                  await _buildMarkersOnMap();

                  /// 3. 현재 위치를 중심 좌표로, 카메라 시점 전환
                  mapController.updateCamera(
                    NCameraUpdate.fromCameraPosition(myPosition),
                  );

                  /// 4. 중심 좌표 전환 완료 신호 전송
                  mapCompleter.complete(mapController);
                },
                options: const NaverMapViewOptions(
                  indoorEnable: true,
                  locationButtonEnable: true,
                  consumeSymbolTapEvents: false,
                ),
              ),

              /// 상단 맛집 검색 입력필드 배치
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                  vertical: Sizes.size64,
                ),
                child: InputField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  readOnly: false,
                  obscureText: false,
                  maxLines: 1,
                  fillColor: Colors.white,
                  filled: true,
                  validator: (value) => _searchValidator(value),
                  hintText: '맛집을 찾아 볼까요?',
                  onFieldSubmitted: (value) async {
                    _searchController.text = value;

                    await _navigateToSearchScreen(value);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var result = await Navigator.pushNamed(
            context,
            EditScreen.routeName,
          );

          if (result != null) {
            if (result == 'edit_completed') {
              _storeList = await _fetchStoreData();

              await _buildMarkersOnMap();

              setState(() {});
            }
          }
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.post_add_outlined,
          size: Sizes.size32,
          color: Colors.white,
        ),
      ),
    );
  }
}

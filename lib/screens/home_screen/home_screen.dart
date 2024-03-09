import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

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

  /// 위치 정보 획득
  Future<NCameraPosition> _getMyLocation() async {
    // 1. 위치 권한 요청
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

    // 2. 위치 정보 획득
    Position position = await Geolocator.getCurrentPosition();

    return NCameraPosition(
      target: NLatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        onMapReady: (controller) async {
          mapController = controller;

          // 1. 현재 위치 정보 추출
          NCameraPosition myPosition = await _getMyLocation();

          // 2. 현재 위치를 중심 좌표로, 카메라 시점 전환
          mapController.updateCamera(
            NCameraUpdate.fromCameraPosition(myPosition),
          );

          // 3. 중심 좌표 전환 완료 신호 전송
          mapCompleter.complete(mapController);
        },
        options: const NaverMapViewOptions(
          indoorEnable: true,
          locationButtonEnable: true,
          consumeSymbolTapEvents: false,
        ),
      ),
    );
  }
}

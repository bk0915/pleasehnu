import 'dart:async';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'busAlert.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // 로딩 페이지 표시
    //LocatorService.initializeService();
    Timer(Duration(seconds: 2), () {
      _navigateToLoginPage();
    });
  }

  // 권한 요청
  void _navigateToLoginPage() async {
    // 알림 권한 확인
    PermissionStatus notificationStatus = await Permission.notification.status;
    // 위치 권한 확인
    PermissionStatus locationStatus = await Permission.location.status;

    // 알림 권한 또는 위치 권한이 설정되어 있지 않은 경우 권한 요청
    if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied ||
        locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      // 알림 권한 요청
      if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
        await Permission.notification.request();
      }

      // 위치 권한 요청
      if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
        await Permission.location.request();
      }
    }

    // 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _requestPermissions() async {
    // 요청할 권한 리스트
    List<Permission> permissions = [
      Permission.notification,
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.ignoreBatteryOptimizations,
    ];

    // 권한 상태 확인 및 요청
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // 각 권한의 상태를 출력 (디버깅용)
    statuses.forEach((permission, status) {
      print('$permission: $status');
    });

    // 필요한 경우 사용자가 설정에서 권한을 수동으로 설정하도록 안내
    if (statuses[Permission.location]!.isPermanentlyDenied ||
        statuses[Permission.locationAlways]!.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Stack이 화면 전체를 차지하도록 설정
        children: [
          // 배경 이미지
          Image.asset(
            'assets/images/login_image.jpg', // 배경 이미지 파일 경로
            fit: BoxFit.cover, // 이미지가 화면에 가득 차도록 함
          ),
          // 정중앙에 이미지 표시
          Center(
            child: Image.asset(
              'assets/images/hnu.png', // 중앙에 표시할 이미지 경로
              width: 200, // 이미지의 너비
              height: 200, // 이미지의 높이
              fit: BoxFit.contain, // 이미지를 유지하면서 정중앙에 표시
            ),
          ),
          // 로딩 인디케이터
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // 인디케이터 색상 설정
            ),
          ),
        ],
      ),
    );
  }
}

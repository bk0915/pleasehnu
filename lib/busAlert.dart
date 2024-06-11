import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
// 페이지를 import
import 'mainPage.dart';
import 'noticePage.dart';
import 'myPage.dart';
import 'busRoute.dart';

void onStart(ServiceInstance service) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 백그라운드 작업 실행 함수
  void performBackgroundTask() async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // 설정된 목표 위치
    Position destinationPosition = Position(
      latitude: 36.3534141168471,
      longitude: 127.42142416967272,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      floor: null,
      isMocked: false,
    );

    // 목표 지점과의 거리를 계산
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destinationPosition.latitude,
      destinationPosition.longitude,
    );

    // 거리 값에 따라 알림 생성
    if (distanceInMeters <= 150) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1',
        '하차',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        '하차 알림',
        '하차할 정류장에 도착했습니다',
        platformChannelSpecifics,
      );

      service.invoke('stopTracking'); // 서비스에 메시지 전달
      service.stopSelf(); // 작업 완료 후 서비스 종료
    }
  }

  // 작업 주기 설정
  Timer.periodic(const Duration(seconds: 3), (timer) {
    performBackgroundTask();
  });
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  Position? _currentPosition;
  bool _isTrackingEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initialization();
    _configureBackgroundService();

    // 백그라운드 서비스에서 메시지 수신
    FlutterBackgroundService().on('stopTracking').listen((event) {
      setState(() {
        _isTrackingEnabled = false;
      });
    });
  }

  // 초기화 설정
  void _initialization() async {
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  // 백그라운드 서비스 설정
  void _configureBackgroundService() {
    FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        autoStart: false,
      ),
    );
  }

  // 알림 전송
  Future<void> _showNotification() async {
    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        '1',
        '하차',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _local.show(1, '하차 알림', '하차할 정류장에 도착했습니다', details);
  }

  // 사용자의 현재 위치를 가져오는 함수
  Future<Position> _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  // 도착 여부를 확인하는 함수
  Future<bool> _checkArrival(Position currentLocation, Position destination) async {
    double distanceInMeters = await Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    return distanceInMeters <= 100;
  }

  // 주기적으로 위치를 추적하는 함수
  void _startTracking() {
    FlutterBackgroundService().startService();
  }

  // 주기적 위치 추적 중지 함수
  void _stopTracking() {
    FlutterBackgroundService().invoke("stopService");
  }

  // 스위치의 onChanged 콜백 메서드
  void _toggleTracking(bool value) {
    setState(() {
      _isTrackingEnabled = value; // 스위치 값 변경
      if (_isTrackingEnabled) {
        _startTracking(); // 스위치가 켜지면 위치 추적 시작
      } else {
        _stopTracking(); // 스위치가 꺼지면 위치 추적 중지
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: Container(
          child: Row(
            children: [
              Container(
                width: 165,
                child: Image.asset('assets/images/logo.jpg'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/images/menu_icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              // 동작 처리
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('하차 알림 OFF/ON'),
              value: _isTrackingEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isTrackingEnabled = value;
                  if (_isTrackingEnabled) {
                    _startTracking();
                  } else {
                    _stopTracking();
                  }
                });
              },
            ),
            SizedBox(height: 20),
            if (_currentPosition != null)
              Text('Current Position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 65,
        height: 65,
        margin: EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
          tooltip: 'Increment',
          shape: const CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                child: Image.asset(
                  'assets/images/homebutton_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 1),
              Text(
                '홈',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () {
                // 노선으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => busRoute()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/map_icon.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '노선',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // 커뮤니티로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => noticePage()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/board_icon.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '커뮤니티',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    ),
                  ),
                ],
              ),
            ),
            // 중앙에 여백
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                // 마이페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myPage()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/myPage_icon.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '내 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // 설정으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/setting_icon.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '설정',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
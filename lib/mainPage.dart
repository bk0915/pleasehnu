import 'package:flutter/material.dart';
import 'package:pleasehnu/busRoute.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'vibration.dart';

// 페이지 import
import 'busReservation.dart';
import 'noticePage.dart';
import 'myPage.dart';
import 'loginPage.dart';
import 'settingPage.dart';
import 'config.dart';

class MainPage extends StatefulWidget {
  static Map<String, dynamic>? reservationData;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = PageController();
  bool isSheetOpen = false;
  int userId = LoginPage.user_id;
  List<String> imageUrls = [];
  bool isLoading = false;

  String Url() {
    return '$baseIP/resource/img/$userId';
  }

  @override
  void initState() {
    super.initState();
    _loadReservationData();
    _fetchImageUrls();
  }

  Future<void> _loadReservationData() async {
    try {
      var result = await RequestInformation().getReservation(userId);
      setState(() {
        MainPage.reservationData = result;
        print(MainPage.reservationData);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchImageUrls() async {
    final String baseUrl = "$baseIP/resource/img/ads";
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          imageUrls = jsonResponse.map((item) => "$baseIP${item}").toList();
        });
      } else {
        print('Failed to load image URLs: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch image URLs: $e');
    }
  }

  Future<void> _checkReservationData() async {
    if (MainPage.reservationData == null ||
        MainPage.reservationData!['type'] == null ||
        MainPage.reservationData!['busId'] == null ||
        MainPage.reservationData!['seatNumber'] == null ||
        MainPage.reservationData!['date'] == null) {
      throw Exception('예약 정보가 완전하지 않습니다.');
    }
  }

  void _toggleSheet() async {
    setState(() {
      isSheetOpen = !isSheetOpen;
      isLoading = isSheetOpen; // Start loading when the sheet is opened
    });
    if (isSheetOpen && !(MainPage.reservationData?['isSeatConfirmed'] ?? false)) {
      _startCheckingServer();
    }
  }

  void _startCheckingServer() async {
    while (isSheetOpen) {
      try {
        final response = await http.post(
          Uri.parse('$baseIP/reservation/check/judge'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': userId.toString(),
            'type': MainPage.reservationData?['type'] ?? '',
            'bus_id': MainPage.reservationData?['busId']?.toString() ?? '',
            'seat_number': MainPage.reservationData?['seatNumber']?.toString() ?? '',
            'date': MainPage.reservationData?['date']?.toString() ?? '',
          }),
        );
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['result'] == true) {
            if (mounted) {
              setState(() {
                isLoading = false;
                MainPage.reservationData!['isSeatConfirmed'] = true;
                isSheetOpen = false;
              });
              await VibrationService.vibrate();
              _showAlertDialog('좌석 확인이 완료되었습니다.');
            }
            break;
          }
        }
      } catch (e) {
        print(e);
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSheetOpen = false;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 190,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                              width: 139,
                              height: 152,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(Url()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    MainPage.reservationData?['name'] != null
                                        ? '${MainPage.reservationData?['name']}'
                                        : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    MainPage.reservationData?['route'] != null
                                        ? '노선: ${MainPage.reservationData?['route']}(${MainPage.reservationData?['type']})'
                                        : '예약 정보 없음',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    MainPage.reservationData?['end_point'] != null
                                        ? (MainPage.reservationData?['type'] == '등교'
                                        ? '목적지: 한남대학교'
                                        : '목적지: ${MainPage.reservationData?['end_point']}')
                                        : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 8, // Limit the number of lines
                                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    MainPage.reservationData?['date'] != null
                                        ? '예약일: ${MainPage.reservationData?['date']}'
                                        : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // QR 버튼 추가
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await _checkReservationData();
                                _toggleSheet();
                              } catch (e) {
                                _showAlertDialog(e.toString());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'QR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // 버스 예약 버튼
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        if (MainPage.reservationData != null &&
                            MainPage.reservationData!['busId'] != null) {
                          _showAlertDialog('이미 예약이 완료되었습니다. 예약정보를 바꾸기 위해서는 예매취소가 필요합니다.');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BusReservation()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bus_alert,
                            color: Colors.grey,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '버스 예약',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView(
                          controller: controller,
                          children: imageUrls.map((url) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: imageUrls.length,
                            effect: WormEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Colors.red,
                              spacing: 12,
                              radius: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isSheetOpen ? DraggableSheetPage() : SizedBox(),
        ],
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
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
                      fontWeight: FontWeight.bold,
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

class DraggableSheetPage extends StatefulWidget {
  @override
  _DraggableSheetPageState createState() => _DraggableSheetPageState();
}

class _DraggableSheetPageState extends State<DraggableSheetPage> {
  Map<String, dynamic> reservationData = MainPage.reservationData ?? {};

  @override
  void initState() {
    super.initState();
    if (MainPage.reservationData?['isSeatConfirmed'] != true) {
      _startCheckingServer();
    }
  }

  void _startCheckingServer() async {
    while (true) {
      try {
        final response = await http.post(
          Uri.parse('$baseIP/reservation/check/judge'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': LoginPage.user_id,
            'type': reservationData['type'] ?? '',
            'bus_id': reservationData['busId']?.toString() ?? '',
            'seat_number': reservationData['seatNumber']?.toString() ?? '',
            'date': reservationData['date']?.toString() ?? '',
          }),
        );
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['result'] == true) {
            if (mounted) {
              setState(() {
                MainPage.reservationData!['isSeatConfirmed'] = true;
              });
              await VibrationService.vibrate();
              _showAlertDialog('좌석 확인이 완료되었습니다.', context);
            }
            break;
          }
        }
      } catch (e) {
        print(e);
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _showCancelReservationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('예약 취소'),
          content: Text('예약을 취소하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                Navigator.of(context).pop();
                bool result = await ReservationCancel().cancelReservation(LoginPage.user_id);
                if (result) {
                  _showAlertDialog('예약이 취소되었습니다.', context);
                  setState(() {
                    MainPage.reservationData = null;
                  });
                  // Navigate back to MainPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (Route<dynamic> route) => false,
                  );
                } else {
                  _showAlertDialog('예약이 취소되지 않았습니다.', context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.25,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            border: Border(
              top: BorderSide(color: Colors.grey, width: 2.0),
              left: BorderSide(color: Colors.grey, width: 2.0),
              right: BorderSide(color: Colors.grey, width: 2.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              QrImageView(
                data: jsonEncode({
                  'user_id': LoginPage.user_id,
                  'type': reservationData['type'] ?? '',
                  'bus_id': reservationData['busId']?.toString() ?? '',
                  'seat_number': reservationData['seatNumber']?.toString() ?? '',
                  'date': reservationData['date']?.toString() ?? '',
                }),
                version: QrVersions.auto,
                size: 180,
              ),
              SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  '    [ 출발지 ]',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    reservationData['type'] == '등교' ? reservationData['end_point'] : '한남대학교' ?? '',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.arrow_forward,
                            size: 50,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  '[ 목적지 ]    ',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Text(
                                    reservationData['type'] == '등교' ? '한남대학교' ?? '' : reservationData['end_point'],
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '[ 출발일 ]',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    reservationData['date']?.toString() ?? ' ',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '[ 좌석번호 ]',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    reservationData['seatNumber']?.toString() ?? ' ',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          _showCancelReservationDialog(context);
                        },
                        child: Text(
                          '예매취소',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RequestInformation {
  Future<Map<String, dynamic>> getReservation(int userId) async {
    final String baseUrl = "$baseIP/reservation/user-information";
    final uriWithParams = Uri.parse(baseUrl).replace(
      queryParameters: {'userId': userId.toString()},
    );
    final response = await http.get(uriWithParams);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonResponse);

      String type = '';
      String route = '';
      String busId = '';
      int seatNumber = -1;
      String endPoint = '';
      bool isChecked = false;
      String date = '';
      String name = '';
      String userId = '';

      if (jsonResponse != null) {
        var seat = jsonResponse['seat'];
        if (seat != null) {
          var seatId = seat['id'];
          var bus = seat['bus'];
          if (seatId != null) {
            busId = seatId['busId'].toString();
            seatNumber = seatId['seatNumber'];
            type = seatId['type'];
          }
          if (bus != null) {
            route = bus['endPoint'];
          }
        }
        endPoint = jsonResponse['endPoint'] ?? '';
        date = jsonResponse['date'] ?? '';
        isChecked = jsonResponse['checked'] ?? false;
        userId = jsonResponse['userId']?.toString() ?? '';
        var user = jsonResponse['user'];
        if (user != null) {
          name = user['name'] ?? '';
        }
      }

      if (busId.isEmpty || type.isEmpty || seatNumber == -1 || endPoint.isEmpty || date.isEmpty) {
        print('Null이므로 빈 맵을 반환');
        return {};
      }

      print('Bus ID: $busId, Type: $type, Seat Number: $seatNumber, End Point: $endPoint, Route: $route, Name: $name, Date: $date, Is Checked: $isChecked, User ID: $userId');

      return {
        'type': type,
        'busId': busId,
        'seatNumber': seatNumber,
        'end_point': endPoint,
        'route': route,
        'name': name,
        'is_checked': isChecked,
        'date': date,
        'userId': userId,
        'isSeatConfirmed': false, // 추가
      };
    } else {
      print('실패 ${response.statusCode}');
      throw Exception('Failed to load reservations');
    }
  }
}

class ReservationCancel {
  Future<bool> cancelReservation(int userId) async {
    final String baseUrl = "$baseIP/reservation/delete";
    final uriWithParams = Uri.parse(baseUrl).replace(
        queryParameters: {
          'userId' : userId.toString(),
        }
    );

    final response = await http.get(uriWithParams);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['result'] == true;
    } else {
      return false;
    }
  }
}

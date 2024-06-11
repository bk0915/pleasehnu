import 'package:flutter/material.dart';
import 'busReservation.dart';
import 'mainPage.dart';
import 'noticePage.dart';
import 'loginPage.dart';
import 'settingPage.dart';
import 'busRoute.dart';

class myPage extends StatefulWidget{
  @override
  _myPage createState() => _myPage();
}

class _myPage extends State<myPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 최상단 appbar
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

      // 프로필 정보
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 45,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0), // Optional: add border radius for rounded corners
              ),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // 로그아웃 버튼 클릭 시 로그인 페이지로 이동
                  // 사용자 데이터 초기화
                  LoginPage.user_id = 0;
                  MainPage.reservationData = null;
                  BusReservation.end_point = '';
                  BusReservation.route = '';
                  BusReservation.type = '등교';
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      // 바텀바 구성
      // 홈버튼(플로팅버튼)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 65,
        height: 65,
        margin: EdgeInsets.only(top: 30), // 아래로 이동시키기 위한 마진 설정
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
              SizedBox(height: 1), // 텍스트와 이미지 사이의 간격 조정
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
      // 바텀바
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
          )
      ),
    );
  }
}
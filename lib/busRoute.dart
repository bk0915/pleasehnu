import 'mainPage.dart';
import 'package:flutter/material.dart';
import 'settingPage.dart';
import 'noticePage.dart';
import 'myPage.dart';

class busRoute extends StatefulWidget {
  @override
  _busRoute createState() => _busRoute();
}

class _busRoute extends State<busRoute> {
  Map<String, bool> _expandedStates = {
    '도안 지역노선': false,
    '세종, 노은 지역노선': false,
    '계룡, 진잠, 관저동 순환버스 노선': false,
    '가오동, 판암동 지역노선': false,
    '가수원, 도마 지역노선\n(가수원 → 도마 → 대덕밸리캠퍼스)': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset('assets/images/logo.jpg', width: 150),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '시외 통학버스 운행 : 천안, 청주',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.red, width: 2.0),
                  bottom: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          '          등교',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          '하교              ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildDataTable(),
            ),
            Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '시내 등하교버스',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildRouteOption('도안 지역노선', _buildDoanRouteStops()),
            _buildRouteOption('세종, 노은 지역노선', _buildSejongNoeunRouteStops()),
            _buildRouteOption('계룡, 진잠, 관저동 순환버스 노선', _buildGyeryongRouteStops()),
            _buildRouteOption('가오동, 판암동 지역노선', _buildGaodongRouteStops()),
            _buildRouteOption('가수원, 도마 지역노선\n(가수원 → 도마 → 대덕밸리캠퍼스)', _buildGasuwonRouteStops()),
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
          )
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('장소', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('장소', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('천안고속\n터미널 건너편')),
            DataCell(Text('07:10')),
            DataCell(Text('학교')),
            DataCell(Text('18:10')),
          ]),
          DataRow(cells: [
            DataCell(Text('청주 가경동\n시외버스 터미널')),
            DataCell(Text('07:55')),
            DataCell(Text('청주 가경동\n시외버스 터미널')),
            DataCell(Text('19:00')),
          ]),
          DataRow(cells: [
            DataCell(Text('학교')),
            DataCell(Text('08:40')),
            DataCell(Text('천안고속\n터미널')),
            DataCell(Text('19:40')),
          ]),
        ],
        columnSpacing: 30.0, // Adjust the column spacing
        horizontalMargin: 2.0, // Adjust the horizontal margin
      ),
    );
  }

  Widget _buildRouteOption(String title, Widget content) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isExpanded = _expandedStates[title] ?? false;
        return ExpansionTile(
          title: Text(title),
          trailing: Icon(
            isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          ),
          children: [content],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _expandedStates[title] = expanded;
            });
          },
        );
      },
    );
  }



  Widget _buildDoanRouteStops(){
    return DataTable(
      columns: [
        DataColumn(label: Text('정류장', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('가수원파출소 승강장')),
          DataCell(Text('07:40')),
        ]),
        DataRow(cells: [
          DataCell(Text('린풀하우스 승강장')),
          DataCell(Text('07:42')),
        ]),
        DataRow(cells: [
          DataCell(Text('수목토 승강장')),
          DataCell(Text('07:44')),
        ]),
        DataRow(cells: [
          DataCell(Text('목원네거리 승강장')),
          DataCell(Text('07:53')),
        ]),
        DataRow(cells: [
          DataCell(Text('트리플시티9단지 승강장')),
          DataCell(Text('07:58')),
        ]),
        DataRow(cells: [
          DataCell(Text('청학동 양푼이 동태찌개 도로변')),
          DataCell(Text('08:00')),
        ]),
        DataRow(cells: [
          DataCell(Text('유성온천역 2번출구 버스승강장')),
          DataCell(Text('08:03')),
        ]),
        DataRow(cells: [
          DataCell(Text('갈마1동주민센터 버스승강장')),
          DataCell(Text('08:09')),
        ]),
        DataRow(cells: [
          DataCell(Text('탄방동SK브로드벤드 버스승강장')),
          DataCell(Text('08:14')),
        ]),
        DataRow(cells: [
          DataCell(Text('시청역 7번출구 버스승강장')),
          DataCell(Text('08:19')),
        ]),
        DataRow(cells: [
          DataCell(Text('국화아파트 버스승강장')),
          DataCell(Text('08:24')),
        ]),
      ],
    );
  }
  Widget _buildSejongNoeunRouteStops(){
    return DataTable(
      columns: [
        DataColumn(label: Text('정류장', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('세종소방서')),
          DataCell(Text('07:10')),
        ]),
        DataRow(cells: [
          DataCell(Text('센트럴A 905동 도로 옆')),
          DataCell(Text('07:13')),
        ]),
        DataRow(cells: [
          DataCell(Text('범지기 마을 112동 옆')),
          DataCell(Text('07:16')),
        ]),
        DataRow(cells: [
          DataCell(Text('가락마을 203동 건너편')),
          DataCell(Text('07:18')),
        ]),
        DataRow(cells: [
          DataCell(Text('푸르지오A 1020동 뒤편')),
          DataCell(Text('07:22')),
        ]),
        DataRow(cells: [
          DataCell(Text('도램마을 803동 버스승강장')),
          DataCell(Text('07:25')),
        ]),
        DataRow(cells: [
          DataCell(Text('청사북쪽 지선승강장')),
          DataCell(Text('07:27')),
        ]),
        DataRow(cells: [
          DataCell(Text('청사남쪽 지선승강장')),
          DataCell(Text('07:30')),
        ]),
        DataRow(cells: [
          DataCell(Text('나성동 버스승강장')),
          DataCell(Text('07:32')),
        ]),
        DataRow(cells: [
          DataCell(Text('첫마을 지선승강장')),
          DataCell(Text('07:35')),
        ]),
        DataRow(cells: [
          DataCell(Text('시외버스터미널')),
          DataCell(Text('07:40')),
        ]),
        DataRow(cells: [
          DataCell(Text('반석역 승강장')),
          DataCell(Text('07:50')),
        ]),
        DataRow(cells: [
          DataCell(Text('극동방송국 승강장')),
          DataCell(Text('07:52')),
        ]),
        DataRow(cells: [
          DataCell(Text('노은역 승강장')),
          DataCell(Text('07:55')),
        ]),
        DataRow(cells: [
          DataCell(Text('온천2동 주민센터 승강장')),
          DataCell(Text('08:00')),
        ]),
        DataRow(cells: [
          DataCell(Text('월평중 버스승강장')),
          DataCell(Text('08:10')),
        ]),
        DataRow(cells: [
          DataCell(Text('정부청사역 버스승강장')),
          DataCell(Text('08:13')),
        ]),
      ],
    );
  }
  Widget _buildGyeryongRouteStops(){
    return DataTable(
      columns: [
        DataColumn(label: Text('정류장', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('1회', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('2회', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('성원A승강장')),
          DataCell(Text('07:20')),
          DataCell(Text('')),
        ]),
        DataRow(cells: [
          DataCell(Text('계룡시외버스 터미널')),
          DataCell(Text('07:25')),
          DataCell(Text('')),
        ]),
        DataRow(cells: [
          DataCell(Text('계룡고등학교 맞은편')),
          DataCell(Text('07:27')),
          DataCell(Text('')),
        ]),
        DataRow(cells: [
          DataCell(Text('두계사 입구')),
          DataCell(Text('07:33')),
          DataCell(Text('')),
        ]),
        DataRow(cells: [
          DataCell(Text('진잠4거리 SK주유소 앞')),
          DataCell(Text('07:44')),
          DataCell(Text('09:10')),
        ]),
        DataRow(cells: [
          DataCell(Text('건양대병원 4거리')),
          DataCell(Text('07:47')),
          DataCell(Text('09:13')),
        ]),
        DataRow(cells: [
          DataCell(Text('가수원 육교')),
          DataCell(Text('07:50')),
          DataCell(Text('09:15')),
        ]),
        DataRow(cells: [
          DataCell(Text('정림동 세영프라자')),
          DataCell(Text('07:52')),
          DataCell(Text('09:18')),
        ]),
        DataRow(cells: [
          DataCell(Text('도마 e편한세상 버스승강장')),
          DataCell(Text('07:58')),
          DataCell(Text('09:23')),
        ]),
        DataRow(cells: [
          DataCell(Text('첫마을 유천시장 입구')),
          DataCell(Text('08:02')),
          DataCell(Text('09:27')),
        ]),
        DataRow(cells: [
          DataCell(Text('서대전 4거리')),
          DataCell(Text('08:05')),
          DataCell(Text('09:32')),
        ]),
        DataRow(cells: [
          DataCell(Text('오룡역 7번출구')),
          DataCell(Text('08:12')),
          DataCell(Text('09:37')),
        ]),
        DataRow(cells: [
          DataCell(Text('학교')),
          DataCell(Text('')),
          DataCell(Text('')),
        ]),
      ],
    );
  }
  Widget _buildGaodongRouteStops(){
    return DataTable(
      columns: [
        DataColumn(label: Text('정류장', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('가오동네거리 새마을금고')),
          DataCell(Text('08:20')),
        ]),
        DataRow(cells: [
          DataCell(Text('판암역 전자랜드')),
          DataCell(Text('08:23')),
        ]),
        DataRow(cells: [
          DataCell(Text('신흥동 시외버스 매표소 건너')),
          DataCell(Text('08:27')),
        ]),
        DataRow(cells: [
          DataCell(Text('대동역 5번출구')),
          DataCell(Text('08:30')),
        ]),
        DataRow(cells: [
          DataCell(Text('대전역 대한통운')),
          DataCell(Text('08:35')),
        ]),
        DataRow(cells: [
          DataCell(Text('학교')),
          DataCell(Text('')),
        ]),
      ],
    );
  }
  Widget _buildGasuwonRouteStops(){
    return DataTable(
      columns: [
        DataColumn(label: Text('정류장', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('시간', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('가수원 육교')),
          DataCell(Text('07:48')),
        ]),
        DataRow(cells: [
          DataCell(Text('도마1동 주민센터 승강장')),
          DataCell(Text('07:57')),
        ]),
        DataRow(cells: [
          DataCell(Text('향우 네거리')),
          DataCell(Text('08:00')),
        ]),
        DataRow(cells: [
          DataCell(Text('가장 네거리')),
          DataCell(Text('07:53')),
        ]),
        DataRow(cells: [
          DataCell(Text('용문동 서부농협')),
          DataCell(Text('08:16')),
        ]),
        DataRow(cells: [
          DataCell(Text('타임월드 맞은편')),
          DataCell(Text('08:20')),
        ]),
        DataRow(cells: [
          DataCell(Text('둔산경찰서')),
          DataCell(Text('08:24')),
        ]),
        DataRow(cells: [
          DataCell(Text('학교(대덕밸리 캠퍼스)')),
          DataCell(Text('08:45')),
        ]),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: busRoute(),
  ));
}

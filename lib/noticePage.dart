import 'package:flutter/material.dart';
import 'mainPage.dart';
import 'myPage.dart';
import 'loginPage.dart' as loginPage;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'settingPage.dart';
import 'NoticeDetailPage.dart';
import 'busRoute.dart';
import 'InquiryDetailPage.dart';
import 'config.dart';

class noticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();

  static String title = '';
  static String content = '';
}

class _NoticePageState extends State<noticePage> {
  bool showNotices = true;
  List<Map<String, dynamic>> inquiries = [];
  List<Map<String, dynamic>> notices = [];

  Future<void> _fetchInquiries() async {
    try {
      final posts = await RequestPost().getPosts(loginPage.LoginPage.user_id);
      print('Fetched inquiries: $posts'); // Debugging log
      setState(() {
        inquiries = posts;
        showNotices = false;
      });
    } catch (e) {
      print('Failed to fetch inquiries: $e');
    }
  }

  Future<void> _fetchNotices() async {
    try {
      final notices = await RequestNotice().getNotices();
      print('Fetched notices: $notices'); // Debugging log
      setState(() {
        this.notices = notices;
        showNotices = true;
      });
    } catch (e) {
      print('Failed to fetch notices: $e');
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchNotices();
  }

  @override
  void initState() {
    super.initState();
    _fetchNotices(); // Fetch notices when the page is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 165,
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
                  onTap: () async {
                    await _fetchNotices();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/notice_icon.png',
                        width: 28,
                        height: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '공지사항',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await _fetchInquiries();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/board_icon.png',
                        width: 28,
                        height: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '문의하기',
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
          Expanded(
            child: showNotices ? _buildNotices() : _buildInquiries(),
          ),
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

  Widget _buildNotices() {
    return notices.isEmpty
        ? Center(
      child: Text(
        '공지사항이 없습니다',
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    )
        : ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoticeDetailPage(noticeDetail: notices[index]),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notices[index]['title'] ?? '제목 없음',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notices[index]['content'] ?? '내용 없음',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInquiries() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  문의내역',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateInquiryPage(onInquiryAdded: _fetchInquiries)),
                  );
                },
                child: Text('문의작성하기'),
              ),
            ],
          ),
        ),
        Expanded(
          child: inquiries.isEmpty
              ? Center(
            child: Text(
              '문의내역이 없습니다',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: inquiries.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryDetailPage(inquiryDetail: inquiries[index]),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiries[index]['title'] ?? '제목 없음',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '내용: ${inquiries[index]['content'] ?? '내용 없음'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${inquiries[index]['isChecked'] ? '답변 완료' : '미답변'}', // Display isChecked status
                          style: TextStyle(
                            fontSize: 14,
                            color: inquiries[index]['isChecked'] ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CreateInquiryPage extends StatefulWidget {
  final Future<void> Function() onInquiryAdded;

  CreateInquiryPage({required this.onInquiryAdded});

  @override
  _CreateInquiryPageState createState() => _CreateInquiryPageState();
}

class _CreateInquiryPageState extends State<CreateInquiryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의작성하기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: '제목을 입력하세요'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: '내용을 입력하세요'),
                maxLines: 10,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await sendPost().makePost(
                      _titleController.text,
                      _contentController.text,
                    );
                    await widget.onInquiryAdded(); // Add this line to fetch updated inquiries
                    Navigator.pop(context);
                  } catch (e) {
                    print('Failed to send inquiry: $e');
                  }
                },
                child: Text('작성하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestPost {
  Future<List<Map<String, dynamic>>> getPosts(int userId) async {
    final String baseUrl = "$baseIP/board/get-posts";
    final uriWithParams = Uri.parse(baseUrl).replace(
      queryParameters: {
        'userId': userId.toString(),
      },
    );

    final response = await http.get(uriWithParams);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('Server response: $jsonResponse'); // Debugging log

      return jsonResponse.map((item) {
        print('Processing item: $item'); // 각 아이템 로그 출력
        return {
          'id': item['id'] as int,
          'title': item['title'] as String? ?? '제목 없음',
          'content': item['content'] as String? ?? '내용 없음',
          'user_id': item['user']['id'] as int? ?? 0, // Fix user_id mapping
          'isChecked': item['checked'] == true, // Map checked to isChecked
          'comment': item['comment'] as String? ?? '댓글 없음',
        };
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}


class RequestNotice {
  Future<List<Map<String, dynamic>>> getNotices() async {
    final String baseUrl = "$baseIP/board/get-posts";
    final uriWithParams = Uri.parse(baseUrl).replace(
      queryParameters: {
        'userId': '1', // 모든 사용자 공통 공지사항
      },
    );

    print('Requesting notices from: $uriWithParams'); // Print request URL

    final response = await http.get(uriWithParams);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('Server response (notices): $jsonResponse'); // Debugging log

      // Check if the response is actually a list and not null
      if (jsonResponse != null && jsonResponse is List) {
        return jsonResponse.map((item) {
          print('Processing notice: $item'); // Each item log
          return {
            'title': item['title'] as String? ?? '제목 없음',
            'content': item['content'] as String? ?? '내용 없음',
          };
        }).toList();
      } else {
        print('Unexpected response format: $jsonResponse');
        return [];
      }
    } else {
      print('Failed to load notices with status code: ${response.statusCode}');
      throw Exception('Failed to load notices');
    }
  }
}


class sendPost {
  Future<void> makePost(String title, String content) async {
    final String baseUrl = "$baseIP/board";
    int user_id = loginPage.LoginPage.user_id;

    Map<String, dynamic> postData = {
      'title': title,
      'content': content,
      'user_id': user_id,
    };

    String jsonData = jsonEncode(postData);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('문의작성 완료');
    } else {
      throw Exception('Failed to make post');
    }
  }
}

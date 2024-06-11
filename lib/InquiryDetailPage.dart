import 'package:flutter/material.dart';

class InquiryDetailPage extends StatelessWidget {
  final Map<String, dynamic> inquiryDetail;

  InquiryDetailPage({required this.inquiryDetail});

  @override
  Widget build(BuildContext context) {
    print('Inquiry Detail: $inquiryDetail'); // 디버깅 로그

    return Scaffold(
      appBar: AppBar(
        title: Text('문의 내용'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inquiryDetail['title'] ?? '제목 없음',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                inquiryDetail['content'] ?? '내용 없음',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${inquiryDetail['isChecked'] ? '답변 완료' : '미답변'}',
                style: TextStyle(
                  fontSize: 16,
                  color: inquiryDetail['isChecked'] ? Colors.green : Colors.red,
                ),
              ),
              if (inquiryDetail['isChecked'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      '답변 내용',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      inquiryDetail['comment'] ?? '댓글 없음',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

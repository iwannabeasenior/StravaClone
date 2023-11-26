import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chính'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Hiển thị trang trượt lên khi nút được nhấn
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return MyBottomSheetContent();
              },
            );
          },
          child: Text('Mở trang trượt lên'),
        ),
      ),
    );
  }
}

class MyBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100000,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nội dung trang trượt lên',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          // Thêm nội dung khác tại đây
          ElevatedButton(
            onPressed: () {
              // Đóng trang trượt lên khi nút được nhấn
              Navigator.pop(context);
            },
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

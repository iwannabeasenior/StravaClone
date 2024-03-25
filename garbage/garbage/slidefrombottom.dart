import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chính'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Hiển thị trang trượt lên khi nút được nhấn
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return const MyBottomSheetContent();
              },
            );
          },
          child: const Text('Mở trang trượt lên'),
        ),
      ),
    );
  }
}

class MyBottomSheetContent extends StatelessWidget {
  const MyBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100000,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Nội dung trang trượt lên',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          // Thêm nội dung khác tại đây
          ElevatedButton(
            onPressed: () {
              // Đóng trang trượt lên khi nút được nhấn
              Navigator.pop(context);
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

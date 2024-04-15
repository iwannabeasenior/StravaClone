import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyAppLifecycle(),
    );
  }
}

class MyAppLifecycle extends StatefulWidget {
  const MyAppLifecycle({super.key});

  @override
  _MyAppLifecycleState createState() => _MyAppLifecycleState();
}

class _MyAppLifecycleState extends State<MyAppLifecycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Đăng ký WidgetsBindingObserver để theo dõi vòng đời của ứng dụng
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Hủy đăng ký WidgetsBindingObserver khi widget bị huỷ
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Xử lý các thay đổi trong vòng đời của ứng dụng
    switch (state) {
      case AppLifecycleState.resumed:
      // Ứng dụng đã được tiếp tục chạy
        print('App resumed');
        break;
      case AppLifecycleState.inactive:
      // Ứng dụng không còn nhận được sự chú ý của người dùng
        print('App inactive');
        break;
      case AppLifecycleState.paused:
      // Ứng dụng đã tạm dừng
        print('App paused');
        break;
      case AppLifecycleState.detached:
      // Ứng dụng đã bị detach, không còn chạy nữa
        print('App detached');
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Lifecycle'),
      ),
      body: const Center(
        child: Text('App Lifecycle Demo'),
      ),
    );
  }
}

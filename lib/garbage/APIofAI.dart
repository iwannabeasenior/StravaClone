import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:strava_client/strava_client.dart';

void main() async {
  final accessToken = 'YOUR_ACCESS_TOKEN'; // Access token của Strava của bạn

  final activityData = {
    'name': 'Hoạt động mới của tôi', // Tên hoạt động của bạn
    'type': 'ride', // Loại hoạt động (ví dụ: 'ride' hoặc 'run')
    'start_date_local': '2023-11-03T09:00:00Z', // Thời gian bắt đầu hoạt động theo định dạng ISO 8601
    'elapsed_time': 3600, // Thời gian thực hiện hoạt động trong giây
    'distance': 20000, // Khoảng cách hoạt động trong mét
    // Thêm dữ liệu hoạt động khác tùy theo nhu cầu của bạn
  };

  final uploadUrl = Uri.parse('https://www.strava.com/api/v3/activities');

  final response = await http.post(
    uploadUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(activityData),
  );

  if (response.statusCode == 201) {
    final newActivity = jsonDecode(response.body);
    print("Hoạt động đã được tải lên thành công!");
    print("ID Hoạt động: ${newActivity['id']}");
  } else {
    print("Lỗi khi tải lên hoạt động: ${response.statusCode}");
  }
}
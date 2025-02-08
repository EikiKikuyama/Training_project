import 'package:flutter/material.dart';

void xxxx() {
  debugPrint('ボタンが押されました');
  debugPrint('通信中です'); // 通信処理
  debugPrint('通信が完了しました'); // 通信処理
}

final bun = ElevatedButton(
  onPressed: xxxx,
  child: Text('ボタン'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: bun,
      ),
    ),
  ));
}

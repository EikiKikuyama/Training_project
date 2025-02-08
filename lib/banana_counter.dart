import 'package:flutter/material.dart';

class BananaCounter extends StatelessWidget {
  //バナナの数を表示するウィジェット
  final int number;
  const BananaCounter({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
//バナナの画像
    final banana = Image.asset(
      'images/banana.png',
      width: 50,
      height: 50,
    );
//バナナの数
    final bananaCount = Text('$number');

    final row = Row(children: [
      banana,
      bananaCount,
    ]);

    final con = Container(
      color: Colors.blue,
      child: row,
    );

    return con;
  }
}

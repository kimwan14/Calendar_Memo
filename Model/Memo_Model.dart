import 'dart:core';

class MemoData {
  late final String title;
  late final String memo;
  late final DateTime time;

  MemoData({required this.title,required this.memo,required this.time});

  @override
  String toString() => title;
  }



import 'package:flutter/material.dart';

class Task {
  final int id;
  final String userId;
  final String title;
  final String desc;
  final String color;
  final int status;
  final int createdAt;
  final int modifiedAt;
  //final int remainder;
  final bool finished;

  Task(
      {required this.id,
      required this.userId,
      required this.title,
      required this.desc,
      this.color = "0xff67ac5c",
      this.status = 1,
      required this.createdAt,
      required this.modifiedAt,
      this.finished = false});

  test() {
    DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userid': userId,
      'desc': desc,
      'color': color,
      'status': status,
      'created': createdAt,
      'modified': modifiedAt,
      'finished': finished ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userid'],
      title: map['title'],
      desc: map['desc'],
      color: map['color'],
      status: map['status'],
      createdAt: map['created'],
      modifiedAt: map['modified'],
      finished: (map['finished']) == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'color': color,
      'status': status,
      'created': createdAt,
      'modified': modifiedAt,
      'finished': finished ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, desc: $desc,color: $color,status: $status,createdAt: $createdAt,modifiedAt: $modifiedAt,finished: $finished,   userId: $userId}';
  }

  static final tableName = 'tasks';
  static final String createTableComment =
      'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,userid TEXT, title TEXT, desc TEXT, color TEXT, status INTEGER, created INTEGER, modified INTEGER, finished INTEGER )';
}

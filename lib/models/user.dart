import 'package:uuid/uuid.dart';

class TaskUser {
  final String uid;
  final String name;
  final String email;
  final String password;
  final int createdAt;
  final int modifiedAt;
  final String profile;

  TaskUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.modifiedAt,
    required this.profile,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'created': createdAt,
      'modified': modifiedAt,
      'profile': profile,
    };
  }

  static TaskUser fromMap(Map<String, dynamic> map) {
    return TaskUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: map['created'],
      modifiedAt: map['modified'],
      profile: map['profile'],
    );
  }

  @override
  String toString() {
    return 'Task{uid: $uid, name: $name, email: $email,password: $password,createdAt: $createdAt,modifiedAt: $modifiedAt, profile:$profile}';
  }

  static final tableName = 'users';
  static final String createTableComment =
      'CREATE TABLE $tableName(uid TEXT PRIMARY KEY NOT NULL, name TEXT, email TEXT, password TEXT, created INTEGER, modified INTEGER , profile TEXT)';
}

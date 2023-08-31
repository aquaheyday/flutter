// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  bool success;
  List<Datum> data;
  String message;

  User({
    required this.success,
    required this.data,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int id;
  String email;
  String receptionsType;
  String password;
  String title;
  String end;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.email,
    required this.receptionsType,
    required this.password,
    required this.title,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    email: json["email"],
    receptionsType: json["receptions_type"],
    password: json["password"],
    title: json["title"],
    end: json["end"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "receptions_type": receptionsType,
    "password": password,
    "title": title,
    "end": end,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

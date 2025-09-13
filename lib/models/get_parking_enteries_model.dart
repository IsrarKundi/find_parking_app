// To parse this JSON data, do
//
//     final getParkingEntriesModel = getParkingEntriesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetParkingEntriesModel getParkingEntriesModelFromJson(String str) => GetParkingEntriesModel.fromJson(json.decode(str));

String getParkingEntriesModelToJson(GetParkingEntriesModel data) => json.encode(data.toJson());

class GetParkingEntriesModel {
    bool success;
    String message;
    Data data;

    GetParkingEntriesModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetParkingEntriesModel.fromJson(Map<String, dynamic> json) => GetParkingEntriesModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    List<Entry> entries;

    Data({
        required this.entries,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        entries: List<Entry>.from(json["entries"].map((x) => Entry.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "entries": List<dynamic>.from(entries.map((x) => x.toJson())),
    };
}

class Entry {
    String id;
    String carNumber;
    DateTime entryTime;
    bool isActive;
    User user;

    Entry({
        required this.id,
        required this.carNumber,
        required this.entryTime,
        required this.isActive,
        required this.user,
    });

    factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        id: json["_id"],
        carNumber: json["carNumber"],
        entryTime: DateTime.parse(json["entryTime"]),
        isActive: json["isActive"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "carNumber": carNumber,
        "entryTime": entryTime.toIso8601String(),
        "isActive": isActive,
        "user": user.toJson(),
    };
}

class User {
    String id;
    String username;
    String email;
    String image;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.image,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "image": image,
    };
}

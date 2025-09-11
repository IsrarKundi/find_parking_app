// To parse this JSON data, do
//
//     final getUserProfileModel = getUserProfileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetUserProfileModel getUserProfileModelFromJson(String str) => GetUserProfileModel.fromJson(json.decode(str));

String getUserProfileModelToJson(GetUserProfileModel data) => json.encode(data.toJson());

class GetUserProfileModel {
    bool success;
    String message;
    Data data;

    GetUserProfileModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetUserProfileModel.fromJson(Map<String, dynamic> json) => GetUserProfileModel(
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
    String id;
    String username;
    String email;
    String role;
    double lng;
    double lat;
    String image;

    Data({
        required this.id,
        required this.username,
        required this.email,
        required this.role,
        required this.lng,
        required this.lat,
        required this.image,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        lng: json["lng"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "role": role,
        "lng": lng,
        "lat": lat,
        "image": image,
    };
}

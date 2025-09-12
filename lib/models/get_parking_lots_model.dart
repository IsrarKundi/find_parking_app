// To parse this JSON data, do
//
//     final getParkingLotsModel = getParkingLotsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetParkingLotsModel getParkingLotsModelFromJson(String str) => GetParkingLotsModel.fromJson(json.decode(str));

String getParkingLotsModelToJson(GetParkingLotsModel data) => json.encode(data.toJson());

class GetParkingLotsModel {
    bool success;
    String message;
    List<Datum> data;

    GetParkingLotsModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetParkingLotsModel.fromJson(Map<String, dynamic> json) => GetParkingLotsModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String username;
    String email;
    double lng;
    double lat;
    String image;
    int availableParkingSpots;
    int totalParkingSlots;
    int pricePerSlot;

    Datum({
        required this.id,
        required this.username,
        required this.email,
        required this.lng,
        required this.lat,
        required this.image,
        required this.availableParkingSpots,
        required this.totalParkingSlots,
        required this.pricePerSlot,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        lng: json["lng"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        image: json["image"],
        availableParkingSpots: json["availableParkingSpots"],
        totalParkingSlots: json["totalParkingSlots"],
        pricePerSlot: json["pricePerSlot"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "lng": lng,
        "lat": lat,
        "image": image,
        "availableParkingSpots": availableParkingSpots,
        "totalParkingSlots": totalParkingSlots,
        "pricePerSlot": pricePerSlot,
    };
}

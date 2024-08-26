import 'dart:convert';

BadgeModel badgeModelFromJson(String str) =>
    BadgeModel.fromJson(json.decode(str));

String badgeModelToJson(BadgeModel data) => json.encode(data.toJson());

class BadgeModel {
  final String? id;
  final String? icon;
  final String? title;
  final int? price;
  final String? paymentType;
  final String? type;
  final bool? alreadyRequested;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  BadgeModel({
    this.icon,
    this.id,
    this.title,
    this.price,
    this.paymentType,
    this.type,
    this.alreadyRequested,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
        icon: json['icon'],
        alreadyRequested: json['alreadyRequested'],
        id: json["_id"],
        title: json["title"],
        price: json["price"],
        paymentType: json["paymentType"],
        type: json["type"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "alreadyRequested": alreadyRequested,
        "_id": id,
        "title": title,
        "price": price,
        "paymentType": paymentType,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

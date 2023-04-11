import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meal_app/core/shared/utils/utils.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? uId;
  String? name;
  String? email;
  @TimestampConverter()
  DateTime? createdAt;
  String? photoUrl;
  List<String> favoriteMealsList;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.photoUrl,
    required this.favoriteMealsList,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'meal_model.g.dart';

@JsonSerializable()
class MealModel {
  String name;
  String chefUid;
  double rating;
  int minutes;
  String mealTypes;
  String mealId;
  List<String> ingredients;
  List<String> tags;
  String image;

  MealModel({
    required this.name,
    required this.chefUid,
    required this.rating,
    required this.minutes,
    required this.mealTypes,
    required this.mealId,
    required this.ingredients,
    required this.tags,
    required this.image,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return _$MealModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MealModelToJson(this);
}

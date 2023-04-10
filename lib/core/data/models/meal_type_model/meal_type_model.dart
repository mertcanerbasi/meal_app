import 'package:json_annotation/json_annotation.dart';

part 'meal_type_model.g.dart';

@JsonSerializable()
class MealTypeModel {
  String label;
  bool isSelected;

  MealTypeModel({
    required this.label,
    required this.isSelected,
  });

  factory MealTypeModel.fromJson(Map<String, dynamic> json) {
    return _$MealTypeModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MealTypeModelToJson(this);
}

enum MealType {
  lunch(name: "Lunch"),
  dinner(name: "Dinner"),
  breakfast(name: "Breakfast"),
  snacks(name: "Snacks");

  const MealType({required this.name});
  final String name;
}

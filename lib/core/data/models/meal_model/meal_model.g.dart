// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealModel _$MealModelFromJson(Map<String, dynamic> json) => MealModel(
      name: json['name'] as String,
      chefUid: json['chefUid'] as String,
      likes: json['likes'] as int,
      minutes: json['minutes'] as int,
      mealTypes: json['mealTypes'] as String,
      mealId: json['mealId'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
      'name': instance.name,
      'chefUid': instance.chefUid,
      'likes': instance.likes,
      'minutes': instance.minutes,
      'mealTypes': instance.mealTypes,
      'mealId': instance.mealId,
      'ingredients': instance.ingredients,
      'tags': instance.tags,
      'image': instance.image,
    };

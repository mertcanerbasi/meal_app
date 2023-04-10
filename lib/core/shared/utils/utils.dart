import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

extension GroupBy<T> on List<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    Map<K, List<T>> resultMap = {};
    for (T element in this) {
      K key = keyFunction(element);
      if (!resultMap.containsKey(key)) {
        resultMap[key] = [];
      }
      resultMap[key]?.add(element);
    }
    return resultMap;
  }
}

void navigateTo(context, widget, {bool isFullScreen = false}) => Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: isFullScreen,
        pageBuilder: (_, __, ___) => widget,
        opaque: !isFullScreen,
      ),
    );

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

extension BuildContextEx on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

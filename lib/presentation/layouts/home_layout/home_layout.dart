import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meal_app/core/shared/utils/utils.dart';

class HomeLayout extends StatelessWidget {
  final List<IconData> icons = const [
    FontAwesomeIcons.handsPraying,
    FontAwesomeIcons.clockRotateLeft,
    Icons.person,
    Icons.settings,
  ];

  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      context.l10n.pray,
      context.l10n.history,
      context.l10n.profile,
      context.l10n.settings,
    ];
    return const Scaffold();
  }
}

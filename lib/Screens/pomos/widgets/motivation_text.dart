import 'package:flutter/material.dart';

class MotivationText extends StatelessWidget {
  const MotivationText({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

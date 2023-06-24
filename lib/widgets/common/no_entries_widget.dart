import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoEntriesWidget extends StatelessWidget {
  const NoEntriesWidget({Key? key, required this.image, required this.text})
      : super(key: key);

  final Widget image; //TODO: prepare all svgsss and delete not important svgs
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        SizedBox(
          height: 20.h,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}

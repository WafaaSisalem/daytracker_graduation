import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/svgs/svgs.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    if (status == Constants.angry) {
      return svgAngry;
    } else if (status == Constants.happy) {
      return svgHappy;
    } else if (status == Constants.sad) {
      return svgSad;
    } else if (status == Constants.normal) {
      return svgNormal;
    } else {
      return svgSmile;
    }
  }
}

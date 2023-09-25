import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../provider/pomo_provider.dart';

class QuoteContainer extends StatelessWidget {
  const QuoteContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256.w,
      height: 80.h,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0x28000000), //
              offset: Offset(0, 1.h),
              blurRadius: 3),
        ],
      ),
      child: Text(
        Provider.of<PomoProvider>(context, listen: true).currentQuote!,
        style: Theme.of(context).textTheme.headline4,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
      ),
    );
  }
}

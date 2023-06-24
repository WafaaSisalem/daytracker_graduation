import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
      child: GridView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 36.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: const Color(0x28000000), //TODO: COLOR
                    offset: Offset(0, 1.h),
                    blurRadius: 3),
              ], borderRadius: BorderRadius.circular(5.r)),
              child: Image.asset(
                'assets/images/tanjiro.jpg',
                fit: BoxFit.cover,
              ),
            );
          }),
    );
  }
}

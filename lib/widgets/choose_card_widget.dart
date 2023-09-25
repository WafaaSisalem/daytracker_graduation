import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MyDirection { left, right }

class ChooseCardWidget extends StatelessWidget {
  const ChooseCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onPressed,
    required this.textDirection,
  }) : super(key: key);

  final String title;
  final String description;
  final String imagePath;
  final Function onPressed;
  final MyDirection textDirection;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Stack(
        alignment: textDirection == MyDirection.left
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 19.h),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                // TODO: set an elevation to this container

                color: const Color(0x1CBB86FC)), //
            child: Row(
              children: [
                textDirection == MyDirection.left
                    ? const SizedBox()
                    : const Expanded(flex: 6, child: SizedBox()),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: EDIT TITLE'S ALIGNMENT IN THE DIRECTION.RIGHT MODE
                      Text(title.toUpperCase(),
                          style: theme.textTheme.headline1!.copyWith(
                            letterSpacing: 3.w,
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 155.w,
                        child: Text(
                          description,
                          style: theme.textTheme.subtitle2,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            imagePath,
            width: 141.w,
            height: 145.h,
          )
        ],
      ),
    );
  }
}

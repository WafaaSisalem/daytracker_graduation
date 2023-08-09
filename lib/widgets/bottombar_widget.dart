import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({
    Key? key,
    required this.svgs,
    required this.onTap,
    // required this.tabElements,
  }) : super(key: key);
  final List<String> svgs;
  final Function(int) onTap;
  // final List<Map<String, dynamic>> tabElements;

  ///   [
  ///     {'svg': assetsImages+'allnote.svg', 'function': () {}},
  ///     {'svg': assetsImages+'calendar.svg', 'function': () {}},
  ///     {'svg': assetsImages+'search.svg', 'function': () {}},
  ///     {'svg': assetsImages+'theme.svg', 'function': () {}},
  ///   ]

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int selectedIndex = 0;

  final placeHolder = const Opacity(
    opacity: 0,
    child: IconButton(onPressed: null, icon: Icon(Icons.no_cell)),
  );
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: 64.h,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey[200]!, //TODO: COLOR
            offset: Offset(0, -4.h),
            blurRadius: 4),
      ], borderRadius: BorderRadius.vertical(top: Radius.circular(36.r))),
      child: BottomAppBar(
          color: Colors.white, //TODO: COLOR
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.w,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                tabElementMethod(theme, index: 0),
                tabElementMethod(theme, index: 1),
                placeHolder,
                placeHolder,
                tabElementMethod(theme, index: 2),
                tabElementMethod(theme, index: 3),
                SizedBox(
                  width: 10.w,
                )
              ],
            ),
          )),
    );
  }

  SizedBox tabElementMethod(ThemeData theme, {required int index}) {
    return SizedBox(
      width: 65.w,
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: selectedIndex == index
            ? theme.primaryColor
            : Colors.white, //TODO: COLOR
        child: TextButton(
            onPressed: () {
              widget.onTap(index);
              // widget.tabElements[index]['function'](index);
              selectedIndex = index;
              setState(() {});
            },
            child: SvgPicture.asset(
              // widget.tabElements[index]['svg'],
              widget.svgs[index],
              color: selectedIndex == index
                  ? Colors.white
                  : theme.primaryColor, //TODO: COLOR
            )),
      ),
    );
  }
}

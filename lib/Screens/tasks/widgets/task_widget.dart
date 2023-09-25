import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/svgs/svgs.dart';

class TaskWidget extends StatelessWidget {
  TaskWidget({
    Key? key,
    required this.task,
    required this.onTaskTap,
    required this.onPasswordIconTap,
    required this.onDeleteIconTap,
    required this.onLongPress,
    required this.isSelected,
    required this.isSelectionMode,
  }) : super(key: key);

  final TaskModel task;
  final Function() onTaskTap;
  final Function() onPasswordIconTap;
  final Function() onDeleteIconTap;
  final Function() onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onTaskTap(),
      onLongPress: () => onLongPress(),
      child: Stack(
        children: [
          noteBackground(),
          Container(
            width: 324.w,
            height: 107.8.h,
            padding: EdgeInsets.only(
                left: 20.w, right: 13.w, top: 13.h, bottom: 13.h),
            child: Column(
              crossAxisAlignment: task.isLocked
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                taskHead(theme, context),
                taskBody(theme, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row taskHead(ThemeData theme, BuildContext context) => Row(
        children: [
          SizedBox(
            width: 30.w,
          ),
          const Spacer(),
          if (isSelectionMode)
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off_outlined,
              color: theme.primaryColor,
            )
          else ...[
            deleteIcon(context, theme),
            SizedBox(
              width: 15.w,
            ),
            passwordIcon(context),
          ]
        ],
      );

  GestureDetector passwordIcon(BuildContext context) => GestureDetector(
        onTap: () {
          onPasswordIconTap();
        },
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: task.isLocked ? svgUnlock : svgLock,
        ),
      );

  GestureDetector deleteIcon(BuildContext context, ThemeData theme) =>
      GestureDetector(
        onTap: () {
          onDeleteIconTap();
        },
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: svgDelete,
        ),
      );

  SizedBox noteBackground() => SizedBox(
        width: 324.w,
        height: 107.8.h,
        child: Image.asset(
          'assets/images/rect_note_item.png',
          fit: BoxFit.fill,
        ),
      );

  Expanded taskBody(ThemeData theme, BuildContext context) => Expanded(
        child: task.isLocked ? lockedBody(theme) : unLockedBody(context, theme),
      );

  Column unLockedBody(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Text(
          task.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headline2!
              .copyWith(height: 1.7.h, color: Colors.black),
        ),
        const Spacer(),
        task.title != task.formatedDate ? dateWidget(theme) : const SizedBox()
      ],
    );
  }

  Align dateWidget(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        task.formatedDate,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: theme.colorScheme.secondary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Column lockedBody(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Spacer(),
        SizedBox(
          width: 30.w,
          height: 30.h,
          child: svgGreyLock,
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          task.title,
          style: theme.textTheme.subtitle2!
              .copyWith(color: const Color(0xFFC4C4C4)), //
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

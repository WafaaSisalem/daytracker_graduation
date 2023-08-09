import 'package:day_tracker_graduation/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/svgs/svgs.dart';

enum NoteShape {
  rectangle,
  square,
}

class NoteWidget extends StatelessWidget {
  NoteWidget({
    Key? key,
    required this.note,
    required this.onNoteTap,
    required this.onPasswordIconTap,
    required this.onDeleteIconTap,
    required this.shape,
    required this.onLongPress,
    required this.isSelected,
    required this.isSelectionMode,
  }) : super(key: key);

  final NoteModel note;
  final NoteShape shape;
  final Function() onNoteTap;
  final Function() onPasswordIconTap;
  final Function() onDeleteIconTap;
  final Function() onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onNoteTap(),
      onLongPress: () => onLongPress(),
      child: Stack(
        children: [
          noteBackground(),
          Container(
            width: 324.w,
            height: 140.8.h,
            padding: EdgeInsets.only(
                left: 13.w,
                right: 13.w,
                top: 13.h,
                bottom: shape == NoteShape.rectangle ? 13.h : 0),
            child: Column(
              children: [
                noteHead(theme, context),
                noteBody(theme, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row noteHead(ThemeData theme, BuildContext context) => Row(
        children: [
          SizedBox(
            width: 30.w,
          ),
          shape == NoteShape.rectangle
              ? titlePlace(theme)
              : const Expanded(child: SizedBox()),
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
          width: 17.w,
          height: 17.h,
          child: note.isLocked ? svgUnlock : svgLock,
        ),
      );

  GestureDetector deleteIcon(BuildContext context, ThemeData theme) =>
      GestureDetector(
        onTap: () {
          onDeleteIconTap();
        },
        child: SizedBox(
          width: 17.w,
          height: 17.h,
          child: svgDelete,
        ),
      );

  Expanded titlePlace(ThemeData theme) => Expanded(
        child: note.isLocked
            ? Text(
                note.formatedDate,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: theme.colorScheme.secondary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500),
              )
            : Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
      );

  SizedBox noteBackground() => shape == NoteShape.rectangle
      ? SizedBox(
          width: 324.w,
          height: 140.8.h,
          child: Image.asset(
            'assets/images/rect_note_item.png',
            fit: BoxFit.fill,
          ),
        )
      : SizedBox(
          width: 167.w,
          height: 180.h,
          child: Image.asset(
            'assets/images/square_note_item.png',
            fit: BoxFit.fill,
          ),
        );

  Expanded noteBody(ThemeData theme, BuildContext context) => Expanded(
        child: note.isLocked ? lockedBody(theme) : unLockedBody(context, theme),
      );

  Column unLockedBody(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SizedBox()),
        Text(
          note.content,
          maxLines: shape == NoteShape.rectangle ? 3 : 4,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.7.h),
        ),
        const Expanded(child: SizedBox()),
        dateWidget(theme)
      ],
    );
  }

  Align dateWidget(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        note.formatedDate,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: theme.colorScheme.secondary,
            fontSize: shape == NoteShape.rectangle ? 10.sp : 7.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Column lockedBody(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(child: SizedBox()),
        SizedBox(
          width: 30.w,
          height: 30.h,
          child: svgGreyLock,
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          note.title,
          style: theme.textTheme.subtitle2!
              .copyWith(color: const Color(0xFFC4C4C4)), //TODO: color
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Expanded(child: SizedBox()),
        shape == NoteShape.rectangle ? SizedBox() : dateWidget(theme),
      ],
    );
  }
}

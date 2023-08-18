import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/journal_model.dart';
import '../../../utils/svgs/svgs.dart';

class JournalWidget extends StatelessWidget {
  const JournalWidget({
    Key? key,
    required this.journal,
    required this.onJournalTap,
    required this.onLongPress,
    required this.isSelected,
    required this.isSelectionMode,
  }) : super(key: key);

  final JournalModel journal;
  final Function() onJournalTap;
  final Function() onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onJournalTap(),
      onLongPress: () => onLongPress(),
      child: Stack(
        children: [
          journalBackground(),
          Container(
            width: 324.w,
            height: 180.8.h,
            padding: EdgeInsets.only(
                left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                journalHead(theme, context),
                SizedBox(
                  height: 10.h,
                ),
                journal.isLocked
                    ? Expanded(
                        child: SizedBox(
                          width: 50.w,
                          height: 50.h,
                          child: svgGreyLock,
                        ),
                      )
                    : journalBody(theme, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded journalBody(ThemeData theme, BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('hh:mm a')
                      .format(journal.date), //must be  '11:30 PM'
                  style: theme.textTheme.headline3!
                      .copyWith(color: theme.primaryColor),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    journal.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(height: 1.7.h),
                  ),
                ),
                // const Expanded(child: SizedBox()),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 5,

                        backgroundColor: Colors.white, //TODO: COLORS
                        child: StatusWidget(status: journal.status),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        width: 12.w,
                        height: 9.h,
                        child: svgWeather,
                      ),
                      Text(
                        ' 23 c',
                        style: myTextStyle(theme),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        width: 110.w,
                        child: Text(
                          journal.location,
                          style: myTextStyle(theme),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (journal.imagesUrls.isNotEmpty) ...[
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              flex: 1,
              child: Hero(
                tag: journal.id,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x28000000), //TODO: COLOR
                              offset: Offset(0, 1.h),
                              blurRadius: 3),
                        ]),
                    // child: Image.network(
                    //   journal.imagesUrls[0],
                    //   fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: journal.imagesUrls[0],
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
            ),
          ]
        ],
      ),
    );
  }

  TextStyle myTextStyle(ThemeData theme) {
    return TextStyle(
        fontFamily: 'Poppins',
        color: theme.colorScheme.secondary,
        fontSize: 8.sp,
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis);
  }

  Row journalHead(ThemeData theme, BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMMM d, y. EEE').format(journal.date),
            style: theme.textTheme.headline1!.copyWith(
              fontSize: 15.sp,
            ),
          ),
          if (isSelectionMode)
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off_outlined,
              color: theme.primaryColor,
            )
        ],
      );

  SizedBox journalBackground() => SizedBox(
        width: 324.w,
        height: 180.8.h,
        child: Image.asset(
          'assets/images/rect_journal_item.png',
          fit: BoxFit.fill,
        ),
      );

  Align dateWidget(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        journal.location,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: theme.colorScheme.secondary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

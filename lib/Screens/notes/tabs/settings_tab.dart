import 'package:day_tracker_graduation/helpers/shared_preference_helper.dart';
import 'package:day_tracker_graduation/Screens/notes/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  int themeChoice = SharedPreferenceHelper.sharedHelper.getTheme() == null
      ? 0
      : SharedPreferenceHelper.sharedHelper.getTheme();
  int viewChoice = SharedPreferenceHelper.sharedHelper.getView() == null
      ? 1
      : SharedPreferenceHelper.sharedHelper.getView();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            // Text(
            //   'Theme',
            //   style: theme.textTheme.headline1,
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     NoteSettingsWidget(
            //         radioValue: 1,
            //         groupValue: themeChoice,
            //         containerColor: Colors.white,
            //         containerChild: Text(
            //           'Light',
            //           style: theme.textTheme.headline2!.copyWith(
            //               color: const Color(0xFF121212)), //TODO:COLOR,
            //         ),
            //         onTap: (choice) {
            //           themeChoice = choice;
            //           SharedPreferenceHelper.sharedHelper.setTheme(choice);
            //           setState(() {});
            //         }),
            //     NoteSettingsWidget(
            //         radioValue: 2,
            //         groupValue: themeChoice,
            //         containerColor: const Color(0xFF1E1E1E), //TODO:COLOR,
            //         containerChild: Text(
            //           'Dark',
            //           style: theme.textTheme.headline2,
            //         ),
            //         onTap: (choice) {
            //           themeChoice = choice;
            //           setState(() {
            //             SharedPreferenceHelper.sharedHelper.setTheme(choice);
            //           });
            //         }),
            //   ],
            // ),
            // SizedBox(
            //   height: 30.h,
            // ),
            Text(
              'View',
              style: theme.textTheme.headline1,
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NoteSettingsWidget(
                    radioValue: 1,
                    groupValue: viewChoice,
                    containerColor: const Color(0xFFF3F3F3),
                    containerChild: Image.asset('assets/images/rect_view.png'),
                    onTap: (choice) {
                      viewChoice = choice;
                      SharedPreferenceHelper.sharedHelper.setView(choice);
                      setState(() {});
                    }),
                NoteSettingsWidget(
                    radioValue: 2,
                    groupValue: viewChoice,
                    containerColor: const Color(0xFFF3F3F3),
                    containerChild:
                        Image.asset('assets/images/square_view.png'),
                    onTap: (choice) {
                      viewChoice = choice;
                      SharedPreferenceHelper.sharedHelper.setView(choice);
                      setState(() {});
                    })
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}

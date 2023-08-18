import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_tracker_graduation/Screens/journals/image_slider_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/journal_edit_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/status_widget.dart';
import 'package:day_tracker_graduation/Screens/master_password_screen.dart';
import 'package:day_tracker_graduation/models/journal_model.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../notes/widgets/writing_place.dart';
import '../../utils/svgs/svgs.dart';
import 'journal_home_screen.dart';

class JournalDisplayScreen extends StatelessWidget {
  // final List<Widget> widgets = [
  //   Image.asset(
  //     'assets/images/team.jpg',
  //     fit: BoxFit.cover,
  //   ),
  //   Image.asset(
  //     'assets/images/tanjiro.jpg',
  //     fit: BoxFit.cover,
  //   ),
  //   Image.asset(
  //     'assets/images/sunset.jpg',
  //     fit: BoxFit.cover,
  //   )
  // ];
  JournalDisplayScreen({
    Key? key,
    required this.journal,
  }) : super(key: key);
  final JournalModel journal;
  get status {
    return StatusWidget(status: journal.status);
  }

  // String content = '';
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, JournalProvider>(
        builder: (context, authProvider, journalProvider, child) {
      // content = journal!.content;

      return Scaffold(
        appBar: AppbarWidget(
            titlePlace: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.r,
                color: Colors.white, //TODO: COLOR
              ),
              onPressed: () {
                AppRouter.router
                    .pushWithReplacementFunction(const JournalHomeScreen());
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return DialogWidget(
                //           dialogType: DialogType.discard,
                //           entryType: 'journal',
                //           onOkPressed: (value) {
                //             AppRouter.router.pop();
                //             AppRouter.router
                //                 .pushWithReplacementFunction(JournalHomeScreen());
                //           });
                //     });
              },
            ),
            actions: [
              InkWell(
                child: svgWhiteDelete,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                            dialogType: DialogType.delete,
                            entryType: 'journal',
                            onOkPressed: (value) {
                              journalProvider.deleteJournal(
                                  journalId: journal.id);
                              AppRouter.router.pop();
                              AppRouter.router.pushWithReplacementFunction(
                                  JournalHomeScreen());
                            });
                      });
                },
              ),
              SizedBox(
                width: 15.w,
              ),
              InkWell(
                // splashColor: Colors.transparent,
                child: journal.isLocked ? svgWhiteUnlock : svgWhiteLock,
                onTap: () {
                  if (journalProvider.userModel!.masterPassword.isEmpty) {
                    AppRouter.router
                        .pushFunction(MasterPassScreen(item: journal));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                              dialogType: DialogType.password,
                              entryType: 'journal',
                              onOkPressed: (value) {
                                if (value.isEmpty) {
                                  showToast('Password can not be empty!',
                                      context: context);
                                } else {
                                  if (journalProvider
                                          .userModel!.masterPassword ==
                                      value) {
                                    if (journal.isLocked) {
                                      journalProvider
                                          .updateJournal(JournalModel.fromMap({
                                        ...journal.toMap(),
                                        Constants.isLockedKey: 0,
                                      }));
                                    } else {
                                      journalProvider
                                          .updateJournal(JournalModel.fromMap({
                                        ...journal.toMap(),
                                        Constants.isLockedKey: 1,
                                      }));
                                    }

                                    AppRouter.router.pop();
                                    // AppRouter.router
                                    //     .pushWithReplacementFunction(
                                    //         NoteHomeScreen());
                                  } else {
                                    showToast('Wrong Password!',
                                        context: context,
                                        position: StyledToastPosition.top);
                                  }
                                }
                              });
                        });
                  }
                },
              ),
              SizedBox(
                width: 15.w,
              ),
              InkWell(
                // splashColor: Colors.transparent,
                child: svgEditIcon,
                onTap: () {
                  AppRouter.router
                      .pushWithReplacementFunction(JournalEditScreen(
                    journal: journal,
                  ));
                },
              ),
              SizedBox(
                width: 30.w,
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            children: [
              if (journal.imagesUrls.isNotEmpty) ...[
                imageSlider(),
                SizedBox(height: 7.h)
              ],
              dateStack(context),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: WritingPlaceWidget(
                  enabled: false,
                  onChanged: (value) {},
                  contentText: journal.content,
                  hintText: 'What happened with you today?',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {},
                    iconSize: 25.r,
                    color: Colors.grey, //TODO: COLOR
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {},
                    iconSize: 25.r,
                    color:
                        Theme.of(context).colorScheme.secondary, //TODO: COLOR
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  imageSlider() {
    int currentImageIndex = 0;
    return Container(
      width: double.infinity,
      height: 150.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color(0x28000000), //TODO: COLOR
              offset: Offset(0, 3.h),
              blurRadius: 6),
        ],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: ImageSlideshow(
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
        onPageChanged: (value) => currentImageIndex = value,
        children: journal.imagesUrls
            .map((imageUrl) => InkWell(
                  child: Hero(
                    tag: journal.id,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // child: Image.network(
                    //   imageUrl,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  onTap: () {
                    AppRouter.router.pushFunction(ImageSliderViewerScreen(
                        journal: journal,
                        currentImageIndex: currentImageIndex));
                  },
                ))
            .toList(),
      ),
    );
  }

  Stack dateStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 17.h,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(17.r)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 9.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              datecontainer(
                  context: context,
                  width: 30.w,
                  text: journal.date.day.toString(),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 15.sp)),
              datecontainer(
                  context: context,
                  text: DateFormat('MMMM d, y').format(journal.date),
                  width: 103.w,
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600)),
              datecontainer(
                context: context,
                width: 103.w,
                textStyle: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                text: DateFormat('EEEE. hh:mm a').format(journal.date),
              ),
              statusContainer()
            ],
          ),
        ),
      ],
    );
  }

  Container statusContainer() {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0x28000000), //TODO: COLOR
                offset: Offset(0, 1.h),
                blurRadius: 3),
          ],
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white // TODO: COLOR
          ),
      child: Center(
        child: status ?? svgSmile,
      ),
    );
  }

  Container datecontainer({
    required BuildContext context,
    required double width,
    required String text,
    required TextStyle textStyle,
  }) {
    return Container(
      width: width,
      height: 30.h,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0x28000000), //TODO: COLOR
                offset: Offset(0, 1.h),
                blurRadius: 3),
          ],
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white // TODO: COLOR
          ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

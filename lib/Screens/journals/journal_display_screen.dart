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

class JournalDisplayScreen extends StatefulWidget {
  JournalDisplayScreen({
    Key? key,
    required this.journal,
  }) : super(key: key);
  final JournalModel journal;

  @override
  State<JournalDisplayScreen> createState() => _JournalDisplayScreenState();
}

class _JournalDisplayScreenState extends State<JournalDisplayScreen> {
  get status {
    return StatusWidget(status: widget.journal.status);
  }

  late bool isLocked;
  @override
  void initState() {
    isLocked = widget.journal.isLocked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, JournalProvider>(
        builder: (context, authProvider, journalProvider, child) {
      // content = journal!.content;

      return Scaffold(
        appBar: AppbarWidget(
            titlePlace: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 28,
                color: Colors.white, //
              ),
              onPressed: () {
                AppRouter.router
                    .pushWithReplacementFunction(const JournalHomeScreen());
              },
            ),
            actions: [
              InkWell(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: svgWhiteDelete,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                            dialogType: DialogType.delete,
                            entryType: 'journal',
                            onOkPressed: (value) {
                              journalProvider.deleteJournal(
                                  journalId: widget.journal.id);
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
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: isLocked ? svgWhiteUnlock : svgWhiteLock,
                ),
                onTap: () {
                  if (authProvider.userModel!.masterPassword.isEmpty) {
                    AppRouter.router
                        .pushFunction(MasterPassScreen(item: widget.journal));
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
                                  if (authProvider.userModel!.masterPassword ==
                                      value) {
                                    if (isLocked) {
                                      journalProvider
                                          .updateJournal(JournalModel.fromMap({
                                        ...widget.journal.toMap(),
                                        Constants.isLockedKey: 0,
                                      }));
                                      isLocked = false;
                                      setState(() {});
                                    } else {
                                      journalProvider
                                          .updateJournal(JournalModel.fromMap({
                                        ...widget.journal.toMap(),
                                        Constants.isLockedKey: 1,
                                      }));
                                      isLocked = true;
                                      setState(() {});
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
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: svgEditIcon,
                ),
                onTap: () {
                  AppRouter.router
                      .pushWithReplacementFunction(JournalEditScreen(
                    journal: widget.journal,
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
              if (widget.journal.imagesUrls.isNotEmpty) ...[
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
                  controller:
                      TextEditingController(text: widget.journal.content),
                  hintText: 'What happened with you today?',
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.arrow_back_ios_rounded),
              //       onPressed: () {},
              //       iconSize: 25.r,
              //       color: Colors.grey, //
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.arrow_forward_ios),
              //       onPressed: () {

              //       },
              //       iconSize: 25.r,
              //       color:
              //           Theme.of(context).colorScheme.secondary, //
              //     ),
              //   ],
              // ),
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
              color: const Color(0x28000000), //
              offset: Offset(0, 3.h),
              blurRadius: 6),
        ],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: ImageSlideshow(
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
        onPageChanged: (value) => currentImageIndex = value,
        children: widget.journal.imagesUrls
            .map((imageUrl) => InkWell(
                  child: Hero(
                    tag: widget.journal.id,
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
                        journal: widget.journal,
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
                  text: widget.journal.date.day.toString(),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 15.sp)),
              datecontainer(
                  context: context,
                  text: DateFormat('MMMM d, y').format(widget.journal.date),
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
                text: DateFormat('EEEE. hh:mm a').format(widget.journal.date),
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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 1.h),
            blurRadius: 3),
      ], borderRadius: BorderRadius.circular(5.r), color: Colors.white //
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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 1.h),
            blurRadius: 3),
      ], borderRadius: BorderRadius.circular(5.r), color: Colors.white //
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

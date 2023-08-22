import 'dart:io';
import 'package:day_tracker_graduation/Screens/journals/widgets/pick_image_widget.dart';
import 'package:day_tracker_graduation/models/journal_model.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/services/firestorage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/svgs/svgs.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/floating_calendar.dart';
import '../notes/widgets/writing_place.dart';
import 'journal_home_screen.dart';

class JournalAddScreen extends StatefulWidget {
  const JournalAddScreen({Key? key}) : super(key: key);

  @override
  State<JournalAddScreen> createState() => _JournalAddScreenState();
}

class _JournalAddScreenState extends State<JournalAddScreen> {
  // String date = DateFormat('MMMM d, y').format(DateTime.now()).toString();
  DateTime date = DateTime.now();
  String content = '';
  String status = '';
  // String imageUrl = '';
  List<String> imagesUrls = [];
  // List<File> files = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
      return Scaffold(
        appBar: AppbarWidget(
            titlePlace: Row(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18.r,
                  color: Colors.white, //TODO: COLOR
                ),
                onPressed: () {
                  if (content == '') {
                    AppRouter.router
                        .pushWithReplacementFunction(JournalHomeScreen());
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                              dialogType: DialogType.discard,
                              entryType: 'journal',
                              onOkPressed: (value) {
                                AppRouter.router.pop();
                                AppRouter.router.pushWithReplacementFunction(
                                    JournalHomeScreen());
                              });
                        });
                  }
                },
              ),
              SizedBox(
                width: 70.w,
              ),
              InkWell(
                onTap: () async {
                  DateTime? val =
                      await floatingCalendarWidget(context, initialDate: date);
                  setState(() {
                    date = val ?? DateTime.now();
                  });
                },
                child: Container(
                  height: 23.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM d, y').format(date).toString(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.sp,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          height: 15.h,
                          width: 1.w,
                          color: Colors.grey[200],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.colorScheme.secondary,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              // title: Text('Wait for the photos to be uploaded'),
                              content: SizedBox(
                                  width: 50.w,
                                  height: 50.h,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: theme.primaryColor,
                                  ))),
                            );
                          });

                      if (content != '') {
                        // if (journalProvider.userModel == null) {
                        //   journalProvider.getUserModel();
                        // }
                        imagesUrls = await FirestorageHelper.firestorageHelper
                            .uploadImage(journalProvider.files,
                                journalProvider.userModel!.id);
                        journalProvider.addJournal(
                            journal: JournalModel(
                                location: Constants.mylocation,
                                id: DateTime.now().toString(),
                                content: content,
                                date: date,
                                imagesUrls: imagesUrls,
                                isLocked: false,
                                status: status));
                      }
                      AppRouter.router.pop();
                      AppRouter.router
                          .pushWithReplacementFunction(JournalHomeScreen());
                    },
                    icon: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white, //TODO: COLOR
                    )),
              ),
            ]),
        body: Container(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: WritingPlaceWidget(
            onChanged: (value) {
              content = value;
            },
            contentText: content != '' ? content : null,
            hintText: 'What happened with you today?',
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          initialOpen: true,
          children: [
            FloatingActionButton(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              heroTag: 'btn1',
              backgroundColor: Colors.white,
              child: journalProvider.files.isEmpty
                  ? svgGallery
                  : SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        journalProvider.files[0],
                        fit: BoxFit.cover,
                      ),
                    ),
              onPressed: () async {
                if (journalProvider.files.isEmpty) {
                  List<File> images =
                      await FirestorageHelper.firestorageHelper.selectFile();
                  // files.addAll(images);
                  journalProvider.addFile(images);
                  setState(() {});
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        // List<Widget> images = journalProvider.files
                        //     .map((file) => Image.file(file, fit: BoxFit.cover))
                        //     .toList();

                        return PickImageWidget(
                            images: journalProvider.images,
                            onRemovePressed: (index) {
                              journalProvider.images.removeAt(index);
                              journalProvider.files.removeAt(index);
                            },
                            onAddImagePressed: (files) {
                              journalProvider.addFile(files);
                              print('added');
                            },
                            onDonePressed: (files) {
                              AppRouter.router.pop();
                              setState(() {});
                            });
                      });
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       List<Widget> images = files
                  //           .map((file) => Image.file(file, fit: BoxFit.cover))
                  //           .toList();

                  //       return PickImageWidget(
                  //           images: images,
                  //           onAddImagePressed: (images) {},
                  //           onRemovePressed: (index) {
                  //             images.removeAt(index);
                  //             setState(() {});
                  //           },
                  //           onDonePressed: (files) {
                  //             this.files.addAll(files);
                  //             setState(() {});
                  //             AppRouter.router.pop();
                  //           });
                  //       //  ImageViewerWidget(
                  //       //   onDoneTap: (files) {
                  //       //     if (files.isEmpty) {
                  //       //       setState(() {});
                  //       //     }
                  //       //     AppRouter.router.pop();
                  //       //   },
                  //       //   pickedImages: files,
                  //       //   // onAddTap: (files) async {
                  //       //   //   this.files = files;
                  //       //   //   setState(() {});
                  //       //   // }
                  //       // );
                  //     });
                }
                // File file =
                //     await FirestorageHelper.firestorageHelper.selectFile();
                // imageUrl = await FirestorageHelper.firestorageHelper
                //     .uploadImage(file, journalProvider.userModel!.id);
              },
            ),
            FloatingActionButton(
              heroTag: 'btn2',
              backgroundColor: Colors.white,
              child: svgMap,
              onPressed: () {},
            ),
            FloatingActionButton(
              heroTag: 'btn3',
              backgroundColor: Colors.white,
              child: svgWeather,
              onPressed: () {},
            ),
            FloatingActionButton(
              heroTag: 'btn4',
              backgroundColor: Colors.white,
              child: svgSmile,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            buildStatusWidget(
                                widget: svgHappy,
                                onTap: () {
                                  status = Constants.happy;
                                }),
                            buildStatusWidget(
                                widget: svgNormal,
                                onTap: () {
                                  status = Constants.normal;
                                }),
                            buildStatusWidget(
                                widget: svgAngry,
                                onTap: () {
                                  status = Constants.angry;
                                }),
                            buildStatusWidget(
                                widget: svgSad,
                                onTap: () {
                                  status = Constants.sad;
                                })
                          ]));
                    });
              },
            ),
          ],
        ),
        // floatingActionButton: ExpandableFab(
        //   children: [
        //     ActionButton(
        //       onPressed: () {
        //         print('gallary pressed!');
        //       },
        //       icon: svgGallery,
        //     ),
        //     ActionButton(
        //       onPressed: () {
        //         print('map pressed!');
        //       },
        //       icon: svgMap,
        //     ),
        //     ActionButton(
        //       onPressed: () {
        //         print('weather pressed!');
        //       },
        //       icon: svgWeather,
        //     ),
        //     ActionButton(
        //       onPressed: () {
        //         print('smile pressed!');
        //       },
        //       icon: svgSmile,
        //     ),
        //   ],
        // ),
      );
    });
  }

  buildStatusWidget({required Widget widget, required Function() onTap}) {
    return Expanded(
        child: InkWell(
            onTap: () {
              onTap();
              AppRouter.router.pop();
            },
            child: SizedBox(width: 30.w, height: 30.h, child: widget)));
  }
}

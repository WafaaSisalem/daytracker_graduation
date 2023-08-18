import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_tracker_graduation/Screens/journals/journal_display_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/image_viewer_widget.dart';
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

class JournalEditScreen extends StatefulWidget {
  const JournalEditScreen({Key? key, required this.journal}) : super(key: key);
  final JournalModel journal;
  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  String content = '';
  List<dynamic> imagesUrls = [];
  DateTime date = DateTime.now();
  String status = Constants.normal;

  get newJournal {
    return JournalModel(
        id: widget.journal.id,
        content: content,
        date: date,
        isLocked: widget.journal.isLocked,
        location: Constants.mylocation,
        imagesUrls: imagesUrls,
        status: status);
  }

  @override
  void initState() {
    super.initState();
    content = widget.journal.content;
    status = widget.journal.status;
    imagesUrls = widget.journal.imagesUrls;
    date = widget.journal.date;
  }

  List<File> files = [];
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
                  if (widget.journal.isEqual(newJournal) && files.isEmpty) {
                    AppRouter.router
                        .pushWithReplacementFunction(JournalDisplayScreen(
                      journal: widget.journal,
                    ));
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
                                    const JournalHomeScreen());
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
                    date = val ?? widget.journal.date;
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
                      if (widget.journal.isEqual(newJournal) && files.isEmpty) {
                        //No changes happend
                        print('no changes');
                      } else if (content == '') {
                        print('delete journal');
                        journalProvider.deleteJournal(
                            journalId: widget.journal.id);
                      } else {
                        print('changes happend');
                        journalProvider.deleteJournal(
                            journalId: widget.journal.id);
                        if (files.isNotEmpty) {
                          imagesUrls.addAll(await FirestorageHelper
                              .firestorageHelper
                              .uploadImage(
                                  files, journalProvider.userModel!.id));
                        }
                        journalProvider.addJournal(journal: newJournal);
                      }
                      AppRouter.router.pushWithReplacementFunction(
                          const JournalHomeScreen());
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
            contentText: content,
            hintText: 'What happened with you today?',
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          initialOpen: true,
          children: [
            FloatingActionButton(
              clipBehavior: Clip.antiAlias,
              heroTag: 'btn1',
              backgroundColor: Colors.white,
              child: imagesUrls.isEmpty
                  ? svgGallery
                  : SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imagesUrls[0],
                        placeholder: (context, url) => Container(
                          color: Colors.black12,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
              onPressed: () async {
                if (imagesUrls.isEmpty) {
                  List<File> images =
                      await FirestorageHelper.firestorageHelper.selectFile();
                  files.addAll(images);

                  setState(() {});
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        List<Widget> urlImages = imagesUrls
                            .map((url) => CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  imageUrl: url,
                                  placeholder: (context, url) => Container(
                                    color: Colors.black12,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ))
                            .toList();
                        List<Widget> fileImages = files
                            .map((file) => Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ))
                            .toList();
                        urlImages.addAll(fileImages);

                        return ImageViewerWidget(
                            images:
                                urlImages, //we added fileimages to urlimages
                            onDonePressed: (files) {
                              this.files = files;
                              AppRouter.router.pop();
                            });
                        // ImageViewerWidget(
                        //     onDoneTap: (files) {
                        //       print('done pressed');
                        //       if (imagesUrls.isEmpty) {
                        //         setState(() {});
                        //       }
                        //       this.files.addAll(files);

                        //       AppRouter.router.pop();
                        //     },
                        //     pickedImages: [
                        //       ...imagesUrls.map((url) => File(url)).toList(),
                        //       ...files
                        //     ],
                        //     imagesUrls: imagesUrls);
                      });
                }
                // files = await FirestorageHelper.firestorageHelper.selectFile();
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

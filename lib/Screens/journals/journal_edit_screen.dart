import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_tracker_graduation/Screens/journals/journal_display_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/pick_image_widget.dart';
import 'package:day_tracker_graduation/models/journal_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/services/firestorage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

bool isLoading = false;

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
  List<File> pickedFiles = [];
  get newJournal {
    return JournalModel(
        id: widget.journal.id,
        content: content,
        date: date,
        isLocked: widget.journal.isLocked,
        location: widget.journal.location, //Todo
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<JournalProvider>(context, listen: false)
          .setUrlImages(imagesUrls);
    });
  }

  late AuthProvider authProvider;
  late JournalProvider journalProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer2<JournalProvider, AuthProvider>(
        builder: (context, journalProvider, authProvider, child) {
      this.authProvider = authProvider;
      this.journalProvider = journalProvider;

      return Stack(
        children: [
          Scaffold(
            appBar: buildAppbar(context, theme),
            body: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: buildTextfield(),
            ),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: buildExpandableFAB(context),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Overlay color
              alignment: Alignment.center,
              child:
                  const CircularProgressIndicator(), // Your loading indicator
            )
        ],
      );
    });
  }

  ExpandableFab buildExpandableFAB(BuildContext context) {
    return ExpandableFab(
      initialOpen: true,
      children: [
        buildGalleryBtn(context),
        buildMapBtn(),
        buildWeatherBtn(),
        buildStatusBtn(context),
      ],
    );
  }

  FloatingActionButton buildStatusBtn(BuildContext context) {
    return FloatingActionButton(
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
    );
  }

  FloatingActionButton buildWeatherBtn() {
    return FloatingActionButton(
      heroTag: 'btn3',
      backgroundColor: Colors.white,
      child: svgWeather,
      onPressed: () {},
    );
  }

  FloatingActionButton buildMapBtn() {
    return FloatingActionButton(
      heroTag: 'btn2',
      backgroundColor: Colors.white,
      child: svgMap,
      onPressed: () {},
    );
  }

  FloatingActionButton buildGalleryBtn(BuildContext context) {
    return FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        heroTag: 'btn1',
        backgroundColor: Colors.white,
        child: journalProvider.pickedImages.isEmpty
            ? svgGallery
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: journalProvider.pickedImages[0]),
        onPressed: () {
          onGalleryBtnPressed();
        });
  }

  WritingPlaceWidget buildTextfield() {
    return WritingPlaceWidget(
      onChanged: (value) {
        content = value;
      },
      controller: TextEditingController(text: content),
      hintText: 'What happened with you today?',
    );
  }

  AppbarWidget buildAppbar(
    BuildContext context,
    ThemeData theme,
  ) {
    return AppbarWidget(
        titlePlace: Row(children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 28,
              color: Colors.white, //
            ),
            onPressed: () => onBackButtonPressed(),
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
                onPressed: () {
                  onCheckPressed();
                },
                icon: const Icon(
                  Icons.check_rounded,
                  size: 28,
                  color: Colors.white, //
                )),
          ),
        ]);
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

  onGalleryBtnPressed() async {
    if (journalProvider.pickedImages.isEmpty) {
      List<File> files = await journalProvider
          .selectFiles(); //THIS METHOD ADDS FILES TO pickedImages in provider
      pickedFiles.addAll(files);
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return Consumer<JournalProvider>(
                builder: (context, journalProviderIn, x) {
              return PickImageWidget(
                  images: journalProviderIn.pickedImages,
                  onRemovePressed: (index) {
                    // journalProviderIn.removeImageAt(index);
                    if (journalProviderIn.urlImagesPicker.isEmpty) {
                      pickedFiles.removeAt(index);
                    } else {
                      if (index >= journalProviderIn.urlImagesPicker.length) {
                        pickedFiles.removeAt(
                            journalProviderIn.pickedImages.length -
                                journalProviderIn.urlImagesPicker.length -
                                1);
                      }
                    }
                    print(index);
                    journalProviderIn.removeImageAt(index);
                  },
                  onAddImagePressed: (files) {
                    journalProviderIn.addImages(files);
                    pickedFiles.addAll(files);
                  },
                  onDonePressed: (files) {
                    AppRouter.router.pop();
                  });
            });
          });
    }
  }

  void onCheckPressed() async {
    //journalProvider.deleteJournal(journalId: widget.journal.id); ///////nooooo wayyyy because the images will be deleted
    imagesUrls = journalProvider.urlImagesPicker;
    if (widget.journal == newJournal && pickedFiles.isEmpty) {
      //no changes happend!
    } else if (content == '') {
      journalProvider.deleteJournal(journalId: widget.journal.id);
    } else {
      if (pickedFiles.isNotEmpty) {
        isLoading = true;
        setState(() {});
        List<String> urls = await FirestorageHelper.firestorageHelper
            .uploadImage(pickedFiles, authProvider.userModel!.id);
        isLoading = false;
        setState(() {});
        imagesUrls.addAll(urls);
      }
      if (widget.journal.date == date) {
        date = DateTime.now();
      }

      journalProvider.updateJournal(newJournal);
      await journalProvider.deleteImagesByUrls();
    }
    journalProvider.imagesClear();
    AppRouter.router.pushWithReplacementFunction(const JournalHomeScreen());
  }

  onBackButtonPressed() {
    if (widget.journal == newJournal && pickedFiles.isEmpty) {
      AppRouter.router.pushWithReplacementFunction(JournalDisplayScreen(
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
                  journalProvider.imagesClear();

                  AppRouter.router
                      .pushWithReplacementFunction(const JournalHomeScreen());
                });
          });
    }
  }
}

import 'package:day_tracker_graduation/Screens/journals/journal_search_screen.dart.dart';
import 'package:day_tracker_graduation/Screens/journals/tabs/gallery_tab.dart';
import 'package:day_tracker_graduation/Screens/journals/tabs/journal_calendar_tab.dart';
import 'package:day_tracker_graduation/Screens/journals/tabs/journal_tab.dart';
import 'package:day_tracker_graduation/Screens/journals/tabs/location_tab.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../models/journal_model.dart';
import '../../models/tab_model.dart';
import '../../router/app_router.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/bottombar_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/no_entries_widget.dart';
import '../../utils/svgs/svgs.dart';
import '../choose_screen.dart';
import 'journal_add_screen.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({Key? key}) : super(key: key);

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  int currentIndex = 0;
  String nameText = '';
  String password = '';
  List<JournalModel> journals = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // const String assetsImages = 'assets/images/';
    return Consumer<JournalProvider>(builder: (context, journalProvider, x) {
      journals = journalProvider.allJournals;
      List<TabModel> tabs = [
        TabModel(
            content: JournalTab(
              longPressActivated: true,
              journals: journals,
              noEntriesWidget: NoEntriesWidget(
                image: svgNoJournal,
                text: 'No journal entries',
              ),
            ),
            title: 'Home Page',
            iconPath: 'assets/images/all_journal.svg'),
        TabModel(
            content: const JournalCalendarTab(),
            title: 'Calendar',
            iconPath: 'assets/images/calendar.svg'),
        TabModel(
            content: const LocationTab(),
            title: 'Location',
            iconPath: 'assets/images/map.svg'),
        TabModel(
            content: const GalleryTab(),
            title: 'Gallery',
            iconPath: 'assets/images/gallery.svg'),
        TabModel(
            content: const JournalSearchScreen(),
            title: TextField(
              cursorColor: Colors.grey,
              onChanged: (value) {
                journalProvider.search(value);
              },
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintStyle: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: const Color(0x73C4C4C4)), //TODO: color
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Search your memories...',
              ),
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white), //TODO: color
            ),
            iconPath: 'assets/images/map.svg')
      ];

      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarWidget(
            actions: [
              journalProvider.isSelectionMode
                  ? IconButton(
                      icon: svgWhiteDelete,
                      onPressed: () {
                        bool isLockedExist = false;
                        Iterable<int> keys = journalProvider.selectedFlag.keys;
                        for (int key in keys) {
                          if (journalProvider.allJournals[key].isLocked) {
                            isLockedExist = true;
                          }
                        }
                        if (isLockedExist) {
                          showDialog(
                              context: context,
                              builder: (context) => DialogWidget(
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
                                        AppRouter.router.pop();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DialogWidget(
                                                  dialogType: DialogType.delete,
                                                  entryType: 'journal',
                                                  onOkPressed: (value) {
                                                    journalProvider
                                                        .deleteSelectedJournals();
                                                    AppRouter.router.pop();
                                                  });
                                            });
                                      } else {
                                        showToast('Wrong Password!',
                                            context: context,
                                            position: StyledToastPosition.top);
                                      }
                                    }
                                  }));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DialogWidget(
                                    dialogType: DialogType.delete,
                                    entryType: 'journal',
                                    onOkPressed: (value) {
                                      journalProvider.deleteSelectedJournals();
                                      AppRouter.router.pop();
                                    });
                              });
                        }
                      },
                    )
                  : currentIndex != 4
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            AppRouter.router.pushWithReplacementFunction(
                                ChooseCardScreen());
                          },
                          itemBuilder: (BuildContext context) {
                            return {
                              'Back Home',
                            }.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        )
                      : SizedBox(),
              if (currentIndex !=
                  4) //if current index = 4 then we are on search page if not 4
                //then we are not in search page so when its not 4 we have to show the search icon
                // when we press this icon we should set the current index to 4 to be able to hide
                //search icon
                IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = 4;
                      });
                    },
                    icon: const Icon(Icons.search)),
              SizedBox(width: 20.w)
            ],
            titlePlace: Row(
              children: [
                if (currentIndex != 4)
                  SizedBox(
                    width: 20.w,
                  ),
                if (currentIndex == 4)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18.r,
                      color: Colors.white, //TODO: COLOR
                    ),
                    onPressed: () {
                      AppRouter.router.pushWithReplacementFunction(
                        const JournalHomeScreen(),
                      );
                    },
                  ),
                currentIndex == 4
                    ? Expanded(child: tabs[currentIndex].title)
                    : Text(
                        tabs[currentIndex].title,
                        style: theme.textTheme.headline2,
                      ),
              ],
            ),
          ),
          body: tabs[currentIndex].content,
          bottomNavigationBar: currentIndex == 4
              ? null
              : BottomBarWidget(
                  svgs: [
                    tabs[0].iconPath,
                    tabs[1].iconPath,
                    tabs[2].iconPath,
                    tabs[3].iconPath,
                  ],
                  onTap: (index) {
                    currentIndex = index;
                    setState(() {});
                  },
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: currentIndex == 4
              ? null
              : FabWidget(onPressed: () {
                  AppRouter.router
                      .pushWithReplacementFunction(JournalAddScreen());
                }));
    });
  }
}

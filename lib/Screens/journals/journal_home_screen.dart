import 'package:day_tracker_graduation/Screens/journals/tabs/gallary_tab.dart';
import 'package:day_tracker_graduation/Screens/journals/tabs/location_tab.dart';
import 'package:day_tracker_graduation/widgets/notes/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/tab_model.dart';
import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/bottombar_widget.dart';
import '../../widgets/common/dialog_widget.dart';
import '../../widgets/common/fab_widget.dart';
import '../../widgets/common/no_entries_widget.dart';
import '../../widgets/svgs/svgs.dart';
import '../choose_screen.dart';
import '../notes/note_home_screen.dart';
import '../notes/tabs/calendar_tab.dart';
import '../notes/tabs/notes_tab.dart';
import '../notes/tabs/search_tab.dart';
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
  List<TabModel> tabs = [
    TabModel(
        content: NotesTab(
          notes: [],
          noEntriesWidget: NoEntriesWidget(
            image: svgNoJournal,
            text: 'No journal entries',
          ),
        ),
        title: 'Home Page',
        iconPath: 'assets/images/all_journal.svg'),
    TabModel(
        content: CalendarTab(),
        title: 'Calendar',
        iconPath: 'assets/images/calendar.svg'),
    TabModel(
        content: LocationTab(),
        title: 'Location',
        iconPath: 'assets/images/map.svg'),
    TabModel(
        content: GalleryTab(),
        title: 'Gallery',
        iconPath: 'assets/images/gallery.svg'),
    TabModel(
        content: SearchTab(type: HomeScreenType.journal),
        title: AppbarTextFieldWidget(
            onChanged: (value) {},
            hintText: 'Search your memories...',
            text: null,
            autofocus: true),
        iconPath: 'assets/images/map.svg')
  ];
  // List<Map<String, dynamic>> tabs = [
  //   {
  //     'content': NotesTab(
  //       notes: [],
  //       noEntriesWidget: NoEntriesWidget(
  //         image: svgNoJournal,
  //         text: 'No journal entries',
  //       ),
  //     ),
  //     'title': 'Home Page',
  //     'icon': 'assets/images/all_journal.svg'
  //   },
  //   {
  //     'content': CalendarTab(),
  //     'title': 'Calendar',
  //     'icon': 'assets/images/calendar.svg'
  //   },
  //   {
  //     'content': LocationTab(),
  //     'title': 'Location',
  //     'icon': 'assets/images/map.svg'
  //   },
  //   {
  //     'content': GalleryTab(),
  //     'title': 'Gallery',
  //     'icon': 'assets/images/gallery.svg'
  //   },
  //   {
  //     'content': SearchTab(type: HomeScreenType.journal),
  //     'title': AppbarTextField(
  //         onChanged: (value) {},
  //         hintText: 'Search your memories...',
  //         text: null,
  //         autofocus: true),
  //     'icon': 'assets/images/map.svg'
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // const String assetsImages = 'assets/images/';
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppbarWidget(
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                AppRouter.router
                    .pushWithReplacementFunction(ChooseCardScreen());
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
            ),
            if (currentIndex != 4)
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                              dialogType: DialogType.discard,
                              entryType: 'journal',
                              onOkPressed: (value) {
                                AppRouter.router.pop();
                                AppRouter.router.pushWithReplacementFunction(
                                  const JournalHomeScreen(),
                                );
                              });
                        });
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
                  // assetsImages + 'allnote.svg',
                  // assetsImages + 'calendar.svg',
                  // assetsImages + 'search.svg',
                  // assetsImages + 'theme.svg'
                ],
                onTap: (index) {
                  currentIndex = index;
                  setState(() {});
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: currentIndex == 4
            ? null
            : FabWidget(onPressed: () {
                AppRouter.router
                    .pushWithReplacementFunction(JournalAddScreen());
              }));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/note_model.dart';
import '../../models/tab_model.dart';
import '../../provider/note_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/appbar_widget.dart';
import '../../widgets/common/bottombar_widget.dart';
import '../../widgets/common/fab_widget.dart';
import '../../widgets/common/no_entries_widget.dart';
import '../../widgets/notes/appbar_textfield.dart';
import '../../widgets/svgs/svgs.dart';
import '../choose_screen.dart';
import 'package:intl/intl.dart';

import 'note_handling_screen.dart';
import 'tabs/calendar_tab.dart';
import 'tabs/notes_tab.dart';
import 'tabs/search_tab.dart';
import 'tabs/settings_tab.dart';

enum HomeScreenType { note, journal, pomo, task }

class NoteHomeScreen extends StatefulWidget {
  const NoteHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NoteHomeScreen> createState() => _NoteHomeScreenState();
}

class _NoteHomeScreenState extends State<NoteHomeScreen> {
  int currentIndex = 0;
  String nameText = '';
  String password = '';
  List<NoteModel> notes = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // const String assetsImages = 'assets/images/';
    return Consumer<NoteProvider>(builder: (context, noteProvider, x) {
      notes = noteProvider.allNotes;
      List<TabModel> tabs = [
        TabModel(
            content: NotesTab(
              notes: notes,
              noEntriesWidget: NoEntriesWidget(
                image: svgNoNote,
                text: 'No notes entries',
              ),
            ),
            title: 'Home Page',
            iconPath: 'assets/images/allnote.svg'),
        TabModel(
            content: CalendarTab(),
            title: 'Calendar',
            iconPath: 'assets/images/calendar.svg'),
        TabModel(
            content: SearchTab(
              type: HomeScreenType.note,
            ),
            title: AppbarTextFieldWidget(
                onChanged: (value) {},
                hintText: 'Search your notes...',
                text: null,
                autofocus: true),
            iconPath: 'assets/images/search.svg'),
        TabModel(
            content: SettingsTab(),
            title: 'View Settings',
            iconPath: 'assets/images/theme.svg')
      ];
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
              // IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ],
            titlePlace: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                currentIndex == 2
                    ? tabs[2].title
                    : Text(
                        tabs[currentIndex].title,
                        style: theme.textTheme.headline2,
                      ),
              ],
            ),
          ),
          body: tabs[currentIndex].content,
          bottomNavigationBar: BottomBarWidget(
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FabWidget(onPressed: () {
            AppRouter.router.pushWithReplacementFunction(
                NoteHandlingScreen(type: NoteHandlingType.add));
          }));
    });
  }
}

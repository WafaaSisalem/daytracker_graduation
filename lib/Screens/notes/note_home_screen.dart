import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/widgets/back_home_widget.dart';
import 'package:day_tracker_graduation/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../models/note_model.dart';
import '../../models/tab_model.dart';
import '../../provider/note_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/bottombar_widget.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/no_entries_widget.dart';
import '../../utils/svgs/svgs.dart';

import 'note_handling_screen.dart';
import 'tabs/note_calendar_tab.dart';
import 'tabs/notes_tab.dart';
import 'tabs/note_search_tab.dart';
import 'tabs/settings_tab.dart';

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
  late NoteProvider noteProvider;
  late AuthProvider authProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // const String assetsImages = 'assets/images/';
    return Consumer2<NoteProvider, AuthProvider>(
        builder: (context, noteProvider, authProvider, x) {
      this.noteProvider = noteProvider;
      this.authProvider = authProvider;
      notes = noteProvider.allNotes;
      List<TabModel> tabs = [
        buildTabOne(),
        buildTabTwo(),
        buildTabThree(),
        buildTabFour()
      ];
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarWidget(
            actions: [
              noteProvider.isSelectionMode
                  ? onSelectionModeWidget()
                  : const BackHomeMenuWidget(),
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
            ],
            onTap: (index) {
              currentIndex = index;
              if (currentIndex == 2) {
                noteProvider.searchResult.clear();
              }
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

  TabModel buildTabFour() {
    return TabModel(
        content: SettingsTab(),
        title: 'View Settings',
        iconPath: 'assets/images/theme.svg');
  }

  TabModel buildTabThree() {
    return TabModel(
        content: const NoteSearchTab(),
        title: SizedBox(
          width: 200.w,
          child: TextField(
            cursorColor: Colors.grey,
            onChanged: (value) {
              noteProvider.search(value);
            },
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintStyle: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: const Color(0x73C4C4C4)), //
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: 'Search your notes...',
            ),
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.white), //
          ),
        ),
        iconPath: 'assets/images/search.svg');
  }

  TabModel buildTabTwo() {
    return TabModel(
        content: const NoteCalendarTab(),
        title: 'Calendar',
        iconPath: 'assets/images/calendar.svg');
  }

  TabModel buildTabOne() {
    return TabModel(
        content: NotesTab(
          longPressActivated: true,
          notes: notes,
          noEntriesWidget: NoEntriesWidget(
            image: svgNoNote,
            text: 'No notes entries',
          ),
        ),
        title: 'Home Page',
        iconPath: 'assets/images/allnote.svg');
  }

  IconButton onSelectionModeWidget() {
    return IconButton(
      icon: SizedBox(
        width: 18,
        height: 18,
        child: svgWhiteDelete,
      ),
      onPressed: () {
        bool isLockedExist = false;

        Iterable<int> keys = noteProvider.selectedFlag.keys;

        for (int key in keys) {
          if (noteProvider.selectedFlag[key] == true) {
            if (noteProvider.allNotes[key].isLocked) {
              isLockedExist = true;
            }
          }
        }
        if (isLockedExist) {
          showDialog(
              context: context,
              builder: (context) => DialogWidget(
                  dialogType: DialogType.password,
                  entryType: 'note',
                  onOkPressed: (value) {
                    if (value.isEmpty) {
                      showToast('Password can not be empty!', context: context);
                    } else {
                      if (authProvider.userModel!.masterPassword == value) {
                        AppRouter.router.pop();
                        deleteDialog();
                      } else {
                        showToast('Wrong Password!',
                            context: context,
                            position: StyledToastPosition.top);
                      }
                    }
                  }));
        } else {
          deleteDialog();
        }
      },
    );
  }

  Future<dynamic> deleteDialog() {
    return showDialog(
        context: context,
        builder: (ctx) {
          return DialogWidget(
              dialogType: DialogType.delete,
              entryType: 'note',
              onOkPressed: (value) {
                noteProvider.deleteSelectedNotes();
                AppRouter.router.pop();
              });
        });
  }
}

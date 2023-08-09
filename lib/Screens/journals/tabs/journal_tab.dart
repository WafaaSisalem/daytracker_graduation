import 'dart:async';

import 'package:day_tracker_graduation/Screens/master_password_screen.dart';
import 'package:day_tracker_graduation/helpers/shared_preference_helper.dart';
import 'package:day_tracker_graduation/models/user_model.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/provider/note_provider.dart';
import 'package:day_tracker_graduation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../../models/journal_model.dart';
import '../../../models/note_model.dart';
import '../../../router/app_router.dart';
import '../../../widgets/dialog_widget.dart';
import '../widgets/journal_widget.dart';
import '../../notes/widgets/note_widget.dart';

class JournalTab extends StatefulWidget {
  JournalTab(
      {Key? key,
      required this.noEntriesWidget,
      required this.journals,
      required this.longPressActivated})
      : super(key: key);
  final Widget noEntriesWidget;
  final List<JournalModel> journals;
  final bool longPressActivated;

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (builder, journalProvider, x) {
      return widget.journals.isNotEmpty
          ? journalWidget(journalProvider)
          : Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : widget.noEntriesWidget,
            );
    });
  }

  JournalWidget buildItem(
      {required context,
      required int index,
      required JournalProvider journalProvider}) {
    journalProvider.selectedFlag[index] =
        journalProvider.selectedFlag[index] ?? false;
    bool isSelected = journalProvider.selectedFlag[index]!;

    return JournalWidget(
      isSelected: isSelected,
      isSelectionMode: journalProvider.isSelectionMode,
      onLongPress: () {
        if (widget.longPressActivated) {
          onLongPress(isSelected, index, journalProvider);
        }
      },
      journal: widget.journals[index],
      onJournalTap: () {
        onTap(isSelected, index, journalProvider);
      },
      onPasswordIconTap: () {
        if (journalProvider.userModel!.masterPassword.isEmpty) {
          AppRouter.router.pushNamedFunction(
              MasterPassScreen.routeName, [widget.journals[index]]);
        } else {
          showDialog(
              context: context,
              builder: (context) => DialogWidget(
                  dialogType: DialogType.password,
                  entryType: 'journal',
                  onOkPressed: (value) {
                    if (value.isEmpty) {
                      showToast('Password can not be empty!', context: context);
                    } else {
                      if (journalProvider.userModel!.masterPassword == value) {
                        if (widget.journals[index].isLocked) {
                          journalProvider.updateJournal(JournalModel.fromMap({
                            ...widget.journals[index].toMap(),
                            Constants.isLockedKey: 0,
                          }));
                        } else {
                          journalProvider.updateJournal(JournalModel.fromMap({
                            ...widget.journals[index].toMap(),
                            Constants.isLockedKey: 1,
                          }));
                        }
                        AppRouter.router.pop();
                      } else {
                        showToast('Wrong Password!',
                            context: context,
                            position: StyledToastPosition.top);
                      }
                    }
                  }));
          print('password idonc');
        }
      },
      onDeleteIconTap: () {
        if (widget.journals[index].isLocked) {
          showDialog(
              context: context,
              builder: (context) => DialogWidget(
                  dialogType: DialogType.password,
                  entryType: 'journal',
                  onOkPressed: (value) {
                    if (value.isEmpty) {
                      showToast('Password can not be empty!', context: context);
                    } else {
                      if (journalProvider.userModel!.masterPassword == value) {
                        AppRouter.router.pop();
                        showDialog(
                            context: context,
                            builder: (context) => DialogWidget(
                                dialogType: DialogType.delete,
                                entryType: 'journal',
                                onOkPressed: (value) {
                                  print(widget.journals[index].id);
                                  journalProvider.deleteJournal(
                                      journalId: widget.journals[index].id);
                                  AppRouter.router.pop();
                                }));
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
              builder: (context) => DialogWidget(
                  dialogType: DialogType.delete,
                  entryType: 'journal',
                  onOkPressed: (value) {
                    print(widget.journals[index].id);
                    journalProvider.deleteJournal(
                        journalId: widget.journals[index].id);
                    AppRouter.router.pop();
                  }));
        }
      },
    );
  }

  Container journalWidget(JournalProvider journalProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return buildItem(
              index: index, context: context, journalProvider: journalProvider);
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 15.h,
        ),
        itemCount: widget.journals.length,
      ),
    );
  }

  void onLongPress(
      bool isSelected, int index, JournalProvider journalProvider) {
    setState(() {
      journalProvider.selectedFlag[index] = !isSelected;
      journalProvider.setSelectionMode();
    });
  }

  void onTap(bool isSelected, int index, JournalProvider journalProvider) {
    if (journalProvider.isSelectionMode) {
      setState(() {
        journalProvider.selectedFlag[index] = !isSelected;
        journalProvider.setSelectionMode();
      });
    } else {
      if (widget.journals[index].isLocked) {
        showDialog(
            context: context,
            builder: (context) => DialogWidget(
                dialogType: DialogType.password,
                entryType: 'journal',
                onOkPressed: (value) {
                  if (value.isEmpty) {
                    showToast('Password can not be empty!', context: context);
                  } else {
                    if (journalProvider.userModel!.masterPassword == value) {
                      AppRouter.router.pop();
                    } else {
                      showToast('Wrong Password!',
                          context: context, position: StyledToastPosition.top);
                    }
                  }
                }));
      } else {
        // AppRouter.router.pushWithReplacementFunction(NoteHandlingScreen(
        //   type: NoteHandlingType.display,
        //   note: widget.notes[index],
        // ));
      }
    }
  }
}

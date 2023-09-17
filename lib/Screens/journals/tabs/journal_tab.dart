import 'dart:async';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../../models/journal_model.dart';
import '../../../router/app_router.dart';
import '../../../widgets/dialog_widget.dart';
import '../journal_display_screen.dart';
import '../widgets/journal_widget.dart';

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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
  // late AuthProvider authProvider;
  // late JournalProvider journalProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer2<JournalProvider, AuthProvider>(
        builder: (builder, journalProvider, authProvider, x) {
      return widget.journals.isNotEmpty
          ? buildList(journalProvider, authProvider)
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
      required JournalProvider journalProvider,
      required AuthProvider authProvider}) {
    // journalProvider.selectedFlag[index] =
    //     journalProvider.selectedFlag[index] ?? false;
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
        onTap(isSelected, index, journalProvider, authProvider);
      },
    );
  }

  Container buildList(
      JournalProvider journalProvider, AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return buildItem(
              index: index,
              context: context,
              journalProvider: journalProvider,
              authProvider: authProvider);
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

  void onTap(bool isSelected, int index, JournalProvider journalProvider,
      AuthProvider authProvider) {
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
                    if (authProvider.userModel!.masterPassword == value) {
                      AppRouter.router.pop();
                      AppRouter.router
                          .pushWithReplacementFunction(JournalDisplayScreen(
                        journal: widget.journals[index],
                      ));
                    } else {
                      showToast('Wrong Password!',
                          context: context, position: StyledToastPosition.top);
                    }
                  }
                }));
      } else {
        AppRouter.router.pushWithReplacementFunction(JournalDisplayScreen(
          journal: widget.journals[index],
        ));
      }
    }
  }
}

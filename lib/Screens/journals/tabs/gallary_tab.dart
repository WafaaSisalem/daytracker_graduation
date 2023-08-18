import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_tracker_graduation/Screens/journals/image_slider_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/image_viewer_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/journal_display_screen.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../router/app_router.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (context, journalProvider, x) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
        child: GridView.builder(
            // padding: EdgeInsets.symmetric(horizontal: 36.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: journalProvider.allImagesUrls.length,
            itemBuilder: (context, index) {
              String journalId =
                  journalProvider.allImagesUrls[index].keys.first;
              return GestureDetector(
                onTap: () => AppRouter.router.pushWithReplacementFunction(
                  JournalDisplayScreen(
                      journal: journalProvider.getJournalById(journalId)),
                ),
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: const Color(0x28000000), //TODO: COLOR
                          offset: Offset(0, 1.h),
                          blurRadius: 3),
                    ], borderRadius: BorderRadius.circular(5.r)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          journalProvider.allImagesUrls[index].values.first,
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              );
            }),
      );
    });
  }
}

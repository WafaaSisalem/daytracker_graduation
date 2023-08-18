import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../models/journal_model.dart';
import '../../router/app_router.dart';

class ImageSliderViewerScreen extends StatelessWidget {
  const ImageSliderViewerScreen(
      {super.key, required this.journal, required this.currentImageIndex});
  final JournalModel journal;
  final int currentImageIndex;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (details) => AppRouter.router.pop(),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        AppRouter.router.pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )),
              Expanded(
                child: ImageSlideshow(
                  initialPage: currentImageIndex,
                  indicatorColor: Colors.white,
                  indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
                  children: journal.imagesUrls
                      .map((imageUrl) => Hero(
                            tag: journal.id,
                            child: CachedNetworkImage(
                              fit: BoxFit.fitWidth,
                              imageUrl: imageUrl,
                              placeholder: (context, url) => Container(
                                color: Colors.black12,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            // child: Image.network(
                            //   imageUrl,
                            //   fit: BoxFit.cover,
                            // ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../router/app_router.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen(
      {super.key, required this.imageUrl, required this.id});
  final String imageUrl;
  final String id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: imageUrl,
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              // child: Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              // ),
            )),
          ],
        ),
      ),
    );
  }
}

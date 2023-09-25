import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/svgs/svgs.dart';

class PickImageWidget extends StatefulWidget {
  const PickImageWidget(
      {super.key,
      required this.images,
      required this.onRemovePressed,
      required this.onAddImagePressed,
      required this.onDonePressed});
  final List<Widget> images;
  final Function(List<File>) onAddImagePressed;
  final Function(List<File>) onDonePressed;
  final Function(int) onRemovePressed;

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  List<File> files = [];
  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Images'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: widget.images.length + 1, // Add 1 for the "+" button
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      files = await selectFiles();

                      widget.onAddImagePressed(files);
                      // setState(() {});

                      print(files);
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  final imageIndex = index - 1; // Adjust for the "+" button
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: widget.images[imageIndex]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.onRemovePressed(imageIndex);

                            // widget.onRemovePressed(removeImage(imageIndex));
                            // setState(() {});
                          },
                          child: svgMinus,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onDonePressed(files);
            // setState(() {});
          },
          child: Text(
            'DONE',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }

  selectFiles() async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile>? imageFileList = [];

    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 25);
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    files = imageFileList.map((file) => File(file.path)).toList();
    return files;
  }
}
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:day_tracker_graduation/utils/svgs/svgs.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import '../../../services/firestorage_helper.dart';

// class ImageViewerWidget extends StatefulWidget {
//   ImageViewerWidget(
//       {super.key,
//       required this.pickedImages,
//       this.imagesUrls = const [],
//       // required this.onAddTap,
//       required this.onDoneTap});
//   final List<File> pickedImages;
//   // final Function(List<File>) onAddTap;
//   final Function(List<File>) onDoneTap;
//   List<dynamic> imagesUrls;
//   @override
//   State<ImageViewerWidget> createState() => _ImageViewerWidgetState();
// }

// class _ImageViewerWidgetState extends State<ImageViewerWidget> {
//   void _removeImage(int index) {
//     setState(() {
//       widget.imagesUrls.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Images'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: 400,
//             height: 300,
//             child: GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 5,
//               ),
//               itemCount:
//                   widget.pickedImages.length + 1, // Add 1 for the "+" button
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return GestureDetector(
//                     onTap: () async {
//                       List<File> images = await FirestorageHelper
//                           .firestorageHelper
//                           .selectFile();
//                       widget.pickedImages.addAll(images);

//                       // widget.onAddTap(widget.pickedImages);
//                       setState(() {});
//                     },
//                     child: Container(
//                       color: Theme.of(context).primaryColor,
//                       child: const Center(
//                         child: Icon(
//                           Icons.add_rounded,
//                           size: 48.0,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   final imageIndex = index - 1; // Adjust for the "+" button
//                   return Stack(
//                     alignment: Alignment.topLeft,
//                     children: [
//                       SizedBox(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: widget.pickedImages[imageIndex].path
//                                   .startsWith('https:')
//                               ? CachedNetworkImage(
//                                   fit: BoxFit.fitWidth,
//                                   imageUrl:
//                                       widget.pickedImages[imageIndex].path,
//                                   placeholder: (context, url) => Container(
//                                     color: Colors.black12,
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                 )
//                               : Image.file(
//                                   widget.pickedImages[imageIndex],
//                                   fit: BoxFit.cover,
//                                 )),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: GestureDetector(
//                           onTap: () => _removeImage(imageIndex),
//                           child: svgMinus,
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             // Process the selected images or save them to storage
//             List<File> files = widget.pickedImages
//                 .where((file) => !file.path.startsWith('https:'))
//                 .toList();
//             print('files' + files.toString());
//             widget.onDoneTap(files);
//           },
//           child: Text(
//             'DONE',
//             style: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//       ],
//     );
//   }
// }

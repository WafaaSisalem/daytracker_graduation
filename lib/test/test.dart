// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Picker App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker App'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => ImagePickerAlertDialog(),
//             );
//           },
//           child: Text('Open Image Picker'),
//         ),
//       ),
//     );
//   }
// }

// class ImagePickerAlertDialog extends StatefulWidget {
//   @override
//   _ImagePickerAlertDialogState createState() => _ImagePickerAlertDialogState();
// }

// class _ImagePickerAlertDialogState extends State<ImagePickerAlertDialog> {
//   List<XFile> _pickedImages = [];

//   Future<void> _pickImages() async {
//     List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _pickedImages = pickedFiles;
//       });
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _pickedImages.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Images'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ElevatedButton(
//             onPressed: _pickImages,
//             child: Text('Pick Images'),
//           ),
//           Container(
//             width: 200,
//             height: 200,
//             child: GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 10.0,
//                 crossAxisSpacing: 10.0,
//               ),
//               itemCount: _pickedImages.length,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   alignment: Alignment.topLeft,
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       child: Image.file(
//                         File(_pickedImages[index].path),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => _removeImage(index),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the AlertDialog
//           },
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Process the selected images or save them to storage
//             Navigator.of(context).pop();
//           },
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ImagePickerAlertDialog(),
            );
          },
          child: Text('Open Image Picker'),
        ),
      ),
    );
  }
}

class ImagePickerAlertDialog extends StatefulWidget {
  @override
  _ImagePickerAlertDialogState createState() => _ImagePickerAlertDialogState();
}

class _ImagePickerAlertDialogState extends State<ImagePickerAlertDialog> {
  List<XFile> _pickedImages = [];

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _pickedImages = pickedFiles;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Images'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            height: 200,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: _pickedImages.length + 1, // Add 1 for the "+" button
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 48.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                } else {
                  final imageIndex = index - 1; // Adjust for the "+" button
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                          width: 200,
                          height: 200,
                          child: Image.file(
                            File(_pickedImages[imageIndex].path),
                            fit: BoxFit.cover,
                          )),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _removeImage(imageIndex),
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
            Navigator.of(context).pop(); // Close the AlertDialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Process the selected images or save them to storage
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
          ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:day_tracker_graduation/Screens/journals/map_screen.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/pick_image_widget.dart';
import 'package:day_tracker_graduation/Screens/journals/widgets/status_widget.dart';
import 'package:day_tracker_graduation/models/journal_model.dart';
import 'package:day_tracker_graduation/models/location_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/services/firestorage_helper.dart';
import 'package:day_tracker_graduation/widgets/fab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/svgs/svgs.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/floating_calendar.dart';
import '../notes/widgets/writing_place.dart';
import 'journal_home_screen.dart';

bool isLoading = false;

class JournalAddScreen extends StatefulWidget {
  const JournalAddScreen({Key? key}) : super(key: key);

  @override
  State<JournalAddScreen> createState() => _JournalAddScreenState();
}

class _JournalAddScreenState extends State<JournalAddScreen> {
  DateTime date = DateTime.now();
  String content = '';
  String status = '';
  List<String> imagesUrls = [];
  LocationModel? location;
  loc.LocationData? currentLocation;
  double? celsius;
  String formatedCelsius = '';
  List<File> pickedFiles = [];
  getCurrentWeather() async {
    WeatherFactory wf = WeatherFactory("3117871fcf5c5c7027946e61b433701e");
    if (currentLocation != null ||
        (currentLocation?.latitude != 0.0 &&
            currentLocation?.longitude != 0.0)) {
      double lat = currentLocation!.latitude!;
      double lng = currentLocation!.longitude!;
      Weather w = await wf.currentWeatherByLocation(lat, lng);
      celsius = w.temperature?.celsius;
      formatedCelsius = '${w.temperature?.celsius?.round()}\u2103';
      setState(() {});
      print(formatedCelsius);
    }
  }

  bool isLocationServiceEnabled = false;

  Future<void> checkLocationService() async {
    var location = loc.Location();
    isLocationServiceEnabled = await location.serviceEnabled();
    if (!isLocationServiceEnabled) {
      isLocationServiceEnabled = await location.requestService();
      if (!isLocationServiceEnabled) {
        // Location service is still not enabled, handle accordingly
        isGettingAddress = false;
        setState(() {});
      }
    }
  }

  Future<String> getAddress(lat, lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        String? subLocality =
            placemark.subLocality == '' ? '' : "${placemark.subLocality},";
        String? thoroughfare =
            placemark.thoroughfare == '' ? '' : "${placemark.thoroughfare},";
        String? subThoroughfare = placemark.subThoroughfare == ''
            ? ''
            : "${placemark.subThoroughfare},";
        String? postalCode =
            placemark.postalCode == '' ? '' : "${placemark.postalCode},";
        String? subAdministrativeArea = placemark.subAdministrativeArea == ''
            ? ''
            : "${placemark.subAdministrativeArea},";
        String? administrativeArea = placemark.administrativeArea == ''
            ? ''
            : "${placemark.administrativeArea},";
        String? country = placemark.country == '' ? '' : "${placemark.country}";

        final address =
            '$subLocality $thoroughfare $subThoroughfare $postalCode $subAdministrativeArea $administrativeArea $country';

        return address;
      } else {
        return Constants.addressNotFound;
      }
    } catch (e) {
      print("Error: $e");
      return Constants.errorGettingAddress;
    }
  }

  bool isGettingAddress = false;
  Future<void> getLocation() async {
    var location1 = loc.Location();

    bool serviceEnabled = await location1.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location1.requestService();
      if (!serviceEnabled) {
        return;
      } else {
        await location1.serviceEnabled();
      }
    }

    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        setState(() {
          isGettingAddress = true;
        });
        currentLocation = await location1.getLocation().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            isGettingAddress = false;

            setState(() {});
            showToast('Can\'t catch any location,try Again!',
                context: context, position: StyledToastPosition.top);
            return loc.LocationData.fromMap(
                {'longitude': 0.0, 'latitude': 0.0});
          },
        );

        double lat = currentLocation?.latitude ?? 0.0;
        double lng = currentLocation?.longitude ?? 0.0;
        String address = await getAddress(lat, lng);
        if (address == Constants.addressNotFound ||
            address == Constants.errorGettingAddress) {
        } else {
          location = LocationModel(lat, lng, await getAddress(lat, lng));
        }
        isGettingAddress = false;
        setState(() {});
        if (currentLocation != null) {
          setState(() {});
        }
      } catch (e) {
        print("Error: $e");
      }
    } else if (status.isDenied || status.isRestricted) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        getLocation();
      }
    }
    getCurrentWeather();
  }

  late AuthProvider authProvider;
  late JournalProvider journalProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer2<JournalProvider, AuthProvider>(
        builder: (context, journalProvider, authProvider, child) {
      this.authProvider = authProvider;
      this.journalProvider = journalProvider;
      return Stack(
        children: [
          Scaffold(
            appBar: buildAppbar(context, theme),
            body: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Column(
                children: [
                  buildAddressBox(theme),
                  Expanded(
                    child: buildTextField(),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: buildExpandFAB(theme),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Overlay color
              alignment: Alignment.center,
              child:
                  const CircularProgressIndicator(), // Your loading indicator
            )
        ],
      );
    });
  }

  ExpandableFab buildExpandFAB(ThemeData theme) {
    return ExpandableFab(
      initialOpen: true,
      openButtonBuilder: buildOpenBtn(),
      closeButtonBuilder: buildCloseBtn(),
      children: [
        buildGalleryBtn(),
        buildMapBtn(),
        buildWeatherBtn(theme),
        buildStatusBtn(),
      ],
    );
  }

  FloatingActionButton buildStatusBtn() {
    return FloatingActionButton(
      heroTag: 'btn4',
      backgroundColor: Colors.white,
      child: SizedBox(
          width: 22.w, height: 22.h, child: StatusWidget(status: status)),
      onPressed: () => onStatusBtnPressed(),
    );
  }

  FloatingActionButton buildWeatherBtn(ThemeData theme) {
    return FloatingActionButton(
      heroTag: 'btn3',
      backgroundColor: Colors.white,
      child: formatedCelsius == ''
          ? ColorFiltered(
              child: svgWeather,
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
            )
          : Text(
              formatedCelsius,
              style: theme.textTheme.headline3!
                  .copyWith(color: theme.primaryColor),
            ),
      onPressed: () {},
    );
  }

  FloatingActionButton buildMapBtn() {
    return FloatingActionButton(
      heroTag: 'btn2',
      backgroundColor: Colors.white,
      child: location == null ? svgMap : svgMapDone,
      onPressed: () => onMapBtnPressed(),
    );
  }

  FloatingActionButton buildGalleryBtn() {
    return FloatingActionButton(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      heroTag: 'btn1',
      backgroundColor: Colors.white,
      child: journalProvider
              .pickedImages.isEmpty // journalProvider.filesPicked.isEmpty
          ? svgGallery
          : SizedBox(
              width: double.infinity,
              height: double.infinity,

              child: journalProvider.pickedImages[0],

              // child: Image.file(
              //   journalProvider.filesPicked[0],
              //   fit: BoxFit.cover,
              // ),
            ),
      onPressed: () => onGalleryBtnPressed(),
    );
  }

  FloatingActionButtonBuilder buildCloseBtn() {
    return FloatingActionButtonBuilder(
        builder: (context, onPressed, progress) => FabWidget(
              heroTag: 'close btn',
              onPressed: onPressed!,
              icon: Icons.close_rounded,
            ),
        size: 20); //size does not matter,
  }

  FloatingActionButtonBuilder buildOpenBtn() {
    return FloatingActionButtonBuilder(
        builder: (context, onPressed, progress) => FabWidget(
              onPressed: onPressed!,
              heroTag: 'open btn ',
            ),
        size: 20);
  }

  WritingPlaceWidget buildTextField() {
    return WritingPlaceWidget(
      onChanged: (value) {
        content = value;
      },
      controller: content != ''
          ? TextEditingController(text: content)
          : TextEditingController(text: null),
      hintText: 'What happened with you today?',
    );
  }

  SizedBox buildAddressBox(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 20.h,
      child: isGettingAddress
          ? const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : Text(
              location?.address ?? '',
              style: theme.textTheme.subtitle2!
                  .copyWith(color: theme.colorScheme.secondary),
            ),
    );
  }

  AppbarWidget buildAppbar(BuildContext context, ThemeData theme) {
    return AppbarWidget(
        titlePlace: Row(children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 28,
              color: Colors.white, //
            ),
            onPressed: () {
              onBackButtonPressed();
            },
          ),
          SizedBox(
            width: 70.w,
          ),
          InkWell(
            onTap: () async {
              DateTime dateTime =
                  await floatingCalendarWidget(context, initialDate: date);

              setState(() {
                date = dateTime;
              });
            },
            child: Container(
              height: 23.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM d, y').format(date).toString(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      height: 15.h,
                      width: 1.w,
                      color: Colors.grey[200],
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.secondary,
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () => onCheckPressed(journalProvider, authProvider),
                icon: const Icon(
                  Icons.check_rounded,
                  size: 28,
                  color: Colors.white, //
                )),
          ),
        ]);
  }

  buildStatusWidget({required Widget widget, required Function() onTap}) {
    return Expanded(
        child: InkWell(
            onTap: () {
              onTap();
              AppRouter.router.pop();
            },
            child: SizedBox(width: 30.w, height: 30.h, child: widget)));
  }

  onGalleryBtnPressed() async {
    if (journalProvider.pickedImages.isEmpty) {
      List<File> files = await journalProvider
          .selectFiles(); //THIS METHOD ADDS FILES TO pickedImages in provider
      pickedFiles.addAll(files);
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return Consumer<JournalProvider>(
                builder: (context, journalProviderIn, x) {
              return PickImageWidget(
                  images: journalProviderIn.pickedImages,
                  onRemovePressed: (index) {
                    journalProviderIn.removeImageAt(index);
                    pickedFiles.removeAt(index);
                  },
                  onAddImagePressed: (files) {
                    journalProviderIn.addImages(files);
                    pickedFiles.addAll(files);
                  },
                  onDonePressed: (files) {
                    AppRouter.router.pop();
                  });
            });
          });
    }
  }

  onMapBtnPressed() {
    ThemeData theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'No Location Detected...',
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                    onPressed: () async {
                      AppRouter.router.pop();
                      location = await AppRouter.router
                          .pushFunction(const MapScreen());
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.add_location_alt_rounded,
                      color: theme.primaryColor,
                    ),
                    label: Text(
                      'Pick a Place',
                      style: theme.textTheme.headline4,
                    )),
                TextButton.icon(
                    onPressed: () {
                      getLocation();
                      AppRouter.router.pop();
                    },
                    icon: Icon(
                      Icons.gps_fixed,
                      color: theme.primaryColor,
                    ),
                    label: Text(
                      'Setup GPS',
                      style: theme.textTheme.headline4,
                    )),
                if (location != null)
                  TextButton.icon(
                      onPressed: () {
                        location = null;
                        setState(() {});
                        AppRouter.router.pop();
                      },
                      icon: Icon(
                        Icons.location_off,
                        color: theme.primaryColor,
                      ),
                      label: Text(
                        'Remove Location',
                        style: theme.textTheme.headline4,
                      )),
              ],
            ),
          );
        });
  }

  onStatusBtnPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            buildStatusWidget(
                widget: svgHappy,
                onTap: () {
                  status = Constants.happy;
                  setState(() {});
                }),
            buildStatusWidget(
                widget: svgNormal,
                onTap: () {
                  status = Constants.normal;
                  setState(() {});
                }),
            buildStatusWidget(
                widget: svgAngry,
                onTap: () {
                  status = Constants.angry;
                  setState(() {});
                }),
            buildStatusWidget(
                widget: svgSad,
                onTap: () {
                  status = Constants.sad;
                  setState(() {});
                })
          ]));
        });
  }

  onCheckPressed(
      JournalProvider journalProvider, AuthProvider authProvider) async {
    if (content != '') {
      isLoading = true;
      setState(() {});
      imagesUrls = await FirestorageHelper.firestorageHelper
          .uploadImage(pickedFiles, authProvider.userModel!.id);
      isLoading = false;
      setState(() {});
      journalProvider.addJournal(
          journal: JournalModel(
              location: location,
              id: DateTime.now().toString(),
              content: content,
              date: date,
              imagesUrls: imagesUrls,
              isLocked: false,
              status: status,
              weather: formatedCelsius));
    }
    // else{
    //  if( pickedFiles.isNotEmpty){
    //   showDialog(context: context, builder: (context){
    //       return AlertDialog(content: Text('if you want to add the images, write something on the note'),);
    //   });
    //  }
    // }
    journalProvider.imagesClear();
    pickedFiles.clear();
    AppRouter.router.pushWithReplacementFunction(const JournalHomeScreen());
  }

  void onBackButtonPressed() {
    if (content == '' && pickedFiles.isEmpty) {
      AppRouter.router.pushWithReplacementFunction(const JournalHomeScreen());
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
                dialogType: DialogType.discard,
                entryType: 'journal',
                onOkPressed: (value) {
                  AppRouter.router.pop();
                  journalProvider.imagesClear();
                  AppRouter.router
                      .pushWithReplacementFunction(const JournalHomeScreen());
                });
          });
    }
  }
}

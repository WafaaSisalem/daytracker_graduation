import 'package:day_tracker_graduation/models/location_model.dart';
import 'package:day_tracker_graduation/widgets/appbar_widget.dart';
import 'package:day_tracker_graduation/widgets/fab_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants.dart';
import '../../utils/svgs/svgs.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  GoogleMapController? mapController;
  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(27.6602292, 85.308027));
  LatLng startLocation = const LatLng(27.6602292, 85.308027);
  String formatedAddress = "Location Name:";

  late double lat;
  late double lng;

  Future<String> getAddress() async {
    lat = cameraPosition.target.latitude;
    lng = cameraPosition.target.longitude;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(
            titlePlace: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Pick a Place',
                  style: Theme.of(context).textTheme.headline2,
                )
              ],
            ),
            actions: []),
        body: Stack(children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: startLocation,
              zoom: 2,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona;
            },
            onCameraIdle: () async {
              String address = await getAddress();

              // final url = Uri.parse(
              //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCmLP9y_xLI0AgUpUmGx1ZRrkn5eobCkm8');
              // final response = await http.get(url);
              // final resData = json.decode(response.body);
              // final address = resData['results'][0]['formatted_address'];
              setState(() {
                // location = address;
                formatedAddress = address;
              });
            },
          ),
          Center(child: svgFlagPin),
          Positioned(
              bottom: 100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  elevation: 5,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        leading: Icon(
                          Icons.pin_drop,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          formatedAddress,
                          style: Theme.of(context).textTheme.headline4,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        dense: true,
                      )),
                ),
              )),
          Positioned(
              bottom: 180,
              right: 15,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FabWidget(
                  onPressed: () {
                    if (formatedAddress == Constants.addressNotFound ||
                        formatedAddress == Constants.errorGettingAddress) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context)
                          .pop(LocationModel(lat, lng, formatedAddress));
                    }
                  },
                  icon: Icons.check_rounded,
                ),
              ))
        ]));
  }
}
//  Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: SizedBox(
//                     width: 60,
//                     height: 60,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateColor.resolveWith(
//                               (states) => Theme.of(context).primaryColor)),
//                       onPressed: () {
//                         if (formatedAddress == Constants.addressNotFound ||
//                             formatedAddress == Constants.errorGettingAddress) {
//                           Navigator.of(context).pop();
//                         } else {
//                           Navigator.of(context)
//                               .pop(LocationModel(lat, lng, formatedAddress));
//                         }
//                       },
//                       child: const Icon(Icons.check),
//                     ),
//                   ))
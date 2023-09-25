import 'package:day_tracker_graduation/Screens/journals/tabs/journal_tab.dart';
import 'package:day_tracker_graduation/provider/journal_provider.dart';
import 'package:day_tracker_graduation/widgets/no_entries_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/svgs/svgs.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (context, journalProvider, x) {
      double lat = 0.0;
      double lng = 0.0;
      return Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) async {
                await journalProvider.getAllMarkers();

                lat = journalProvider.markers.first.position.latitude;
                lng = journalProvider.markers.first.position.longitude;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(lat, lng), zoom: 7)));
              },
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat, lng), zoom: 2),
              markers: journalProvider.markers,
            ),
          ),
          if (journalProvider.selectedLoc.isNotEmpty)
            Expanded(
                child: JournalTab(
                    noEntriesWidget: NoEntriesWidget(
                      image: svgNoJournal,
                      text: 'No journal entries',
                    ),
                    journals: journalProvider.selectedLoc,
                    longPressActivated: false)),
        ],
      );
    });
  }
}

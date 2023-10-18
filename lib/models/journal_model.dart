import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/location_model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class JournalModel extends Equatable {
  JournalModel(
      {required this.id,
      required this.content,
      required this.date,
      required this.isLocked,
      required this.location,
      this.weather = '',
      this.imagesUrls = const [],
      this.status = ''});

  final String id;
  final String content;
  final DateTime date;
  final bool isLocked;
  final String weather;
  final LocationModel? location;
  final List<dynamic> imagesUrls;
  final String status;

  get formatedDate {
    return DateFormat(Constants.dateFormat).format(date);
  }

  toMap() {
    return {
      Constants.idKey: id,
      Constants.contentKey: content,
      Constants.formatedDateKey:
          formatedDate, //February 11, 2021. Thu. 03:30 PM
      Constants.dateKey: date,
      Constants.isLockedKey: isLocked ? 1 : 0, //February 11, 2022. Wed. 6:17 PM
      Constants.locationKey: location == null ? {} : location!.toMap(),
      Constants.imageUrlKey: imagesUrls,
      Constants.statusKey: status,
      Constants.weatherKey: weather,
    };
  }

  // bool isEqual(JournalModel journal) {
  //   if (content == journal.content &&
  //       date == journal.date &&
  //       location == journal.location &&
  //       status == journal.status &&
  //       listEquals(imagesUrls, journal.imagesUrls)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  JournalModel.fromMap(map)
      : id = map[Constants.idKey],
        content = map[Constants.contentKey],
        isLocked = map[Constants.isLockedKey] == 1 ? true : false,
        location = LocationModel.fromMap(
            map[Constants.locationKey] as Map<String, dynamic>),
        date = (map[Constants.dateKey] is Timestamp)
            ? (map[Constants.dateKey] as Timestamp).toDate()
            : map[Constants.dateKey],
        imagesUrls = map[Constants.imageUrlKey],
        weather = map[Constants.weatherKey],
        status = map[Constants.statusKey];

  @override
  List<Object?> get props => [content, date, location, status, imagesUrls];
}

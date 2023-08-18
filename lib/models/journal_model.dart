import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class JournalModel {
  JournalModel(
      {required this.id,
      required this.content,
      required this.date,
      required this.isLocked,
      required this.location,
      this.imagesUrls = const [],
      this.status = ''});

  final String id;
  final String content;
  final DateTime date;
  final bool isLocked;
  final String location;
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
      Constants.locationKey: location,
      Constants.imageUrlKey: imagesUrls,
      Constants.statusKey: status
    };
  }

  bool isEqual(JournalModel journal) {
    if (content == journal.content &&
        date == journal.date &&
        location == journal.location &&
        status == journal.status &&
        listEquals(imagesUrls, journal.imagesUrls)) {
      return true;
    } else {
      return false;
    }
  }

  JournalModel.fromMap(map)
      : id = map[Constants.idKey],
        content = map[Constants.contentKey],
        isLocked = map[Constants.isLockedKey] == 1 ? true : false,
        location = map[Constants.locationKey],
        date = (map[Constants.dateKey] is Timestamp)
            ? (map[Constants.dateKey] as Timestamp).toDate()
            : map[Constants.dateKey],
        imagesUrls = map[Constants.imageUrlKey],
        status = map[Constants.statusKey];
}

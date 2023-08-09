import 'package:day_tracker_graduation/utils/constants.dart';

class UserModel {
  final String id;
  final String email;
  final String userName;
  String masterPassword = '';

  UserModel(
      {required this.email,
      required this.userName,
      required this.id,
      this.masterPassword = ''});
  UserModel.fromMap(Map map)
      : id = map[Constants.idKey],
        email = map[Constants.emailKey],
        userName = map[Constants.userNameKey],
        masterPassword = map[Constants.masterPassKey];

  toMap() {
    return {
      Constants.idKey: id,
      Constants.emailKey: email,
      Constants.userNameKey: userName,
      Constants.masterPassKey: masterPassword
    };
  }
}

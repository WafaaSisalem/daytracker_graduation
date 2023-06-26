class UserModel {
  final String id;
  final String email;
  final String userName;

  UserModel({required this.email, required this.userName, required this.id});
  UserModel.fromMap(Map map)
      : id = map['id'],
        email = map['email'],
        userName = map['userName'];
  toMap() {
    return {'id': id, 'email': email, 'userName': userName};
  }
}

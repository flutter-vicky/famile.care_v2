class User {
  final String id;
  User({this.id});
  User.fromJson(Map<String, dynamic> data)
      : id = data['id'].toString();
}
import 'package:esprit_ebook_app/models/user.dart';

class Reader{
  int id;
  int books;
  User user;

  Reader();

  Reader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    books = json['books'];
    user = User.fromJsonNoToken(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['books'] = this.books;
    return data;
  }


}
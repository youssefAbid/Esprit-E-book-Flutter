import 'package:esprit_ebook_app/models/token.dart';

class User {
  int id;
  String fname;
  String lname;
  String avatar;
  String cover;
  String birthdate;
  String about;
  String phone;
  String country;
  String city;
  String address;
  String email;
  String facebook;
  int point;
  Token token;


  User();
/*
  User(
      this.id,
      this.fname,
      this.lname,
      this.avatar,
      this.cover,
      this.birthdate,
      this.about,
      this.phone,
      this.country,
      this.city,
      this.address,
      this.email,
      this.facebook,
      this.point,
      this.token);
*/


  User.fromJson(Map<String, dynamic> json) {
    id = json["user"]['id'];
    fname = json["user"]['fname'];
    lname = json["user"]['lname'];
    avatar = json["user"]['avatar'];
    cover = json["user"]['cover'];
    birthdate = json["user"]['birthdate'];
    about = json["user"]['about'];
    phone = json["user"]['phone'];
    country = json["user"]['country'];
    city = json["user"]['city'];
    address = json["user"]['address'];
    email = json["user"]['email'];
    facebook = json["user"]['facebook'];
    point = json["user"]['point'];
    token = Token.fromJson(json['token']);
  }

  User.fromJsonNoToken(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    avatar = json['avatar'];
    cover = json['cover'];
    birthdate = json['birthdate'];
    about = json['about'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    email = json['email'];
    facebook = json['facebook'];
    point = json['point'];
  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['birthdate'] = this.birthdate;
    data['about'] = this.about;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['email'] = this.email;
    data['facebook'] = this.facebook;
    data['point'] = this.point;
    return data;
  }

}
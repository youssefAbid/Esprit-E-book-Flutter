import 'package:esprit_ebook_app/models/product.dart';

class FinishRead {
  int id;
  int userId;
  int bookId;
  Product book;


  FinishRead.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    bookId = json['bookId'];
    book = Product.fromJSON(json['book']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['bookId'] = this.bookId;
    data['book'] = this.book;
    return data;
  }
}
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/widgets/book_rating.dart';

class Chapter {
  int id;
  int order;
  String title;
  String subtitle;
  String description;
  String file;
  String audio;
  int bookId;
  Product book;

  Chapter();

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    file = json['file'];
    audio = json['audio'];
    bookId = json['bookId'];
  }

  Chapter.fromJsonDetails(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    file = json['file'];
    audio = json['audio'];
    bookId = json['bookId'];
    book = Product.fromJSON(json['book']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order'] = this.order;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['file'] = this.file;
    data['audio'] = this.audio;
    data['bookId'] = this.bookId;
    return data;
  }

}
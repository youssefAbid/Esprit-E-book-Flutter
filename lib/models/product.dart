import 'package:esprit_ebook_app/utils/app_config.dart';

class Product {
  int id;
  String title;
  String author;
  String cover;
  String category;
  String description;
  int totalChapter;
  bool free;
  double price;
  bool digital;
  String file;
  double rates;
  bool deliverable;

  Product();

  Product.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    cover = json['cover'];
    category = json['category'];
    description = json['description'];
    totalChapter = json['totalChapter'];
    free = json['free'];
    price = json['price'].toDouble();
    digital = json['digital'];
    file = json['file'];
    rates = json['rates']!= null? json['rates'].toDouble() : 5.0;
    rates = json['rates']!= null? double.tryParse(AppConfig.rateFormat(json['rates'].toDouble())) : 5.0;
  }

  Product.fromJsonOrder(Map<String, dynamic> json) {
    id = json['book']['id'];
    title = json['book']['title'];
    author = json['book']['author'];
    cover = json['book']['cover'];
    category = json['book']['category'];
    description = json['book']['description'];
    totalChapter = json['book']['totalChapter'];
    free = json['book']['free'];
    price = json['book']['price'].toDouble();
    digital = json['book']['digital'];
    file = json['book']['file'];
    rates = json['book']['rates']!= null? json['book']['rates'].toDouble() : 5.0;
    rates = json['book']['rates']!= null? double.tryParse(AppConfig.rateFormat(json['book']['rates'].toDouble())) : 5.0;
  }

  Map toMap() {
    var data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author'] = this.author;
    data['cover'] = this.cover;
    data['category'] = this.category;
    data['description'] = this.description;
    data['totalChapter'] = this.totalChapter;
    data['free'] = this.free;
    data['price'] = this.price;
    data['digital'] = this.digital;
    data['file'] = this.file;
    return data;
  }

  // double getRate() {
  //   double _rate = 0;
  //   productReviews.forEach((e) => _rate += double.parse(e.rate));
  //   _rate = _rate > 0 ? (_rate / productReviews.length) : 0;
  //   return _rate;
  // }



/*
  Product.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      description = jsonMap['description'];
      capacity = jsonMap['capacity'].toString();
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      packageItemsCount = jsonMap['package_items_count'].toString();
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      capacity = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      print(e);
    }
  }
  */


  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}

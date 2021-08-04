import 'package:esprit_ebook_app/models/product.dart';

class Order{
  int id;
  bool paid;
  bool owned;
  String type;
  Product book;


  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paid = json['paid'];
    owned = json['owned'];
    type = json['type'];
    book = Product.fromJSON(json['book']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paid'] = this.paid;
    data['owned'] = this.owned;
    data['type'] = this.type;
    data['book'] = this.book;
    return data;
  }

}
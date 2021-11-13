import 'dart:typed_data';

class ProductModel {
   String id;
   String title;
   String city;
   String description;
   String sum;
   String currency;
  List<Uint8List?> imgList;


   ProductModel(
      { this.id = "",
       this.title ="",
       this.city ="",
       this.description = "",
       this.sum = "",
       this.currency = "",
       this.imgList = const []});




  ProductModel copyWith(
          {String? id,
          String? title,
          String? city,
          String? description,
          String? sum,
          String? currency,
          List<Uint8List?>? imgList}) =>
      ProductModel(
          id: id ?? this.id,
          title: title ?? this.title,
          city: city ?? this.city,
          description: description ?? this.description,
          sum: sum ?? this.sum,
          currency: currency ?? this.currency,
          imgList: imgList ?? this.imgList);
  
  ProductModel get getEmpty => this;

}

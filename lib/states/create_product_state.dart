import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:sel_it/event/create_product_event.dart';
import 'package:sel_it/models/product_model.dart';

@immutable
class CreateProductState {
  final int position;
  final String productTitle;
  final String city;
  final String productDescription;
  final String sum;
  final String currency;
  static late ProductModel _product;


  ProductModel get product => _product;

  set product(ProductModel value) {
    _product = value;
  }
  CreateProductState setProduct(ProductModel productModel){
    product = productModel;
    return this;
  }

  bool get isTitleValid => productTitle.length > 0 && productTitle.length < 70;

  bool get isCityValid => city.length >= 3;

  bool get isDescriptionValid =>
      productDescription.length > 10 && productDescription.length < 256;

  bool get sisSumValid =>
      RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(sum);



  CreateProductState(
      {this.position = 0,
      this.productTitle = "",
      this.city = "",
      this.productDescription = "",
      this.sum = "",
      this.currency = "",
      });

  CreateProductState copy(
          {int? position,
          String? productTitle,
          String? city,
          String? productDescription,
          String? sum,
          String? currency,
            ProductModel? product }) {
    return CreateProductState(
        position: position ?? this.position,
        productTitle: productTitle ?? this.productTitle,
        city: city ?? this.city,
        productDescription: productDescription ?? this.productDescription,
        sum: sum ?? this.sum,
        currency: currency ?? this.currency);

  }
}

class OnImageChangedState extends CreateProductState {
  final int position;

  OnImageChangedState(this.position) : super(position: position);

  static OnImageChangedState copyWith({required int position}) =>
      OnImageChangedState(position);
}

class OnEditImageState extends CreateProductState {
  final int position;
  final EditImageType editImageType;

  OnEditImageState(this.position, this.editImageType)
      : super(position: position);

  static OnEditImageState copyWith(
          {required int position, required EditImageType editImageType}) =>
      OnEditImageState(position, editImageType);
}

class OnImageCroppedState extends CreateProductState {
  final File file;
  final int position;

  OnImageCroppedState(this.file, this.position) : super(position: position);

  static OnImageCroppedState copyWith(
          {required File file, required int position}) =>
      OnImageCroppedState(file, position);
}

class OnStartDeleteImageState extends CreateProductState {
  OnStartDeleteImageState(int position) : super(position: position);

  OnStartDeleteImageState copyWith() => OnStartDeleteImageState(position);
}

class OnDeleteImageState extends CreateProductState {
  final int position;

  OnDeleteImageState(this.position) : super(position: position);

  static OnDeleteImageState copyWith({required int position}) =>
      OnDeleteImageState(position);
}

class OnAddImageState extends CreateProductState {
  final List<File> files;
  final int position;

  OnAddImageState(this.position, this.files) : super(position: position);

  static OnAddImageState copyWith(
          {required List<File> files, required int position}) =>
      OnAddImageState(position, files);
}

class OnStartAddImageState extends CreateProductState {
  OnStartAddImageState(position) : super(position: position);

  static OnStartAddImageState copyWith(int position) =>
      OnStartAddImageState(position);
}

class OnUnAuthState extends CreateProductState {}

class PublishingProduct extends CreateProductState {}

class PublishDone extends CreateProductState {}

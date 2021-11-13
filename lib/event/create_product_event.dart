import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:sel_it/models/product_model.dart';

enum EditImageType { CROP, FILTER }

@immutable
abstract class CreateProductEvent {}

class OnImageChangedEvent extends CreateProductEvent {
  final int position;

  OnImageChangedEvent({required this.position});
}

class OnEditImageEvent extends CreateProductEvent {
  final int position;
  final EditImageType editImageType;

  OnEditImageEvent({required this.position, required this.editImageType});
}

class OnImageCroppedEvent extends CreateProductEvent {
  final File file;
  final int position;

  OnImageCroppedEvent({required this.file, required this.position});
}

class OnStartDeleteImageEvent extends CreateProductEvent {}

class OnDeleteImageEvent extends CreateProductEvent {
  final int position;

  OnDeleteImageEvent({required this.position});
}

class OnAddNewImageEvent extends CreateProductEvent {
  final List<File> files;
  final int position;

  OnAddNewImageEvent({required this.files, required this.position});
}

class OnStartAddNewImageEvent extends CreateProductEvent {
  final int position;

  OnStartAddNewImageEvent(this.position);
}


class OnTitleChanged extends CreateProductEvent{
  final String title;

  OnTitleChanged(this.title);
}

class OnCityChanged extends CreateProductEvent{
  final String city;

  OnCityChanged(this.city);
}

class OnDescriptionChanged extends CreateProductEvent{
  final String description;

  OnDescriptionChanged(this.description);
}

class OnSumChanged extends CreateProductEvent{
  final String sum;

  OnSumChanged(this.sum);
}

class OnCurrencyChanged extends CreateProductEvent{
  final String currency;

  OnCurrencyChanged(this.currency);
}

class PublishProduct extends CreateProductEvent{

}

class SetProduct extends CreateProductEvent{
  final ProductModel productModel;

  SetProduct(this.productModel);
}
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

@immutable
abstract class EditPictureEvent {}

class SelectPictureEvent extends EditPictureEvent {
  int position;


  SelectPictureEvent({required this.position});
}

class CroppedPictureEvent extends EditPictureEvent {
  File image;
  int position;

  CroppedPictureEvent({required this.image, required this.position});
}

class SavingPictureEvent extends EditPictureEvent{}

class ImageSavedEvent extends EditPictureEvent{
  Uint8List? bytelist;
  ImageSavedEvent({required this.bytelist});
}

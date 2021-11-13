import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';


@immutable
abstract class EditPictureState {}

class SelectedPictureState extends EditPictureState {
  int? position;

  SelectedPictureState({this.position});

  SelectedPictureState copyWith({int? position}) {
    return SelectedPictureState(position: position);
  }
}

class EditedPictureState extends EditPictureState {
  File? file;
  int? position;

  EditedPictureState({this.file, this.position});

  EditedPictureState copyWith({required File file, int? position}) {
    return EditedPictureState(file: file);
  }
}

class SavingPictureState extends EditPictureState {


  SavingPictureState copyWith() => SavingPictureState();
}

class PictureSavedState extends EditPictureState{
  Uint8List? bytelist;
  PictureSavedState({required this.bytelist});

  PictureSavedState copyWith({required bytelist}) => PictureSavedState(bytelist: bytelist);

}

class EmptyImageState extends EditPictureState {

  EmptyImageState copyWith() => EmptyImageState();
}


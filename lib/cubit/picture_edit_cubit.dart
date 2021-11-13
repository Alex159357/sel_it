

import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PictureEditCubit extends Cubit<int>{
  PictureEditCubit() : super(0);

  void setPicture(int position) =>emit(position);

}
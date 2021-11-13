

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sel_it/event/app_events.dart';
import 'package:sel_it/states/app_states.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(StateA()) {
    on<EventA>((event, emit) => emit(StateA()));
    on<EventB>((event, emit) => emit(StateB()));
    on<EventB>((event, emit) => emit(StateC()));
  }
}
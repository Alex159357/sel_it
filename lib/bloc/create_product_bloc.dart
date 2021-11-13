import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sel_it/event/create_product_event.dart';
import 'package:sel_it/models/product_model.dart';
import 'package:sel_it/repository/repository.dart';
import 'package:sel_it/states/create_product_state.dart';

import '../main.dart';

class CreateProductBloc extends Bloc<CreateProductEvent, CreateProductState> {
  final Repository _repository = Repository();

  CreateProductBloc(CreateProductState initialState) : super(CreateProductState());

  @override
  Stream<CreateProductState> mapEventToState(CreateProductEvent event) async* {
    if (event is OnImageChangedEvent)
      yield OnImageChangedState.copyWith(position: event.position);
    if (event is OnEditImageEvent)
      yield OnEditImageState.copyWith(
          position: event.position, editImageType: event.editImageType);
    if (event is OnImageCroppedEvent)
      yield OnImageCroppedState.copyWith(
          file: event.file, position: event.position);
    if (event is OnDeleteImageEvent)
      yield OnDeleteImageState.copyWith(position: event.position);
    if (event is OnStartAddNewImageEvent)
      yield OnStartAddImageState.copyWith(event.position);
    if (event is OnAddNewImageEvent)
      yield OnAddImageState.copyWith(
          files: event.files, position: event.position);
    yield* publishAndAuth(event);
    yield* formValidation(event);
  }

  Stream<CreateProductState> publishAndAuth(CreateProductEvent event) async* {
    if(event is SetProduct){
      yield state.setProduct(event.productModel);
    }
    if (event is PublishProduct) {
      bool authState = prefs.getBool("auth_state") ?? false;
      if (!authState) {
        yield OnUnAuthState();
      } else {
        yield PublishingProduct();
        await _repository.publishProduct(productModel: state.product);
        yield PublishDone();
      }
    }
  }

  Stream<CreateProductState> formValidation(CreateProductEvent event) async* {
    if (event is OnTitleChanged) {
      yield state.copy(productTitle: event.title);
    }
    if (event is OnCityChanged) {
      yield state.copy(city: event.city);
    }
    if (event is OnDescriptionChanged) {
      yield state.copy(productDescription: event.description);
    }
    if (event is OnSumChanged) {
      yield state.copy(sum: event.sum);
    }
    if (event is OnCurrencyChanged) {
      yield state.copy(currency: event.currency);
    }
  }
}

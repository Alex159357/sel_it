import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sel_it/event/edit_picture_event.dart';
import 'package:sel_it/states/edit_picture_state.dart';

class EditPictureBloc extends Bloc<EditPictureEvent, EditPictureState> {
  EditPictureBloc(EditPictureState initialState) : super(initialState);

  @override
  Stream<EditPictureState> mapEventToState(EditPictureEvent event) async* {
    if (event is SelectPictureEvent) {
      yield SelectedPictureState(position: event.position);
    } else if (event is CroppedPictureEvent) {
      yield EditedPictureState(file: event.image, position: event.position);
    } else if (event is SavingPictureEvent)
      yield SavingPictureState();
    else if(event is ImageSavedEvent){
      yield PictureSavedState(bytelist: event.bytelist);
    }
    else
      yield EmptyImageState();
  }
}

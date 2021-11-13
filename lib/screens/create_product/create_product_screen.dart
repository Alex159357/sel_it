import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sel_it/base/base_state_less.dart';
import 'package:sel_it/base/base_stateless_view.dart';
import 'package:sel_it/base/i_base_view.dart';
import 'package:sel_it/bloc/create_product_bloc.dart';
import 'package:sel_it/event/create_product_event.dart';
import 'package:sel_it/models/product_model.dart';
import 'package:sel_it/screens/auth/auth_view.dart';
import 'package:sel_it/screens/camera/camera2.dart';
import 'package:sel_it/states/create_product_state.dart';

import '../../main.dart';

class CreateProductScreen extends BaseStateLess implements I_BaseView {
  late BaseStatelessView _baseStatelessView;
  final List<File> files;
  final PageController controller = PageController(initialPage: 0);
  static List<Uint8List> finalList = [];
  final _formKey = GlobalKey<FormState>();

  CreateProductScreen({Key? key, required this.files}) : super(key: key) {
    _baseStatelessView = this;
    _buildImageList(files);
  }

  void _buildImageList(List<File> fileList) {
    finalList.clear();
    for (int i = 0; i < fileList.length; i++) {
      File file = files[i];
      Uint8List bytes = file.readAsBytesSync();
      finalList.add(bytes);
    }
  }

  //TODO Add filters popup
  //TODo add on image click open in full screen popup

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: BlocProvider(
          create: (context) =>
              CreateProductBloc(OnImageChangedState.copyWith(position: 0)),
          child: _getBody()),
    );
  }

  Widget _getBody() {
    return BlocListener<CreateProductBloc, CreateProductState>(
        listener: (context, state) {
          //todo create update photo state
          // context.read<CreateProductBloc>().add(UpdateImageList(finalList));
      if (state is OnEditImageState) {
        if (state.editImageType == EditImageType.CROP) {
          _cropImage(files[state.position], context,
              state is OnEditImageState ? state.position : 0);
        } else if (state.editImageType == EditImageType.FILTER) {
          colorFilterDialog(context: context, image: finalList[state.position])
              .then((value) {
            finalList[state.position] = value;
            context
                .read<CreateProductBloc>()
                .add(OnImageChangedEvent(position: state.position));
          });
        }
      }
      if (state is OnImageCroppedState) {
        // context
        //     .read<CreateProductBloc>()
        //     .add(OnImageChangedEvent(position: state.position));
        controller.jumpToPage(state.position);
        finalList[state.position] = state.file.readAsBytesSync();
      }
      //Delete item
      if (state is OnDeleteImageState) {
        imageDialogBool(
                context: context,
                image: finalList[state.position],
                agreeButton: Text("Delete"),
                disAgreeButton: Text("cancel"))
            .then((value) {
          if (value is bool) {
            if (value) {
              finalList.removeAt(state.position);
              files.removeAt(state.position);
              controller.jumpToPage(0);
              context
                  .read<CreateProductBloc>()
                  .add(OnImageChangedEvent(position: 0));
            } else {
              controller.jumpToPage(state.position);
              context
                  .read<CreateProductBloc>()
                  .add(OnImageChangedEvent(position: state.position));
            }
          }
        });
        if (finalList.isEmpty) {
          Navigator.pop(context);
        }
      }
      if (state is OnStartAddImageState) {
        _baseStatelessView.showBottomSheet(
            context: context,
            title: "",
            cancelAction: CancelAction(title: const Text('отмена')),
            bottomActions: [
              BottomSheetAction(
                  title: const Text('сделать фото'),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CameraApp();
                    })).then((value) {
                      if (value is List<File>) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                        context.read<CreateProductBloc>().add(
                            OnAddNewImageEvent(
                                files: value, position: state.position));
                      }
                    });
                  }),
              BottomSheetAction(
                  title: const Text('выбрать из галереи'),
                  onPressed: () {
                    _baseStatelessView
                        .pickFile(
                            context: context, onReady: () {}, onBrake: () {})
                        .then((value) {
                      context.read<CreateProductBloc>().add(OnAddNewImageEvent(
                          files: value!, position: state.position));
                    });
                    //  _pickFile(context, state.position);
                  }),
            ]);
      }
      if (state is OnAddImageState) {
        files.insertAll(state.position, state.files);
        _buildImageList(files);
      }
      if (state is PublishDone) {
        prefs.setBool("auth_state", false);
        Navigator.of(context).pop(true);
      }
    }, child: BlocBuilder<CreateProductBloc, CreateProductState>(
      builder: (BuildContext context, state) {
        return WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: state is PublishingProduct
                ? Container(
                    child: Center(
                    child: Text("PROGRESS VIEW"),
                  ))
                : state is OnUnAuthState
                    ? AuthView(
                        authCallback: (state) {
                          print("LOGIN");
                          if (state!) {
                            context
                                .read<CreateProductBloc>()
                                .add(PublishProduct());
                          }
                        },
                      )
                    : Scaffold(
                        resizeToAvoidBottomInset: true,
                        backgroundColor: Theme.of(context).backgroundColor,
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          iconTheme: IconThemeData(color: Colors.white54),
                          title: _getActionButtons(),
                        ),
                        body: _getMain(),
                      ));
      },
    ));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _getMain() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 400,
                    child: Container(
                      color: Colors.black,
                    )),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //picture slider
                        Container(
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: _getImageCarousel(),
                            )),
                        Container(
                            transform:
                                Matrix4.translationValues(0.0, -30.0, 0.0),
                            child: _getContent()),
                        _getBottomButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getImageCarousel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      padding: EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 300,
        child: Container(
          child: BlocBuilder<CreateProductBloc, CreateProductState>(
              builder: (context, state) {
            return Stack(
              children: [
                Opacity(
                  opacity: state is OnDeleteImageState ? 0.3 : 1,
                  child: PageView.builder(
                    onPageChanged: (position) {
                      context
                          .read<CreateProductBloc>()
                          .add(OnImageChangedEvent(position: position));
                    },
                    itemCount: finalList.length,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: _getCarouselItem(finalList[index], index));
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _getCarouselItem(Uint8List img, int position) {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (context, state) {
      return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(26), child: Image.memory(img)),
      );
    });
  }

  Widget _getContent() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (BuildContext context, state) {
      return Container(
          padding: EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                finalList.length > 1
                    ? SizedBox(
                        height: 50,
                        child: _getItemIndicator(),
                      )
                    : Container(),
                _getFrom()
              ],
            ),
          ));
    });
  }

  Widget _getItemIndicator() {
    return Center(
      child: Container(
        height: 10,
        child: Center(child: _getIndicators()),
      ),
    );
  }

  Widget _getIndicators() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (context, state) {
      return Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: finalList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: GestureDetector(
                  onTap: () => controller.jumpToPage(index),
                  child: Icon(Icons.circle,
                      size: 12,
                      color: state.position == index
                          ? Colors.black54
                          : Colors.black26),
                ),
              );
            }),
      );
    });
  }

  Widget _getActionButtons() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (context, state) {
      return Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GestureDetector(
                onTap: () => context.read<CreateProductBloc>().add(
                    OnEditImageEvent(
                        position: state.position,
                        editImageType: EditImageType.CROP)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.crop,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GestureDetector(
                onTap: () => context
                    .read<CreateProductBloc>()
                    .add(OnStartAddNewImageEvent(state.position)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GestureDetector(
                onTap: () => context.read<CreateProductBloc>().add(
                    OnEditImageEvent(
                        position: state.position,
                        editImageType: EditImageType.FILTER)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.color_lens_outlined,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            finalList.length > 1
                ? Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () => context
                          .read<CreateProductBloc>()
                          .add(OnDeleteImageEvent(position: state.position)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delete_outlined,
                          color: Colors.redAccent.shade200,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    });
  }

  void _cropImage(File file, BuildContext context, int position) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            hideBottomControls: true,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings());
    if (croppedFile != null) {
      context
          .read<CreateProductBloc>()
          .add(OnImageCroppedEvent(position: position, file: croppedFile));
    } else {
      final snackBar = SnackBar(content: Text("Error"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _getFrom() {
    return BlocListener<CreateProductBloc, CreateProductState>(
        listener: (BuildContext context, state) {},
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _getTitleField(),
              _getCityField(),
              _getDescriptionField(),
              _getPriceField(),
            ],
          ),
        ));
  }

  Widget _getCityField() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (BuildContext context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onChanged: (v) =>
                      context.read<CreateProductBloc>().add(OnCityChanged(v)),
                  validator: (v) => state.isCityValid ? null : "City Error",
                  decoration: getInputDecoration(
                      hint: "Город",
                      labelColor: Theme.of(context).canvasColor)),
            ),
          ),
        ],
      );
    });
  }

  Widget _getTitleField() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (BuildContext context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(70),
                  ],
                  onChanged: (v) =>
                      context.read<CreateProductBloc>().add(OnTitleChanged(v)),
                  validator: (v) => state.isTitleValid ? null : "Title Error",
                  decoration: getInputDecoration(
                      hint: "Название",
                      suffixText: "70 символов",
                      labelColor: Theme.of(context).canvasColor)),
            ),
          ),
        ],
      );
    });
  }

  Widget _getDescriptionField() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (BuildContext context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  maxLines: 8,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(70),
                  ],
                  onChanged: (v) => context
                      .read<CreateProductBloc>()
                      .add(OnDescriptionChanged(v)),
                  validator: (v) =>
                      state.isDescriptionValid ? null : "Description Error",
                  decoration: getInputDecoration(
                      hint: "Описание",
                      suffixText: "255 символов",
                      labelColor: Theme.of(context).canvasColor)),
            ),
          ),
        ],
      );
    });
  }

  Widget _getPriceField() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (BuildContext context, state) {
      var items = ["USD", "UAH", "RUB"];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextFormField(
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(70),
                        ],
                        keyboardType: TextInputType.number,
                        initialValue: "0",
                        onChanged: (v) => context
                            .read<CreateProductBloc>()
                            .add(OnSumChanged(v)),
                        validator: (v) =>
                            state.sisSumValid ? null : "Sum Error",
                        decoration: getInputDecoration(
                            hint: "Сумма  ",
                            labelColor: Theme.of(context).canvasColor)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: DropdownButtonFormField<String>(
                      decoration: getInputDecoration(
                          hint: "",
                          suffixText: "255 символов",
                          labelColor: Theme.of(context).canvasColor),
                      value: items[1],
                      onChanged: (v) => context
                          .read<CreateProductBloc>()
                          .add(OnCurrencyChanged(v!)),
                      items: items
                          .map((label) => DropdownMenuItem(
                                child: Text(label.toString()),
                                value: label,
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            )),
          ),
        ],
      );
    });
  }

  Widget _getBottomButton() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
      builder: ((BuildContext context, state) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  ProductModel  product = ProductModel(
                      title: state.productTitle,
                      city: state.city,
                      description: state.productDescription,
                      sum: state.sum,
                      currency: state.currency,
                      imgList: finalList);
                  context.read<CreateProductBloc>().add(SetProduct(product));
                  context.read<CreateProductBloc>().add(PublishProduct());
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: SizedBox(
                  height: 45,
                  child: Center(
                      child: Text(
                    "save",
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  )),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _pickFile(BuildContext context, int position) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      Navigator.pop(context);
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.length > 0) {
        context
            .read<CreateProductBloc>()
            .add(OnAddNewImageEvent(files: files, position: position));
      }
    } else {
      Navigator.pop(context);
    }
  }
}

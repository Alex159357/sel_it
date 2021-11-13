import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sel_it/bloc/edit_picture_bloc.dart';
import 'package:sel_it/event/edit_picture_event.dart';
import 'package:sel_it/screens/test_screen.dart';
import 'package:sel_it/states/edit_picture_state.dart';
import 'dart:math' as math;
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class EditPicturesScreen extends StatelessWidget {
  final List<File> files;
  ScreenshotController screenshotController = ScreenshotController();
  List<Uint8List> finalList = [];

  EditPicturesScreen({Key? key, required this.files}) : super(key: key);
  int _currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    finalList.clear();
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      Uint8List bytes = file.readAsBytesSync();
      finalList.add(bytes);
    }

    return BlocProvider(
        create: (context) => EditPictureBloc(SelectedPictureState(position: 0)),
        child: Scaffold(
            appBar: _getAppBar(),
            body: Column(
              children: [_getMainPreview(), _getImageList()],
            )));
  }

  AppBar _getAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: BlocBuilder<EditPictureBloc, EditPictureState>(
              builder: (context, state) {
            File image = state is EditedPictureState
                ? state.file!
                : state is SelectedPictureState
                    ? files[state.position!]
                    : files[0];
            return GestureDetector(
                onTap: () {
                  _cropImage(image, context);
                },
                child: Icon(
                  Icons.crop,
                  color: Colors.white,
                ));
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: BlocBuilder<EditPictureBloc, EditPictureState>(
              builder: (context, state) {
            File image = state is EditedPictureState
                ? state.file!
                : state is SelectedPictureState
                    ? files[state.position!]
                    : files[0];
            return GestureDetector(
                onTap: () {
                  _selectFilter(context, image);
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ));
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: BlocBuilder<EditPictureBloc, EditPictureState>(
              builder: (context, state) {
            Color iconColor = state is SelectedPictureState &&
                    state.position != _currentPosition
                ? Colors.amber
                : Colors.grey;
            _currentPosition = (state is SelectedPictureState
                ? state.position
                : _currentPosition)!;
                //TODo move it to BlocListener
            return GestureDetector(
                onTap: () {
                  context.read<EditPictureBloc>().add(SavingPictureEvent());
                  screenshotController.capture().then((Uint8List? img) {
                    Uint8List pic = img!;
                    // var file = File.fromRawPath(pic);
                    if (state is EmptyImageState) {
                      print("FIRST IMSGE");
                      finalList[0] = pic;
                    } else if (state is SelectedPictureState) {
                      print("${state.position} IMSGE");
                      finalList[state.position!] = pic;
                    } else if (state is EditedPictureState) {
                      print("${state.position} IMSGE");
                      finalList[state.position!] = pic;
                    }
                    context
                        .read<EditPictureBloc>()
                        .add(SelectPictureEvent(position: _currentPosition!));
                  }).catchError((onError) {

                    print(onError);
                  });
                },
                child: Icon(
                  Icons.done_outlined,
                  color: Colors.amber,
                ));
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: BlocBuilder<EditPictureBloc, EditPictureState>(
              builder: (context, state) {
            return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return TestScreen(files: finalList);
                  }));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.greenAccent,
                ));
          }),
        ),
      ],
    );
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  Widget _getMainPreview() {
    return BlocBuilder<EditPictureBloc, EditPictureState>(
      builder: (context, state) {

        if (state is EditedPictureState) {
          files[state.position!] = state.file!;
        }
        File image = state is EditedPictureState
            ? state.file!
            : state is SelectedPictureState
                ? files[state.position!]
                : files[0];
        // if (state is SavingPictureState) {
        //   return CircularProgressIndicator();
        // } else if (state is PictureSavedState) {
        //   return Container(
        //     color: Colors.black,
        //     height: MediaQuery.of(context).size.height - 170,
        //     child: Material(
        //       color: Colors.black,
        //       child: Image.memory(
        //         state.bytelist!,
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   );
        // } else
          return Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height - 170,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _buildPhotoWithFilter(image),
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: _buildFilterSelector(image),
                      ),
                    ],
                  ),
                )),
          );
      },
    );
  }

  final _filters = [
    Colors.transparent,
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];

  final _filterColor = ValueNotifier<Color>(Colors.white);

  void _onFilterChanged(Color value) {
    _filterColor.value = value;
  }

  Widget _buildPhotoWithFilter(File image) {
    return ValueListenableBuilder(
      valueListenable: _filterColor,
      builder: (context, value, child) {
        final color = value as Color;
        return Screenshot(
          controller: screenshotController,
          child: Image.file(
            image,
            color: color.withOpacity(0.5),
            colorBlendMode: BlendMode.color,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildFilterSelector(File image) {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: _filters,
      image: image,
    );
  }

  Widget _getImageList() {
    return BlocBuilder<EditPictureBloc, EditPictureState>(
        builder: (context, state) {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: finalList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // context.read<PictureEditCubit>().setPicture(index);
                context.read<EditPictureBloc>().add(SelectPictureEvent(
                      position: index,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: CircleAvatar(
                  backgroundImage: Image.memory(finalList[index]).image,
                  radius: 30,
                )),
              ),
            );
          },
        ),
      );
    });
  }

  void _cropImage(File file, BuildContext context) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Редактировать',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
        ));
    if (croppedFile != null)
      context.read<EditPictureBloc>().add(CroppedPictureEvent(
          image: croppedFile, position: files.indexOf(file)));
    else {
      final snackBar = SnackBar(content: Text("Error"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _selectFilter(BuildContext context, File file) async {
    // Map imagefile = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PhotoFilterSelector(
    //         title: Text("Photo Filter Example"),
    //         image: image,
    //         filters: filters,
    //         filename: "fileName",
    //         loader: Center(child: CircularProgressIndicator()),
    //         fit: BoxFit.contain,
    //       ),
    //     ));
  }
}

//
// @immutable
// class ExampleInstagramFilterSelection extends StatefulWidget {
//   final File image;
//   const ExampleInstagramFilterSelection({Key? key, required this.image}) : super(key: key);
//
//   @override
//   _ExampleInstagramFilterSelectionState createState() =>
//       _ExampleInstagramFilterSelectionState();
// }
//
// class _ExampleInstagramFilterSelectionState
//     extends State<ExampleInstagramFilterSelection> {
//   final _filters = [
//     Colors.white,
//     ...List.generate(
//       Colors.primaries.length,
//           (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
//     )
//   ];
//
//   final _filterColor = ValueNotifier<Color>(Colors.white);
//
//   void _onFilterChanged(Color value) {
//     _filterColor.value = value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.black,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: _buildPhotoWithFilter(),
//           ),
//           Positioned(
//             left: 0.0,
//             right: 0.0,
//             bottom: 0.0,
//             child: _buildFilterSelector(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPhotoWithFilter() {
//     return ValueListenableBuilder(
//       valueListenable: _filterColor,
//       builder: (context, value, child) {
//         final color = value as Color;
//         return Image.file(
//           widget.image,
//           color: color.withOpacity(0.5),
//           colorBlendMode: BlendMode.color,
//           fit: BoxFit.cover,
//         );
//       },
//     );
//   }
//
//   Widget _buildFilterSelector() {
//     return FilterSelector(
//       onFilterChanged: _onFilterChanged,
//       filters: _filters,
//     );
//   }
// }

@immutable
class FilterSelector extends StatefulWidget {
  final File image;

  const FilterSelector({
    Key? key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
    required this.image,
  }) : super(key: key);

  final List<Color> filters;
  final void Function(Color selectedColor) onFilterChanged;
  final EdgeInsets padding;

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  Color itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      widget.onFilterChanged(widget.filters[page]);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildShadowGradient(itemSize),
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                _buildSelectionRing(itemSize),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onFilterSelected: () => _onFilterTapped(i),
              color: itemColor(i),
              image: widget.image,
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    final size = context.size.width;

    final itemExtent = size / filtersPerScreen;

    final active = viewportOffset.pixels / itemExtent;

    final min = math.max(0, active.floor() - 3).toInt();

    final max = math.min(count - 1, active.ceil() + 3).toInt();

    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    Key? key,
    required this.color,
    this.onFilterSelected,
    required this.image,
  }) : super(key: key);

  final File image;
  final Color color;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.file(
              image,
              fit: BoxFit.fill,
              color: color.withOpacity(0.5),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}

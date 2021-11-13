import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sel_it/base/base_state_less.dart';
import 'package:sel_it/base/base_stateless_view.dart';
import 'package:sel_it/cubit/nav_cubit.dart';
import 'package:sel_it/screens/camera/camera2.dart';
import 'package:sel_it/screens/create_product/create_product_screen.dart';
import 'package:sel_it/screens/home/home_screen.dart';
import 'package:sel_it/screens/settings/settings_page.dart';

class MainNav extends BaseStateLess {
  late BaseStatelessView _baseStatelessView;

  MainNav() {
    _baseStatelessView = this;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:  Theme.of(context).bottomAppBarColor, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));

    List<Widget> pages = [
      HomeScreen(),
      SettingsPage(),
      SettingsPage(),
      HomeScreen(),
    ];
    return BlocProvider(
        create: (context) => NavCubit(),
        child: BlocBuilder<NavCubit, int>(builder: ((context, position) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  SizedBox(
                    child: Image.asset("assets/img/logo.png"),
                    height: 30,
                  )
                ],
              ),
            ),
            body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: pages[position]),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.lightGreenAccent,
              onPressed: () {
                _showBottomSheet(context);
              },
              child: Icon(
                Icons.add_a_photo_outlined,
                color: Theme.of(context).canvasColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            // backgroundColor: position == 0? Theme.of(context).bottomAppBarColor : Theme.of(context).canvasColor,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: [
                Icons.list,
                Icons.person,
              ],
              backgroundColor: Theme.of(context).bottomAppBarColor,
              activeIndex: position,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              activeColor: Theme.of(context).accentColor,
              onTap: (index) => {context.read<NavCubit>().goToPage(index)},
              //other params
            ),
          );
        })));
  }

  void _showBottomSheet(BuildContext context) {
    _baseStatelessView.showBottomSheet(
        context: context,
        title: "Select source",
        cancelAction: CancelAction(title: const Text('отмена')),
        bottomActions: [
          BottomSheetAction(
              title: const Text('сделать фото'),
              onPressed: () {
                _takePhoto(context);
              }),
          BottomSheetAction(
              title: const Text('выбрать из галереи'),
              onPressed: () {
                _pickFile(context);
              }),
        ]);
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      Navigator.pop(context);
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.length > 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return CreateProductScreen(files: files);
        }));
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _takePhoto(BuildContext context) async {
    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return CameraApp();
    })).then((value) {
      if (value is List<File>)
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return CreateProductScreen(files: value);
        }));
    });
  }

// _displayDialog(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: false,
//     transitionDuration: Duration(milliseconds: 500),
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(
//         opacity: animation,
//         child: ScaleTransition(
//           scale: animation,
//           child: child,
//         ),
//       );
//     },
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return SafeArea(
//         // child: CameraScreen(),
//       );
//     },
//   );
// }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sel_it/base/i_base_view.dart';
import 'package:sel_it/view/loading_dialog.dart';
import 'package:sel_it/view/color_filter.dart';

class BaseStatelessView implements I_BaseView {

  @override
  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: LoadingDialog(),
        );
      },
    );
  }

  @override
  void showBottomSheet(
      {required BuildContext context,
      required String title,
      required CancelAction cancelAction,
      required List<BottomSheetAction> bottomActions}) {
    showAdaptiveActionSheet(
        context: context,
        title: const Text('Начать продавать'),
        actions: bottomActions,
        cancelAction:
            cancelAction // onPressed parameter is optional by default will dismiss the ActionSheet
        );
  }

  @override
  void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Future<dynamic> showBoolDialog(
      {required BuildContext context,
      required Widget title,
      required Widget content,
      required Widget okButton,
      required Widget cancelButton}) async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: cancelButton,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: okButton,
                ),
              ],
            ));
  }

  @override
  Future<List<File>?> pickFile(
      {required BuildContext context,
      List<String>? extensions,
      required Function onReady,
      required Function onBrake}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      Navigator.pop(context);
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.length > 0) {
        return files;
      }
    } else {
      onBrake.call();
      Navigator.pop(context);
    }
  }

  Future<dynamic> imageDialogBool(
      {required BuildContext context,
      required Uint8List image,
      required Widget agreeButton,
      required Widget disAgreeButton}) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 350.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(image)
                ),
              )
            ),
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).canvasColor, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<dynamic> colorFilterDialog({required BuildContext context, required Uint8List image}){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: ColorFilter(image: image,),
        );
      },
    );
  }

  InputDecoration getInputDecoration({String? hint, String? suffixText, Color? labelColor, Widget? suffix}) => InputDecoration(
    hintText: suffixText,
    label: Text(hint!),
    prefix: suffix,
    labelStyle: TextStyle(
      color: labelColor!
    ),
    contentPadding:
    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );

}

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';

abstract class I_BaseView {
  void showLoading(BuildContext context);

  void hideLoading(BuildContext context);

  void showBottomSheet(
      {required BuildContext context,
      required String title,
      required CancelAction cancelAction,
      required List<BottomSheetAction> bottomActions});

  Future<List<File>?> pickFile(
      {required BuildContext context,
      List<String>? extensions,
      required Function onReady,
      required Function onBrake});

  Future<dynamic> showBoolDialog(
      {required BuildContext context,
      required Widget title,
      required Widget content,
      required Widget okButton,
      required Widget cancelButton});
}

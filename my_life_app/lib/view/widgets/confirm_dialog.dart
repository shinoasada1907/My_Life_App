import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class ConfirmDialogWidget {
  static void showDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Function() onTapConfirm,
    required Function() onTapCancle,
  }) {
    PanaraConfirmDialog.show(
      context,
      message: message,
      confirmButtonText: 'Chấp nhận',
      cancelButtonText: 'Hủy',
      onTapConfirm: onTapConfirm,
      onTapCancel: onTapCancle,
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }
}

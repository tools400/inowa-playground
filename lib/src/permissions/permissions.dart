import 'package:flutter/widgets.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:inowa/main.dart';
import 'package:inowa/src/ui/permissions/ask_for_permissions_dialog.dart';
import 'package:inowa/src/utils/utils.dart';

class Permissions {
  Permissions._(); // Private constructor to prevent instantiation

  /// Checks the status of a given permission. Returns 'true'
  /// if the permission has been granted, otherwise 'false'.
  static Future<bool> checkPermissionStatus(Permission permission) async {
    return await permission.status.isGranted;
  }

  /// Open the Android request permission dialog and returns the
  /// new status of the permission. The return value is 'true' if
  /// the permission has been granted, otherwise 'false'.
  static Future<bool> requestPermission(Permission permission) async {
    return await permission.request() == PermissionStatus.granted
        ? true
        : false;
  }

  /// Checks, whether a permission has been permanently denied.
  /// Returns 'true' if the permission has been permanently denied,
  /// otherwise 'false'.
  static Future<bool> checkPermanentlyDenied(Permission permission) async {
    return await permission.status.isPermanentlyDenied;
  }

  /// Returns 'true' if the user should be explained why the the
  /// specified permission is required, otherwise 'false'.
  static Future<bool> shouldShowRequestRationale(Permission permission) async {
    return await permission.shouldShowRequestRationale;
  }

  static void callWithPermissions(void Function() function,
      {required bool askUser}) {
    BuildContext context = NavigationService.context;

    checkPermissionStatus(Permission.bluetoothConnect).then((granted) {
      if (!granted) {
        Permissions.checkPermanentlyDenied(Permission.bluetoothConnect).then(
          (permanentlyDenied) {
            if (permanentlyDenied) {
              bleLogger.error(
                  'Bluetooth permission has been permanently denied by the user.');
            } else {
              if (askUser) {
                // Ask user for Bluetooth permission
                Utils.openDialog(context, AskForPermissionsPopup()).then(
                  (button) {
                    if (button! == AskForPermissionsPopup.buttonConfirmed) {
                      // Request Bluetooth permission from device.
                      Permissions.requestPermission(Permission.bluetoothConnect)
                          .then(
                        (granted) {
                          if (!granted) {
                            bleLogger.info(
                                'Bluetooth permission finally not granted by the user.');
                          } else {
                            function();
                          }
                        },
                      );
                    } else {
                      bleLogger.info(
                          'Requesting Bluetooth permission was canceled by the user.');
                    }
                  },
                );
              } else {
                bleLogger.error(
                    'Bluetooth permission not granted. Cannot connect to Arduino.');
              }
            }
          },
        );
      } else {
        function();
      }
    });
  }
}

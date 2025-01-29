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
      {required bool askUser}) async {
    List<Permission> permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
/*
      Permission.location
*/
    ];

    // Collect missing permissions
    List<Permission> permanentlyDeniedPermissions = [];
    List<Permission> missingPermissions = [];
    for (int i = 0; i < permissions.length; i++) {
      var permission = permissions[i];
      if (!await checkPermissionStatus(permission)) {
        if (await Permissions.checkPermanentlyDenied(permission)) {
          permanentlyDeniedPermissions.add(permission);
          bleLogger.error(
              'Permission ${permissions.toString()} permanently denied by user.');
        }
        missingPermissions.add(permission);
      }
    }

    if (permanentlyDeniedPermissions.length > 0) {
      bleLogger.error(
          'Cannot perform function, because some permissions are permanently denied.');
      return;
    }

    if (missingPermissions.length > 0 && !askUser) {
      bleLogger
          .error('Cannot perform function, because permissions are missing.');
      return;
    }

    // Grant permissions.
    if (missingPermissions.length > 0) {
      var context = NavigationService.context;
      var button = await Utils.openDialog(
          context, AskForPermissionsPopup(permissions: missingPermissions));
      if (button == AskForPermissionsPopup.buttonConfirmed) {
        for (int i = 0; i < missingPermissions.length; i++) {
          var permission = permissions[i];
          bool granted = await Permissions.requestPermission(permissions[i]);
          if (granted) {
            bleLogger
                .error('Permission ${permission.toString()} granted by user.');
          } else {
            bleLogger.error(
                'Permission ${permission.toString()} finally not granted by user.');
          }
        }
      } else {
        bleLogger.error('Requesting permission canceled by user.');
      }
    }

    // Re-check missing permissions
    missingPermissions = [];
    for (int i = 0; i < permissions.length; i++) {
      var permission = permissions[i];
      if (!await checkPermissionStatus(permission)) {
        missingPermissions.add(permission);
      }
    }

    // Call function...
    if (missingPermissions.length == 0) {
      function();
    }
  }
}

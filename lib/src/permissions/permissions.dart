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

  static List<Permission> requiredPermissions = [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
/*
      Permission.location
*/
  ];

  /// Checks the permissions required for running the app. The
  /// function returns a list of missing permissions.
  static Future<List<Permission>> checkAppPermissions() async {
    List<Permission> missingPermissions = [];

    for (int i = 0; i < requiredPermissions.length; i++) {
      var permission = requiredPermissions[i];
      if (!await checkPermissionStatus(permission)) {
        missingPermissions.add(permission);
      }
    }

    return missingPermissions;
  }

  // Returns the list of permanently denied permissions.
  static Future<List<Permission>> permanentlyDeniedPermissions() async {
    List<Permission> missingPermissions = [];
    List<Permission> permanentlyDeniedPermissions = [];

    for (int i = 0; i < missingPermissions.length; i++) {
      if (await Permissions.checkPermanentlyDenied(missingPermissions[i])) {
        permanentlyDeniedPermissions.add(missingPermissions[i]);
      }
    }

    return permanentlyDeniedPermissions;
  }

  /// Asks the user to grant permissions and returns 'true' on
  /// success, otherwise 'false'.
  static Future<bool> askForPermissions() async {
    List<Permission> missingPermissions =
        await Permissions.checkAppPermissions();

    var countErrors = 0;

    if (missingPermissions.length > 0) {
      var context = NavigationService.context;
      var button = await Utils.openDialog(
          context, AskForPermissionsPopup(permissions: missingPermissions));
      if (button == AskForPermissionsPopup.buttonConfirmed) {
        for (int i = 0; i < missingPermissions.length; i++) {
          var permission = requiredPermissions[i];
          bool granted =
              await Permissions.requestPermission(requiredPermissions[i]);
          if (granted) {
            bleLogger
                .debug('Permission ${permission.toString()} granted by user.');
          } else {
            bleLogger.error(
                'Permission ${permission.toString()} finally not granted by user.');
            countErrors++;
          }
        }
      } else {
        bleLogger.error('Requesting permission canceled by user.');
        countErrors++;
      }
    }

    if (countErrors == 0) {
      return true;
    }

    return false;
  }

  /// Validates the app permissions and calls the specified function
  /// on success.
  static void callWithPermissions(void Function() function,
      {required bool askUser}) async {
    List<Permission> permanentlyDeniedPermissions =
        await Permissions.permanentlyDeniedPermissions();
    permanentlyDeniedPermissions.forEach((permission) {
      bleLogger.error(
          'Permission ${requiredPermissions.toString()} permanently denied by user.');
    });

    if (permanentlyDeniedPermissions.length > 0) {
      bleLogger.error(
          'Cannot perform function, because some permissions are permanently denied.');
      return;
    }

    // Grant permissions.
    if (await Permissions.askForPermissions()) {
      function();
    }
  }
}

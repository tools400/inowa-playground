import 'package:permission_handler/permission_handler.dart';

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
}

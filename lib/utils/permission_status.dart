import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class PermissionsProvider extends ChangeNotifier {
  PermissionStatus _permissionStatus;
  PermissionStatus get permissionStatus => _permissionStatus;

  Future<void> checkStatus() async {
    var status = await Permission.location.status;
    _permissionStatus = status;

    switch (_permissionStatus) {
      case PermissionStatus.denied:
        notifyListeners();
        // do something
        // print(PermissionStatus.denied);

        break;
      case PermissionStatus.granted:
        notifyListeners();
        // do something;
        // print(PermissionStatus.granted);

        break;
      case PermissionStatus.permanentlyDenied:
        notifyListeners();
        // do something
        // print(PermissionStatus.disabled);

        break;
      case PermissionStatus.restricted:
        notifyListeners();
        // do something
        // print(PermissionStatus.restricted);

        break;

        break;
      default:
    }
    Future.delayed(const Duration(seconds: 5), () {
      checkStatus();
    });

    notifyListeners();
  }
}

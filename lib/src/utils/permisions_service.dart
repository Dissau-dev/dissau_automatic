import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestSmsPermission() async {
    if (await Permission.sms.isGranted) {
      return true;
    } else {
      return await Permission.sms.request() == PermissionStatus.granted;
    }
  }
}

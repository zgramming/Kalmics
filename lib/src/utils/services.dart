import 'package:permission_handler/permission_handler.dart';

import 'exception.dart';

class Services {
  Future<bool> getPermissionStorage() async {
    final status = await Permission.storage.request();

    switch (status) {
      case PermissionStatus.denied:
        final status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          return true;
        }

        if (status == PermissionStatus.permanentlyDenied) {
          throw const StoragePermissionDeniedPermanent();
        }

        throw Exception('Tidak dapat izin mengakses penyimpanan');
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        throw Exception('Tidak dapat izin mengakses penyimpanan');
      case PermissionStatus.limited:
        throw Exception('Tidak dapat izin mengakses penyimpanan');
      case PermissionStatus.permanentlyDenied:
        throw const StoragePermissionDeniedPermanent();

      default:
        throw Exception('Tidak dapat izin mengakses penyimpanan');
    }
  }
}

final services = Services();

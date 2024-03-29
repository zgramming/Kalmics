class ServerException implements Exception {}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class LocationPermissionDeniedException implements Exception {
  final String message;

  LocationPermissionDeniedException(this.message);
}

class LocationPermissionDeniedForeverException implements Exception {
  final String message;

  LocationPermissionDeniedForeverException(this.message);
}

class LocationServiceDisabled implements Exception {
  final String message;

  LocationServiceDisabled(this.message);
}

class StoragePermissionDeniedPermanent implements Exception {
  const StoragePermissionDeniedPermanent({
    this.message =
        'Kami memerlukan izin penyimpanan agar aplikasi berjalan dengan lancar, silahkan izinkan aplikasi untuk mengakses penyimpanan secara manual',
  });

  final String message;
}

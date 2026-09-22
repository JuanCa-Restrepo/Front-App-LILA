import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
/// Subida de archivos a Google Drive mediante una Service Account.
abstract class GoogleDriveUploader {
  Future<String> upload({
    required String localPath,
    required String tipoArchivo,
    String? fileName,
  });
}

/// Implementación temporal — devuelve URLs ficticias.
class GoogleDriveUploaderStub implements GoogleDriveUploader {
  const GoogleDriveUploaderStub();

  @override
  Future<String> upload({
    required String localPath,
    required String tipoArchivo,
    String? fileName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now().microsecondsSinceEpoch;
    return 'https://drive.google.com/lila-stub/$tipoArchivo-$now';
  }
}

/// Implementación real usando una Service Account de Google Cloud.
///
/// Requiere:
/// - `assets/service_account.json` con las credenciales de la SA.
/// - [folderId]: ID de la carpeta de Drive compartida con la SA.
class GoogleDriveUploaderImpl implements GoogleDriveUploader {
  final String folderId;

  GoogleDriveUploaderImpl({required this.folderId});

  AutoRefreshingAuthClient? _client;

  Future<AutoRefreshingAuthClient> _getClient() async {
    if (_client != null) return _client!;

    final jsonString = await rootBundle.loadString(
      'assets/service_account.json',
    );
    final credentials = ServiceAccountCredentials.fromJson(jsonString);

    _client = await clientViaServiceAccount(
      credentials,
      [drive.DriveApi.driveFileScope],
    );
    return _client!;
  }

  @override
  Future<String> upload({
    required String localPath,
    required String tipoArchivo,
    String? fileName,
  }) async {
    final client = await _getClient();
    final driveApi = drive.DriveApi(client);

    final file = File(localPath);
    final name = fileName ?? '${tipoArchivo}_${DateTime.now().millisecondsSinceEpoch}${_ext(localPath)}';

    final driveFile = drive.File()
      ..name = name
      ..parents = [folderId];

    final media = drive.Media(file.openRead(), await file.length());

    final created = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );

    // Hacer el archivo accesible con link.
    await driveApi.permissions.create(
      drive.Permission()
        ..type = 'anyone'
        ..role = 'reader',
      created.id!,
    );

    return 'https://drive.google.com/file/d/${created.id}/view';
  }

  String _ext(String path) {
    final dot = path.lastIndexOf('.');
    return dot == -1 ? '' : path.substring(dot);
  }
}

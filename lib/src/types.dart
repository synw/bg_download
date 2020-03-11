import 'dart:io';

import 'exceptions.dart';
import 'models.dart';

typedef DownloadCompletedCallback = void Function(File file);

typedef DownloadProgressCallback = void Function(DownloadProgress);

typedef DownloadErrorCallback = void Function(
    DownloadErrorInIsolateException error);

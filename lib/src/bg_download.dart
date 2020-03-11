import 'dart:async';
import 'dart:io';
import 'package:bg_download/src/state.dart';
import 'package:meta/meta.dart';
import 'package:iso/iso.dart';
import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'models.dart';
import 'types.dart';

/// The downloader class
class BgDownloader {
  /// Default constructor
  BgDownloader(
      {@required this.url,
      @required this.directory,
      this.onDownloaded,
      this.onProgress,
      this.onDownloadError}) {
    onDownloaded ??= (_) => null;
    onProgress ??= (_) => null;
    onDownloadError ??= (DownloadErrorInIsolateException e) =>
        throw DownloadErrorException("Error downloading $e");
  }

  /// The url to dowwload from
  final String url;

  /// The directory where to put the downloaded file
  final Directory directory;

  /// The callback for when the file is dowwloaded
  DownloadCompletedCallback onDownloaded;

  /// The callback for when the download progress
  DownloadProgressCallback onProgress;

  /// The callback for when there is an error
  DownloadErrorCallback onDownloadError;

  Iso _iso;
  DownloadProgress _progress;

  /// Check if the file size has been retrieved
  bool get isFilesizeKnown {
    if (_progress == null) {
      return false;
    } else if (_progress.hasTotal) {
      return true;
    }
    return false;
  }

  /// Launch the download in an isolate
  Future<void> run() async {
    final filename = url.split("/").last;
    final filepath = directory.path + "/$filename";
    _iso = Iso(_run,
        onDataOut: (dynamic data) => null,
        onError: (dynamic e) {
          if (e is DownloadErrorInIsolateException) {
            onDownloadError(e);
          } else {
            throw DownloadErrorException("Error in the download process: $e");
          }
        });
    _iso.dataOut.listen((dynamic data) {
      _progress = data as DownloadProgress;
      if (_progress.isFinished) {
        _iso.dispose();
        onDownloaded(File(filepath));
      } else {
        onProgress(_progress);
      }
    });
    final params = <dynamic>[url, filepath];
    await _iso.run(params);
  }

  /// Cancel the download
  void cancel() => _iso.dispose();
}

Future<void> _run(IsoRunner iso) async {
  final url = iso.args[0] as String;
  final filepath = iso.args[1] as String;
  final dio = Dio();
  try {
    final state = DownloadState();
    await dio.download(url, filepath,
        options: Options(
            headers: <String, dynamic>{HttpHeaders.acceptEncodingHeader: "*"}),
        onReceiveProgress: (received, total) {
      final progress =
          DownloadProgress(total: total, received: received, state: state);
      //print(
      //    "RECEIVED $received (${progress.receivedHumanized}) / ${progress.totalHumanized} / ${progress.receivedPercent.toStringAsFixed(2)} %");

      iso.send(progress);

      /*final newTotal = received / total * 100;
      if (total != -1 && (newTotal.toStringAsFixed(0) != lastTotal)) {
        //print(newTotal.toStringAsFixed(0) + "%");
        lastTotal = newTotal.toStringAsFixed(0);
        iso.send(newTotal.toInt());
      }*/
    });
  } catch (e) {
    throw DownloadErrorInIsolateException("Error downloading file $e");
  }
  iso.send(const DownloadProgress.finished());
}

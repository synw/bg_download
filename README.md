## Bg download

Download a file in the background in an isolate

   ```dart
   import 'dart:io';
   
   import 'package:bg_download/bg_download.dart';
   
   const _downloadUrl = "http://ipv4.download.thinkbroadband.com/20MB.zip";
   
   Future<void> main() async {
     final dir = Directory(".");
     final dl = BgDownloader(
       url: _downloadUrl,
       directory: dir,
       onDownloaded: (file) => print("File downloaded: $file"),
       onProgress: (p) => print("Download progress ${p.receivedHumanized}"),
       onDownloadError: (error) => throw error,
     );
     await dl.run();
   }
   ```
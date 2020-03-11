import 'package:filesize/filesize.dart';
import 'package:meta/meta.dart';

import 'state.dart';

/// The download progress messages
class DownloadProgress {
  /// Default constructor
  const DownloadProgress(
      {@required this.total, @required this.received, @required this.state});

  /// Constructor for a finished signal
  const DownloadProgress.finished()
      : total = 1,
        received = 1,
        state = null;

  /// The total length of data in bytes
  final int total;

  /// The total length of the received data in bytes
  final int received;

  /// The download state instance
  final DownloadState state;

  /// Check if there is a total
  bool get hasTotal => total != -1;

  /// The percentage of the data received
  int get receivedPercent {
    if (!hasTotal) {
      return 0;
    }
    return ((received / total) * 100).toInt();
  }

  /// Format humanized received percent
  String get receivedHumanizedFormated {
    final rp = receivedHumanized;
    var str = rp;
    if (!rp.contains(".")) {
      final l = rp.split(" ");
      str = "${l[0]}.00 ${l[1]}";
    }
    return str;
  }

  /// The humanized total amount
  String get totalHumanized {
    if (!hasTotal) {
      return "?";
    }
    return filesize(total);
  }

  /// The humanized received amount
  String get receivedHumanized => filesize(received);

  /// Check if the download is completed
  bool get isFinished => received == total;

  @override
  String toString() => "$receivedHumanized / $totalHumanized";
}

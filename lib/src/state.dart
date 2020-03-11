/// The current state of the download
class DownloadState {
  /// The current progress in percent
  int currentPercentPoint = 0;

  /// Calculate if a new percent is available
  bool hasNewPercentValue(int receivedPercent) {
    if (receivedPercent > currentPercentPoint) {
      ++currentPercentPoint;
      return true;
    }
    return false;
  }
}

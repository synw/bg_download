/// An exception for when the dowbload generates an error
class DownloadErrorException implements Exception {
  /// Provide a message
  DownloadErrorException(this.message);

  /// The error message
  final String message;
}

/// An exception for when the dowbload generates an error from the isolate
class DownloadErrorInIsolateException implements Exception {
  /// Provide a message
  DownloadErrorInIsolateException(this.message);

  /// The error message
  final String message;
}

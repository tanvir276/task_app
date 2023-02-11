class ServerException implements Exception {
  String? message;
  int? statusCode;

  ServerException({
    this.message,
    this.statusCode,
  });
}

class NoInternetException implements Exception {}

class CacheException implements Exception {}

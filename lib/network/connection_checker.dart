import 'dart:io';

abstract class ConnectionChecker {
  Future<bool> isConnected();
}

class ConnectionCheckerImpl implements ConnectionChecker {
  @override
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}

import 'dart:io';

class InternetConnection {
  static Future<bool> hasConnection() async {
    bool hasConnection = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }
}

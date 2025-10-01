import 'dart:io';
import 'package:http/io_client.dart';

class ApiClient {
  /// Devuelve un cliente HTTP que ignora certificados inválidos
  static IOClient clientInseguro() {
    final HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // acepta cualquier certificado
    return IOClient(client);
  }
}

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

void main() async {
  // Create a proxy handler
  var handler = proxyHandler('http://localhost:8080');

  // Wrap the handler to add CORS headers
  var corsHandler = createMiddleware(responseHandler: (Response response) {
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, Content-Type',
    });
  });

  // Start the server
  var server = await shelf_io.serve(
    corsHandler.addHandler(handler),
    'localhost',
    8000,
  );

  print('Serving at http://${server.address.host}:${server.port}');
} 
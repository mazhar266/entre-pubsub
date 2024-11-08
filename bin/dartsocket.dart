import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:dartsocket/webpubsub_api.dart'
  as webpubsub; // it calls entre order api

void main() async {
  // first get the web socket url from server
  final webSocketUrl = await webpubsub.getToken();
  String connectionId = "";
  
  // Connect to the WebSocket server
  final socket = await WebSocket.connect(
    webSocketUrl,
    protocols: ['json.webpubsub.azure.v1']
  );

  // Handle WebSocket closure and print the reason if available
  socket.done.then((_) {
    print('WebSocket closed with close code: ${socket.closeCode}, reason: ${socket.closeReason}');
  });

  socket.readyState == WebSocket.open? print('Connection established!'): print('Connection failed');

  // Listen for incoming messages
  socket.listen((message) {
      print('Received message: $message');
      
      // Decode the JSON message
      final decodedMessage = jsonDecode(message);
      
      // Check if the message contains the `connectionId`
      if (decodedMessage is Map<String, dynamic> &&
          decodedMessage.containsKey('type') &&
          decodedMessage['type'] == 'system' &&
          decodedMessage.containsKey('connectionId')) {
        connectionId = decodedMessage['connectionId'];
        print('Connected with connectionId: $connectionId');

        webpubsub.addToGroup(connectionId, 'entre_order_OR000044');

        // subscribe to a group
        final joinGroupMessage = jsonEncode({
          'type': 'joinGroup',
          'group': 'entre_order_OR000044',  // group name
        });
        socket.add(joinGroupMessage);
      } else {
        // Handle other types of messages
        print('Received message: $message');
      }

    }, onError: (error) {
      print('Error occurred: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    },
    cancelOnError: false
  );

  // Close the connection after a certain time (optional)
  Future.delayed(Duration(seconds: 210), () {
    socket.close();
  });
}

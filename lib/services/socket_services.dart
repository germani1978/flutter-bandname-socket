import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, conecting }

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.conecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
      _socket = IO.io('http://192.168.1.105:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Dart client
    _socket.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    
    _socket.on('disconnect', (_) { 
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });


  }
}

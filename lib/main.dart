import 'package:x/pages/pages.dart';
import 'package:x/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (( _ ) => SocketService()) )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bnadas',
        initialRoute: 'home',
        routes: {
          'home' : ((context) => HomePage()),
          'status': ((context) => StatusPage())
        },
      ),
    );
  }
}
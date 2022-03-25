import 'dart:developer';

import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:x/models/models.dart';
import 'package:flutter/material.dart';
import 'package:x/services/socket_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', ( payload) {

      bandas = (payload as List)
                    .map( (e) => Band.fromMap(e) )
                    .toList();

      setState(() {});
    });


    super.initState();
  }


  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: titleAppBandas(),
        body: Column(
          children: [
            _showGraf (),
            Expanded(
              child: ListView.builder(
                itemCount: bandas.length,
                itemBuilder: ((context, i) {
                  return Dismissible(
                    key: Key(bandas[i].id),
                    child: bandaTile(bandas[i]),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    onDismissed: (value) {
                      delBanda(bandas[i].id);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: mostrarDialogo,
        ) // botonAgregarNuevaBanda(context),
        );
  }


  //BARRA del TITULO
  AppBar titleAppBandas() {

    final socketService = Provider.of<SocketService>(context);

    return AppBar(
      title: const Text('Bandas',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25)),
      centerTitle: true,
      elevation: 1,
      actions: [
        Container(
          margin: EdgeInsets.only( right: 10),

          // child: ,
          child: (socketService.serverStatus == ServerStatus.online) 
            ? Icon(Icons.check_circle, color: Colors.blue[300]) 
            : Icon(Icons.offline_bolt, color: Colors.red)
        ),
      ],
      backgroundColor: Colors.white54,
    );
  }

  //ITEM de la LISTA
  ListTile bandaTile(Band banda) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(banda.name.substring(0, 2)),
      ),
      title: Text(banda.name),
      trailing: Text('${banda.votos}'),
      onTap: () {
        socketService.socket.emit('vote-band', { 'id': banda.id} );
        setState(() {
          
        });
      },
    );
  }

  //MOSTRAR DIALOGO PARA AGREGAR UNA BANDA
  mostrarDialogo() {

    final textController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Agregar Banda'),
            content:  TextField(
              autofocus: true,
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            actions: [
              ElevatedButton(
                 onPressed:() {
                  addBand(textController.text);
                 }  ,
                child: const Text('Agregar'),
              ),
            ],
          );
        });
  }

  addBand (String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if ( name.isEmpty) return;


    socketService.socket.emit('add-band', { 'name' : name } );

    Navigator.pop(context);
  }

  delBanda (String id ){
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.emit('del-band', { 'id' : id } );

    // bandas.removeAt(i);
  }

  addVoto (int i) {
    bandas[i].votos++;
    setState(() {});
  }

  Widget _showGraf() {

    Map<String, double> dataMap = {};
     

    bandas.forEach((element) {
      dataMap[element.name] = element.votos.toDouble();
    });

    return Container(
      padding: EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        // chartRadius: MediaQuery.of(context).size.width / 2,
        colorList: [
          Colors.blue[50]!,
          Colors.blue[200]!,
          Colors.pink[50]!,
          Colors.pink[200]!,
          Colors.yellow[50]!,
          Colors.yellow[200]!,
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          // legendShape: _BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
  }

}


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_sms/flutter_sms.dart';
//
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//
void main() {
  setupLocator();
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  String message = "Kaisi hai re tu maheeeeek ?";
  List<String> recipents = ["+919871197994"];

  final String number = "+919871197994";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("रक्षक",
            style: GoogleFonts.courierPrime(
                textStyle: TextStyle(
              fontSize: 40.0,
            ))),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Manthan Gupta"),
              accountEmail: Text("manthangupta109@gmail.com"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                ),
              ),
              decoration:
                  BoxDecoration(color: Colors.deepOrangeAccent.shade200),
            ),
            InkWell(
              child: ListTile(
                title: Text("Home"),
                leading: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              child: ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.settings),
              ),
              onTap: () {},
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Text("About"),
                leading: Icon(
                  Icons.help,
                  color: Colors.blueGrey,
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              child: ListTile(
                title: Text("Log Out"),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.greenAccent.shade700,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children:<Widget>[ new FlutterMap(
          options: new MapOptions(
            center: new LatLng(28.4595,77.0266),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://maps.api.sygic.com/tile/{apiKey}/{z}/{x}/{y}",
              additionalOptions: {
                'apiKey': 'ffDgde5rCn6jjR35GJWD82hUC',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                _buildMarker(new LatLng(28.4595,77.0266)),
              ],
            ),
          ],
        ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 20.0,bottom: 20.0),
              width: 177.0,
              child: GestureDetector(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.error),
                        title: Text('Ambulance'),
                      ),
                    ],
                  ),
                  elevation: 9.0,
                ),
                onTap:()=> _sendSMS(message,recipents),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(left: 190.0,bottom: 20.0),
              width: 177.0,
              child: GestureDetector(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.whatshot),
                        title: Text('Fire Station'),
                      ),
                    ],
                  ),
                  elevation: 9.0,
                ),
                onTap: ()=>_service.call(number)),
              ),
            ),
    ]
          ));

  }

  Marker _buildMarker(LatLng latLng) {
    return new Marker(
      point: latLng,
      width: 60.0,
      height: 55.0,
      builder: (BuildContext context) => const Icon(
        Icons.person_pin_circle,
        size: 60.0,
        color: Colors.red,
      ),
    );
  }
}
class CallsAndMessagesService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");
}
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
void _sendSMS(String message, List<String> recipents) async {
  String _result = await FlutterSms
      .sendSMS(message: message, recipients: recipents)
      .catchError((onError) {
    print(onError);
  });
}

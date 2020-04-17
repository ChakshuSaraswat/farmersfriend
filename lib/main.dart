import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:translator/translator.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Login.dart';
import 'feedback.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SihApp(),
    );
  }
}

class SihApp extends StatefulWidget {
  @override
  _SihAppState createState() => _SihAppState();
}

class _SihAppState extends State<SihApp> {
  final weatherapiID = "bd4bf130154f4bed9b168d2a8494fd2f";
  final mspurl =
      'https://api.data.gov.in/resource/585afdcb-541e-4131-9788-f4b9008a081b?api-key=579b464db66ec23bdd00000173833188974e4d5d4e0b5bc7645691b2&format=json';

  double lat, lon;
  int statecode;
  int sid;
  Position _currentPosition;

  GoogleTranslator translator = new GoogleTranslator();

  List mspcropimagelink = <String>[
    'https://upload.wikimedia.org/wikipedia/commons/1/19/Rice_Plants_%28IRRI%29.jpg',
    'https://tiimg.tistatic.com/fp/1/005/301/premium-grade-rice-paddy-343.jpg',
    'https://5.imimg.com/data5/ML/WX/ZA/SELLER-32672201/hybrid-jawar-seeds-500x500.jpg',
    'https://in.all.biz/img/in/catalog/606136.jpeg',
    'https://confusedparent.in/wp-content/uploads/2017/12/The-Forgotten-Multi-Beneficial-Grain-%E2%80%93-Pearl-Millet-Bajra.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Ab_food_06.jpg/240px-Ab_food_06.jpg',
    'https://5.imimg.com/data5/PO/LH/MY-43858044/ragi-seed-500x500.jpg',
    'https://5.imimg.com/data5/RS/NN/MY-52034904/arhar-dal-500x500.jpg',
    'https://5.imimg.com/data5/DT/SH/MY-57263498/desi-moong-dal-500x500.jpg',
    'https://5.imimg.com/data5/TF/YF/MY-51393289/urad-dal-500x500.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.grey[200],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: FlatButton(
            child: Icon(Icons.help_outline,color: Colors.yellow[200],),
            onPressed: (){
              _launchURL();
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.location_on,
                color: Colors.yellow[200],
              ),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 159, 215, 133),
          title: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'logo.png',
                      fit: BoxFit.cover,
                    ),
                    height: 40,
                    width: 40,
                  ),
                  Text('Farmer\'s Friend',
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, color: Colors.yellow[200])),
                ]),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, top: 30),
              child: Text('◙ Weather: ',
                  style: GoogleFonts.firaSans(fontSize: 20)),
            ),
            displayweatherData(),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10, top: 30),
              child: Text('◙ Minimum support price per quintal: ',
                  style: GoogleFonts.firaSans(fontSize: 20)),
            ),
            displaymspData(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 40, top: 10),
              child: Text('◙ Suggested crops: ',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
            displaycropData(),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  color: Colors.green[400],
                  child: Text('Go to Finance Section: '),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                )),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  color: Colors.green[400],
                  child: Text('Submit Feedback: '),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackForm()),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://youtu.be/L__OghF0vaQ';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('could not launch');
    }
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = position.latitude;
        lon = position.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget displayweatherData() {
    return new FutureBuilder(
        future: getWeather(weatherapiID, lat, lon),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            statecode = int.parse(content['data'][0]['state_code']);
            sid = getstateindex(statecode);
            return Container(
                padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 159, 215, 133),
                        Colors.green[500],
                      ],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: IconButton(
                                icon: Icon(
                                    WeatherIcons.fromString(
                                        content['data'][0]['weather']
                                            ['description'],
                                        fallback: WeatherIcons.day_sunny),
                                    color: Colors.yellow[200],
                                    size: 33),
                              ),
                              padding: EdgeInsets.only(top: 3),
                            ),
                            Container(
                              child: Text(
                                (content['data'][0]['temp'].toString() + "°C"),
                                style: GoogleFonts.firaSans(
                                    fontSize: 40, color: Colors.white),
                              ),
                              padding: EdgeInsets.fromLTRB(5, 7, 5, 10),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        padding: EdgeInsets.only(bottom: 0),
                      ),
                      Container(
                        child: Text(
                          content['data'][0]['city_name'],
                          style: GoogleFonts.firaSans(
                              fontSize: 18, color: Colors.white),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: BoxedIcon(WeatherIcons.sprinkle,
                                  color: Colors.blue[800], size: 18),
                            ),
                            padding: EdgeInsets.only(left: 8, top: 5),
                          ),
                          Container(
                            child: Text(
                              (content['data'][0]['precip'].toString() + "%"),
                              style: GoogleFonts.firaSans(
                                  fontSize: 18, color: Colors.white),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ],
                  ),
                ));
          } else {
            return new Container();
          }
        });
  }

  Widget displaymspData() {
    return new FutureBuilder(
        future: getMsp(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
                height: 300,
                width: 900,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200]),
                    child: ListView.builder(
                      itemCount: content['records'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, right: 5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green[500],
                                  Color.fromARGB(255, 159, 215, 133),
                                ],
                                end: Alignment.topCenter,
                                begin: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  child: Image.network(
                                    mspcropimagelink[index],
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                child: Text(
                                  content['records'][index]
                                      ['commodity___kharif_crops'],
                                  style: GoogleFonts.firaSans(
                                      color: Colors.white, fontSize: 20),
                                ),
                                padding: EdgeInsets.all(5),
                              ),
                              Container(
                                child: Text(
                                  '\u20B9' +
                                      content['records'][index]
                                              ['_2019_20___msp']
                                          .toString(),
                                  style: GoogleFonts.firaSans(
                                      color: Colors.yellow[200], fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )));
          } else {
            return new Container();
          }
        });
  }

  Widget displaycropData() {
    print(sid);
    if (sid == null) sid = 11;
    print(cropdata['server_response'][sid]);
    print(cropdata['server_response'][sid]['crop1']);
    print(cropdata['server_response'][sid]['crop2']);
    print(cropdata['server_response'][sid]['crop3']);
    print(getcropimagelink(cropdata['server_response'][sid]['crop3']));
    print(getcropimagelink(cropdata['server_response'][sid]['crop2']));
    print(getcropimagelink(cropdata['server_response'][sid]['crop1']));
    print(fertdata[cropdata['server_response'][sid]['crop3']]);
    print(fertdata[cropdata['server_response'][sid]['crop2']]);
    print(fertdata[cropdata['server_response'][sid]['crop1']]);
    return Container(
        height: 300,
        width: 900,
        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[200]),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, right: 5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[500],
                        Color.fromARGB(255, 159, 215, 133),
                      ],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        child: Image.network(
                          getcropimagelink(
                              cropdata['server_response'][sid]['crop1']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: Text(
                        cropdata['server_response'][sid]['crop1'],
                        style: GoogleFonts.firaSans(
                            color: Colors.white, fontSize: 20),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'MSP: ',
                            style: TextStyle(color: Colors.yellow[200]),
                          ),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop1']]['msp'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Pesticide: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop1']]['pesticides'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Growth Period: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop1']]['growthperiod'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[500],
                        Color.fromARGB(255, 159, 215, 133),
                      ],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        child: Image.network(
                          getcropimagelink(
                              cropdata['server_response'][sid]['crop2']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: Text(
                        cropdata['server_response'][sid]['crop2'],
                        style: GoogleFonts.firaSans(
                            color: Colors.white, fontSize: 20),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('MSP: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop2']]['msp'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Pesticide: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop2']]['pesticides'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Growth Period: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop2']]['growthperiod'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[500],
                        Color.fromARGB(255, 159, 215, 133),
                      ],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        child: Image.network(
                          getcropimagelink(
                              cropdata['server_response'][sid]['crop3']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: Text(
                        cropdata['server_response'][sid]['crop3'],
                        style: GoogleFonts.firaSans(
                            color: Colors.white, fontSize: 20),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('MSP: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop3']]['msp'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Pesticide: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop3']]['pesticides'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text('Growth Period: ',
                              style: TextStyle(color: Colors.yellow[200])),
                          padding: EdgeInsets.only(right: 5),
                        ),
                        Container(
                            child: Text(
                                fertdata[cropdata['server_response'][sid]
                                    ['crop3']]['growthperiod'],
                                style: TextStyle(color: Colors.yellow[200])),
                            padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<Map> getWeather(String apiId, double lat, double lon) async {
    String apiURL = '';
    if (lat == null || lon == null)
      apiURL =
          'https://api.weatherbit.io/v2.0/current?lat=13.345&lon=74.795&key=bd4bf130154f4bed9b168d2a8494fd2f';
    else
      apiURL =
          'https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=$apiId';
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Future<Map> getMsp() async {
    String apiURL = mspurl;
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  int getstateindex(int x) {
    switch (x) {
      case 12:
        return 0;
      case 16:
        return 1;
      case 30:
        return 2;
      case 3:
        return 3;
      case 34:
        return 4;
      case 39:
        return 5;
      case 33:
        return 6;
      case 9:
        return 7;
      case 5:
        return 8;
      case 11:
        return 9;
      case 38:
        return 10;
      case 19:
        return 11;
      case 13:
        return 12;
      case 35:
        return 13;
      case 16:
        return 14;
      case 17:
        return 15;
      case 18:
        return 16;
      case 31:
        return 17;
      case 20:
        return 18;
      case 21:
        return 19;
      case 23:
        return 20;
      case 24:
        return 21;
      case 29:
        return 22;
      case 25:
        return 23;
      case 40:
        return 24;
      case 26:
        return 25;
      case 36:
        return 26;
      case 39:
        return 27;
      case 28:
        return 28;
    }
  }

  Map cropdata = {
    "server_response": [
      {
        "sid": "4",
        "state": "jammu and kashmir",
        "soil": "alluvial",
        "crop1": "rice",
        "crop2": "maize",
        "crop3": "wheat"
      },
      {
        "sid": "5",
        "state": "andhra pradesh",
        "soil": "red soil",
        "crop1": "pearl millet",
        "crop2": "maize",
        "crop3": "finger millet"
      },
      {
        "sid": "7",
        "state": "arunachal pradesh",
        "soil": "incepticols",
        "crop1": "rice",
        "crop2": "maize",
        "crop3": "millet"
      },
      {
        "sid": "8",
        "state": "assam",
        "soil": "alluvial",
        "crop1": "maize",
        "crop2": "legume",
        "crop3": "potato"
      },
      {
        "sid": "9",
        "state": "bihar",
        "soil": "piedmont",
        "crop1": "rice",
        "crop2": "wheat",
        "crop3": "maize"
      },
      {
        "sid": "10",
        "state": "chhattisgarh",
        "soil": "red sandy soil",
        "crop1": "paddy",
        "crop2": "coarse grain",
        "crop3": "wheat"
      },
      {
        "sid": "11",
        "state": "goa",
        "soil": "laterite",
        "crop1": "maize",
        "crop2": "sorghum",
        "crop3": "pearl millet"
      },
      {
        "sid": "12",
        "state": "gujarat",
        "soil": "loam",
        "crop1": "peanut",
        "crop2": "rice",
        "crop3": "wheat"
      },
      {
        "sid": "13",
        "state": "haryana",
        "soil": "loamy sand",
        "crop1": "wheat",
        "crop2": "rice",
        "crop3": "sugarcane"
      },
      {
        "sid": "14",
        "state": "himachal pradesh",
        "soil": "brown hill soil",
        "crop1": "wheat",
        "crop2": "maize",
        "crop3": "rice"
      },
      {
        "sid": "15",
        "state": "jharkhand",
        "soil": "sandy",
        "crop1": "rice",
        "crop2": "millet",
        "crop3": "maize"
      },
      {
        "sid": "16",
        "state": "karnataka",
        "soil": "loam",
        "crop1": "rice",
        "crop2": "millet",
        "crop3": "sorghum"
      },
      {
        "sid": "17",
        "state": "kerela",
        "soil": "loam",
        "crop1": "coconut",
        "crop2": "cardamom",
        "crop3": "cashew"
      },
      {
        "sid": "18",
        "state": "madhya pradesh",
        "soil": "black soil",
        "crop1": "rice",
        "crop2": "wheat",
        "crop3": "sorghum"
      },
      {
        "sid": "19",
        "state": "maharashtra",
        "soil": "black clayey soil",
        "crop1": "mango",
        "crop2": "grape",
        "crop3": "banana"
      },
      {
        "sid": "20",
        "state": "manipur",
        "soil": "red ferrogenous soil",
        "crop1": "potato",
        "crop2": "pineapple",
        "crop3": "lemon"
      },
      {
        "sid": "21",
        "state": "meghalaya",
        "soil": "red loain soil",
        "crop1": "rice",
        "crop2": "maize",
        "crop3": "pineapple"
      },
      {
        "sid": "22",
        "state": "mizoram",
        "soil": "sand loamy soil",
        "crop1": "mandarin orange",
        "crop2": "banana",
        "crop3": "passion fruit"
      },
      {
        "sid": "23",
        "state": "nagaland",
        "soil": "Inceptisols",
        "crop1": "rice",
        "crop2": "maize",
        "crop3": "millet"
      },
      {
        "sid": "24",
        "state": "odisha",
        "soil": "alluvial",
        "crop1": "rice",
        "crop2": "legume",
        "crop3": "seed oil"
      },
      {
        "sid": "25",
        "state": "punjab",
        "soil": "alluvial",
        "crop1": "barley",
        "crop2": "wheat",
        "crop3": "rice"
      },
      {
        "sid": "26",
        "state": "rajasthan",
        "soil": "sandy",
        "crop1": "wheat",
        "crop2": "barley",
        "crop3": "pulses"
      },
      {
        "sid": "27",
        "state": "sikkim",
        "soil": "loamy skeletal soil",
        "crop1": "rice",
        "crop2": "maize",
        "crop3": "wheat"
      },
      {
        "sid": "28",
        "state": "tamil nadu",
        "soil": "red loam,laterite soil",
        "crop1": "rice",
        "crop2": "sorghum",
        "crop3": "finger millet"
      },
      {
        "sid": "29",
        "state": "telangana",
        "soil": "red loam",
        "crop1": "rice",
        "crop2": "tobacco",
        "crop3": "mango"
      },
      {
        "sid": "30",
        "state": "tripura",
        "soil": "lateritic",
        "crop1": "rice",
        "crop2": "potato",
        "crop3": "sugarcane"
      },
      {
        "sid": "31",
        "state": "uttar pradesh",
        "soil": "alluvial2",
        "crop1": "wheat",
        "crop2": "rice",
        "crop3": "legume"
      },
      {
        "sid": "32",
        "state": "uttarakhand",
        "soil": "broen forest soil",
        "crop1": "rice",
        "crop2": "wheat",
        "crop3": "soyabean"
      },
      {
        "sid": "33",
        "state": "west bengal",
        "soil": "laterite soil",
        "crop1": "rice",
        "crop2": "wheat",
        "crop3": "soyabean"
      }
    ]
  };

  Map cropimagelinks = {
    "rice": "http://ricepedia.org/images/rice-as-a-plant.jpg",
    "maize": "https://krishijagran.com/media/25064/maize.png?format=webp",
    "wheat":
        "https://upload.wikimedia.org/wikipedia/commons/b/b4/Wheat_close-up.JPG",
    "pearl millet":
        "https://i.pinimg.com/originals/82/21/49/822149277ef0e90f99c9550bd730200a.jpg",
    "finger millet":
        "https://content.eol.org/data/media/7f/2f/cc/542.2934265801.jpg",
    "millet":
        "https://cdn.britannica.com/48/156548-050-7F7B684C/Millet-grains-harvest.jpg",
    "legume":
        "https://q7i2y6d5.stackpathcdn.com/wp-content/uploads/2012/06/legume-plant-400x300.jpg",
    "potato":
        "https://www.almanac.com/sites/default/files/users/AlmanacStaffArchive/potatoes-harvested_full_width.jpg",
    "paddy":
        "https://previews.123rf.com/images/ongkachakon/ongkachakon1605/ongkachakon160500036/56426083-close-up-of-yellow-paddy-rice-plant-spike-rice-field.jpg",
    "coarse grain": "https://neweralive.na/uploads/old/Mahangu1.jpg",
    "sorghum":
        "https://cdn.britannica.com/s:700x500/21/136021-050-FA97E7C7/Sorghum.jpg",
    "peanut":
        "https://q7i2y6d5.stackpathcdn.com/wp-content/uploads/2010/04/peanut-plant-400x300.jpg",
    "sugarcane":
        "https://q7i2y6d5.stackpathcdn.com/wp-content/uploads/2018/09/sugarcane-400x266.jpg",
    "coconut":
        "https://previews.123rf.com/images/olegd/olegd1108/olegd110800153/10298561-close-up-of-coconut-palm-tree.jpg",
    "cardamom":
        "https://5.imimg.com/data5/QN/RU/YU/SELLER-75276894/img-20180418-wa0169-500x500.jpg",
    "cashew":
        "https://media.mnn.com/assets/images/2017/11/Cashew-hanging-from-tree.jpg.653x0_q80_crop-smart.jpg",
    "mango":
        "https://cdn.shopify.com/s/files/1/2083/6855/products/how-to-grow-a-mango-tree-in-pot-1.jpg?v=1499122159",
    "grape":
        "https://4.imimg.com/data4/LS/NA/MY-7508195/grapes-plants-500x500.jpg",
    "banana":
        "https://s.yimg.com/aah/green2995/banana-plants-banana-trees-and-how-to-grow-info-121.jpg",
    "pineapple":
        "https://hgtvhome.sndimg.com/content/dam/images/hgtv/stock/2018/2/9/shutterstock_689220253-EQ-Roy_pineapple-plant.jpg.rend.hgtvcom.581.872.suffix/1518211407458.jpeg",
    "lemon":
        "https://images-na.ssl-images-amazon.com/images/I/71fTY-UkJfL._SL1000_.jpg",
    "barley": "https://cdn.britannica.com/31/75931-050-ADF0386D/Barley.jpg",
    "pulses":
        "https://previews.123rf.com/images/dinodia/dinodia1709/dinodia170916302/85792737-green-vegetable-and-pulses-green-peas-pisum-sativum-garden-peas-pods-hanging-on-plants-in-field.jpg",
    "soyabean":
        "https://cdn.britannica.com/28/154828-050-05C6239A/Soybeans.jpg",
  };

  Map pestdata = {
    "server_response": [
      {
        "pid": "1",
        "crop": "cotton",
        "animal_pests": "12.3",
        "weeds": "7.2",
        "pathogens": "8.6",
        "virus": "0.7",
        "total": "28.8"
      },
      {
        "pid": "2",
        "crop": "maize",
        "animal_pests": "9.6",
        "weeds": "8.5",
        "pathogens": "10.5",
        "virus": "2.7",
        "total": "31.3"
      },
      {
        "pid": "3",
        "crop": "potatoes",
        "animal_pests": "10.9",
        "weeds": "14.5",
        "pathogens": "8.3",
        "virus": "6.6",
        "total": "40.3"
      },
      {
        "pid": "4",
        "crop": "rice",
        "animal_pests": "15.1",
        "weeds": "10.8",
        "pathogens": "10.2",
        "virus": "1.4",
        "total": "37.5"
      },
      {
        "pid": "5",
        "crop": "soyabean",
        "animal_pests": "8.8",
        "weeds": "8.9",
        "pathogens": "7.5",
        "virus": "1.2",
        "total": "26.4"
      },
      {
        "pid": "6",
        "crop": "wheat",
        "animal_pests": "7.9",
        "weeds": "10.2",
        "pathogens": "7.7",
        "virus": "2.4",
        "total": "28.2"
      }
    ]
  };

  Map fertdata = {
    "potato": {
      "msp": "487",
      "fertilizer": "NPK",
      "pesticides": "Exirel",
      "growthperiod": "3-4 months"
    },
    "paddy": {
      "msp": "1550",
      "fertilizer": "NPK",
      "pesticides": "Malathion",
      "growthperiod": "4 months"
    },
    "coarse grain": {
      "msp": "1700",
      "fertilizer": "NPK",
      "pesticides": "Glyphosate",
      "growthperiod": "2-3 months"
    },
    "sorghum": {
      "msp": "5000",
      "fertilizer": "NPK",
      "pesticides": "Carbaryl",
      "growthperiod": "3-4 months"
    },
    "peanut": {
      "msp": "4890",
      "fertilizer": "Phosphorus Pentaoxide",
      "pesticides": "Quintozene",
      "growthperiod": "2-3 months"
    },
    "sugarcane": {
      "msp": "255",
      "fertilizer": "NPK",
      "pesticides": "ADAMA Acemain",
      "growthperiod": "10-14 months"
    },
    "coconut": {
      "msp": "2030",
      "fertilizer": "Azospirillum",
      "pesticides": "Carbofuran",
      "growthperiod": "5-6 years"
    },
    "rice": {
      "msp": "1815",
      "fertilizer": "Nitrogenous Fertilizers",
      "pesticides": "Lambda-Cyhalothrin",
      "growthperiod": "3-6 months"
    },
    "maize": {
      "msp": "1760",
      "fertilizer": "NPK",
      "pesticides": "Cholopyriphos",
      "growthperiod": "4 months"
    },
    "wheat": {
      "msp": "1925",
      "fertilizer": "Pottasium Sulphate",
      "pesticides": "Organo-Phosphates",
      "growthperiod": "3 months"
    },
    "pearl": {
      "msp": "1950",
      "fertilizer": "NPK",
      "pesticides": "Atrazine",
      "growthperiod": "4 months"
    },
    "millet": {
      "msp": "1000",
      "fertilizer": "Phosphoric Fertilizers",
      "pesticides": "Methyl Demeton",
      "growthperiod": "2 months"
    },
    "legume": {
      "msp": "4800",
      "fertilizer": "Nitrogenous Fertilizers",
      "pesticides": "Dicofol P",
      "growthperiod": "2 months"
    },
    "cashew": {
      "msp": "161.7",
      "fertilizer": "Urea and Rock Phosphate",
      "pesticides": "Endosulphan",
      "growthperiod": "2-3 years"
    },
    "mango": {
      "msp": "2500",
      "fertilizer": "NPK",
      "pesticides": "Imidachloprid",
      "growthperiod": "5 years"
    },
    "grape": {
      "msp": "1363",
      "fertilizer": "Nitrogenous Fertilizers",
      "pesticides": "Carbaryl",
      "growthperiod": "3 years"
    },
    "banana": {
      "msp": "2800",
      "fertilizer": "NPK",
      "pesticides": "Chloropyrifos",
      "growthperiod": "7-8 months"
    },
    "pineapple": {
      "msp": "2500",
      "fertilizer": "Nitrogenous Fertilizers",
      "pesticides": "Triademefon",
      "growthperiod": "2 years"
    },
    "lemon": {
      "msp": "3500",
      "fertilizer": "Nitrogenous Fertilizers",
      "pesticides": "Epsom Salt",
      "growthperiod": "3 years"
    },
    "barley": {
      "msp": "1525",
      "fertilizer": "NPK",
      "pesticides": "Propiconazole",
      "growthperiod": "2 months"
    },
    "pulses": {
      "msp": "4620",
      "fertilizer": "NPK",
      "pesticides": "Chlorpyrifos",
      "growthperiod": "2.5 months"
    },
    "soyabean": {
      "msp": "3710",
      "fertilizer": "NPK",
      "pesticides": "Phosphonic acid",
      "growthperiod": "3-5 months"
    },
  };

  String getcropimagelink(String crop) {
    return cropimagelinks[crop];
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'sqlite.dart';
import 'data_service.dart';
import 'models.dart';
import 'globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHomePage> {
  bool loading = false;
  bool isCelcius = true;
  double position = 0;
  bool serviceEnabled = false;
  String _currentAddress = "";
  Position? _currentPosition;
  final _dataService = DataService();
  final _weekDataService = WeekDataService();
  WeatherResponse? _response;
  WeekWeatherResponse? _weekResponse;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (globals.toRefresh == true) {
        _search(globals.cityGlobal.text);
      }
      setState(() {
        position -= 20;
        if (position == -10220) {
          position = 0;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.vt323TextTheme()),
        home: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                appBar: AppBar(
                  leading: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu_rounded)),
                  ),
                  actions: [
                    Center(
                      child: Text(
                        '°F',
                        style: GoogleFonts.vt323(fontSize: 20),
                      ),
                    ),
                    Switch(
                      value: isCelcius,
                      onChanged: (value) {
                        setState(() {
                          isCelcius = value;
                          _search(globals.cityGlobal.text);
                        });
                      },
                      activeTrackColor: Colors.white24,
                      activeColor: Colors.white,
                    ),
                    Center(
                      child: Text(
                        '°C ',
                        style: GoogleFonts.vt323(fontSize: 20),
                      ),
                    )
                  ],
                  title: const Text('MyWeatherNes'),
                  backgroundColor: Colors.red,
                ),
                drawer: const MyDrawer(),
                body: Stack(
                  children: [
                    AnimatedPositioned(
                      left: position,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Image.asset(
                          'assets/images/back.png',
                          height: 750,
                          fit: BoxFit.cover,
                        ),
                      ),
                      duration: const Duration(microseconds: 200),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (loading == true)
                              const CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            if (_response != null)
                              if (_response?.cityName == "Not Found") ...[
                                Image.asset("assets/images/gameover.png"),
                                Text(
                                  '''
                                  Game Over !
                                  Try Again !
                                  ''',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.vt323(fontSize: 40),
                                )
                              ] else ...[
                                Column(
                                  children: [
                                    Image.asset(
                                        'assets/images/${_response!.weatherInfo!.icon}.png'),
                                    Text(
                                      '${_response!.cityName}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.vt323(fontSize: 60),
                                    ),
                                    Text(
                                        '${_response!.weatherInfo!.description}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.vt323(fontSize: 40)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          1.0, 10.0, 1.0, 10.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isCelcius == true) ...[
                                              Text(
                                                  '${_response!.mainInfo!.temperature?.round()}°C',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.vt323(
                                                      fontSize: 40)),
                                              Column(children: [
                                                Text(
                                                    '''   ${_response!.mainInfo!.tempMin?.round()}°C''',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.vt323(
                                                        fontSize: 20,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 5, 66, 116))),
                                                Text(
                                                    '''   ${_response!.mainInfo!.tempMax?.round()}°C''',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.vt323(
                                                        fontSize: 20,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 172, 24, 13))),
                                              ]),
                                            ] else ...[
                                              Text(
                                                  '${_response!.mainInfo!.temperature?.round()}°F',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.vt323(
                                                      fontSize: 40)),
                                              Column(children: [
                                                Text(
                                                    '''   ${_response!.mainInfo!.tempMin?.round()}°F''',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.vt323(
                                                        fontSize: 20,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 5, 66, 116))),
                                                Text(
                                                    '''   ${_response!.mainInfo!.tempMax?.round()}°F''',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.vt323(
                                                        fontSize: 20,
                                                        color: Colors.red)),
                                              ]),
                                            ]
                                          ]),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/humidity.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                        Text(
                                            ''' ${_response!.mainInfo!.humidity} %''',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.vt323(
                                                fontSize: 30)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          1.0, 10.0, 1.0, 10.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/wind.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            Text(
                                                ''' ${_response!.windInfo!.speed?.round()} km/h''',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.vt323(
                                                    fontSize: 30)),
                                          ]),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/pressure.png',
                                            height: 25,
                                            width: 25,
                                          ),
                                          Text(
                                              ''' ${_response!.mainInfo!.pressure} hPa''',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.vt323(
                                                  fontSize: 20)),
                                        ]),
                                  ],
                                ),
                              ],
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    padding: const EdgeInsets.only(top: 15),
                                    onPressed: () {
                                      if (globals.cityGlobal.text.isNotEmpty) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        _showMyDialog();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.star_rounded,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 15.0, 1.0, 10.0),
                                    child: SizedBox(
                                        width: 150,
                                        child: TextField(
                                            controller: globals.cityGlobal,
                                            decoration: const InputDecoration(
                                              labelText: 'Ville',
                                              labelStyle:
                                                  TextStyle(color: Colors.red),
                                              hintText: 'Entrer la ville',
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                            ),
                                            textAlign: TextAlign.center,
                                            cursorColor: Colors.red)),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.only(top: 10),
                                    icon: const Icon(Icons.gps_fixed),
                                    color: Colors.red,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _getCurrentLocation();
                                    },
                                  )
                                ]),
                            ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_checkempty()) {
                                    _search(globals.cityGlobal.text);
                                  }
                                },
                                child: const Text('Rechercher'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  Future<void> _addCity(String name) async {
    var reponse = await SQLHelper.checkItem(name);
    if (reponse.isEmpty) {
      await SQLHelper.createItem(name);
    }
  }

  bool _checkempty() {
    if (globals.cityGlobal.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void _search(city) async {
    _response = null;
    loading = true;
    globals.toRefresh = false;
    final response = await _dataService.getWeather(city, isCelcius);
    setState(() => _response = response);

    final responseWeek = await _weekDataService.getWeekWeather(
        isCelcius, _response?.lat, _response?.lon);
    setState(() => _weekResponse = responseWeek);
    loading = false;
    print(responseWeek.dayOne!.tempInfo!.tempMin);
  }

  void _getCurrentLocation() async {
    _response = null;
    loading = true;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    });
  }

  void _getAddressFromLatLng() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude);

    Placemark place = placemarks[0];
    setState(() {
      _currentAddress = "${place.locality}";
    });
    if (_currentAddress != "") {
      _search(_currentAddress);
      globals.cityGlobal.text = _currentAddress;
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                image: const DecorationImage(
                    image: AssetImage('assets/images/popdial.png'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: <Widget>[
                  Text('Favoris',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Text('Voulez-vous sauvegarder cette ville dans vos favoris ?',
                      textAlign: TextAlign.end,
                      style:
                          GoogleFonts.vt323(fontSize: 20, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 50, 10, 0),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          child: const Text(
                            'Oui',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _addCity(globals.cityGlobal.text);
                            _search(globals.cityGlobal.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 50, 10, 0),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          child: const Text(
                            'Non',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

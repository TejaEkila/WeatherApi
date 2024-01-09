import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapi/models/weather_models.dart';
import 'package:weatherapi/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  bool loading = true;
  final _weatherService = WeatherService(apiKey: 'e3be5d5480a199792753d58079345f7f');
  Weather? _weather;
  DateTime now = DateTime.now();
  //feach weather
  _feachWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    // faech weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        loading = false;
        
        
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        
      });
    }
  }

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      _feachWeather();
    });
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const WeatherPage(),
      ),
    );
  }

  // animation
  String getweatherAnimations(String? mainCondition) {
    if (mainCondition == null) return "assents/";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloudy.json';
      case 'rain':
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "ThunderStorm":
        return 'assets/thunder.json';
      case "clear":
        return "assets/sunny.json";
      default:
        return "aseets/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 215, 212),
        elevation: 0,
        leading: Container(
          height: 50,
          width: 50,
          child: Lottie.asset('assets/logo.json', fit: BoxFit.cover),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ))
        ],
        title: const Padding(
          padding: EdgeInsets.only(right: 140),
          child: Text(
            'WEATHER',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 29),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 215, 215, 212),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //logo
          IconButton(
            onPressed: _reset,
            icon: const Icon(
              Icons.room,
              size: 50,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          //city name
          Text(
            _weather?.cityName ?? 'loading cityname..',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 40),
          ),
          
          Text(" $now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 20),),
          // animation

          SizedBox(
            height: 340,
            width: 300,
            child: loading ? Lottie.asset('assets/loading.json') : Lottie.asset(getweatherAnimations(_weather?.mainCondition), fit: BoxFit.cover),
          ),
          Text(
            "${_weather?.temperture.round()}°C",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 40),
          ),
          SizedBox(height: 150,)
          //
        ]),
      ),
    );
  }
}

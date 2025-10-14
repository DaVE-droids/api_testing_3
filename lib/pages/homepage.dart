import 'dart:async';
import 'dart:math';

import 'package:api_testing_3/Widgets/drawer.dart';
import 'package:api_testing_3/Widgets/facts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/country_images.dart';
import '../consts.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  String cityName = 'Nigeria';
  bool isLoading = true;
  String? randomFacts;

String _getBackgroundForCountry(String cityName){
  return countryImages[cityName]?? 'assets/images/background.jpg';
}

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _loadLastCountry();
    randomFacts = africanFacts[Random().nextInt(africanFacts.length)];
    Timer.periodic(const Duration(seconds: 10), (timer){
      setState(() {
        randomFacts = africanFacts[Random().nextInt(africanFacts.length)];
      });
    });
  }
  Future<void> _loadLastCountry() async{
    final prefs = await SharedPreferences.getInstance();
    final savedCountry = prefs.getString('lastCountry');
    if (savedCountry != null){
      setState(() {
        cityName = savedCountry;
      });
    }
    await _fetchWeather();
  }
  Future <void> _fetchWeather()async{
    try{
      final cleanedCity = cityName.replaceAll('_', ' ');
      Weather w = await _wf.currentWeatherByCityName(cleanedCity);
      setState(() {
        _weather = w;
        isLoading = false;
        print('Weather for: $cleanedCity');
      });
    }catch (e){
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgImage = _getBackgroundForCountry(cityName);
    return Scaffold(
      key: scaffoldKey,
      appBar: MyAppBar(),
      drawer: MyDrawer(
        onCountrySelected: (selectedCountry)async{
          setState(() {
            cityName = selectedCountry;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('lastCountry', cityName);
          await _fetchWeather();

        },
      ),
        body: Stack(
          children:[
            AnimatedSwitcher(
              duration: const Duration(seconds: 2),
            child: Container(
              key: ValueKey<String>(bgImage),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  opacity: 0.3,
                    image: AssetImage(bgImage),
                  fit: BoxFit.fill
                ),
                border: Border.all(
                  color: Colors.black
                )
              ),
                child: _buildUI()
            ),
          ),
    ]
        )

    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery
          .sizeOf(context)
          .width,
      height: MediaQuery
          .sizeOf(context)
          .height,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _locationHeader(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  _weatherIcon(140),
            SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,),
                _weatherTemperature(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.03,),
                  _dateTimeInfo(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,),
                  _extraInfo(),
                  _factsBar()
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          child: Text(_weather?.areaName ?? '', key: ValueKey(_weather?.areaName ?? ''),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
              color: Colors.white
          ),
          ),
          transitionBuilder: (child, animation)=> FadeTransition(opacity: animation, child: child,),
        ),
       const SizedBox(width: 4,),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          child: Text(_weather?.country ?? '', key: ValueKey(_weather?.country ?? ''),
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              color: Colors.white
            ),
          ),
          transitionBuilder: (child, animation)=> FadeTransition(opacity: animation, child: child,),

        ),
      ],
    );
  }
  Widget _dateTimeInfo(){
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      child: Text (DateFormat.yMMMEd().format(now), key: ValueKey(DateFormat.yMMMEd().format(now)),
      style: const TextStyle(
        fontWeight: FontWeight.w700,
          color: Colors.white
      ),
      ),
      transitionBuilder: (child, animation)=> FadeTransition(opacity: animation, child: child,),
    ),
          ],
        )
      ],
    );
  }
  Widget _weatherIcon(double? iconSize){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        if(_weather?.weatherMain != null && _weather!.weatherMain!.toLowerCase().contains('cloud'))...[
          Icon(Icons.cloud, color: Colors.lightBlueAccent, size: iconSize,)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('rain'))...[
          Icon(Icons.water_drop_outlined, color: Colors.lightBlueAccent, size: iconSize)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('snow'))...[
           Icon(Icons.snowing, color: Colors.lightBlueAccent, size: iconSize),
          Icon(Icons.severe_cold, color: Colors.lightBlueAccent, size: iconSize)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('sun'))...[
          Icon(Icons.sunny, color: Colors.lightBlueAccent, size: iconSize)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('thunder'))...[
           Icon(Icons.thunderstorm_rounded, color: Colors.lightBlueAccent, size: iconSize)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('mist'))...[
           Icon(Icons.waves, color: Colors.lightBlueAccent , size: iconSize)
        ],

        if(_weather?.weatherMain != null && _weather!.weatherDescription!.toLowerCase().contains('sky'))...[
           Icon(Icons.air, color: Colors.lightBlueAccent , size: iconSize),  Icon(Icons.sunny, color: Colors.yellow , size: iconSize)
        ],
      ],
    );
  }
  Widget _weatherTemperature(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 900),
              child: Text('${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C', key: ValueKey('${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C'),
                style:
                const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.w900
                ),
              ),
              transitionBuilder: (child, animation)=>FadeTransition(opacity: animation, child: child,),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          child: Text(_weather?.weatherDescription?.toUpperCase()??'Not found', key: ValueKey(_weather?.weatherDescription?.toUpperCase()??'Not found'),
                style:
              const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                color: Colors.white
              ),
              ),
    ),
      ],
    );
  }
  Widget _extraInfo(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.18,
            width: MediaQuery.sizeOf(context).width * 0.25,
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('TODAY', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 5,),
                      _weatherIcon(30),
                      SizedBox(height: 5,),
                      Text(_weather?.weatherMain??'', style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15,),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.18,
            width: MediaQuery.sizeOf(context).width * 0.6,
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Column(
                      children: [
                        Icon(Icons.thermostat_outlined, color: Colors.white,),
                        Text('${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C, ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C', style: TextStyle(color: Colors.white)),
                        const Text('Min/Max', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.water_drop, color: Colors.white,),
                        Text('${_weather?.humidity?.toStringAsFixed(0)}%' , style: TextStyle(color: Colors.white)),
                        const Text('Humidity', style: TextStyle(color: Colors.white))
                      ],
                    )
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _factsBar(){
    return Align(
      alignment: Alignment.bottomCenter,
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black87
          ),
          height: MediaQuery.sizeOf(context).height * 0.1,
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: AnimatedSwitcher(
            duration: Duration(seconds: 2),
            child: Text("Today's Fact: ${randomFacts?? ''}", key: ValueKey("Today's Fact: ${randomFacts?? ''}"),
            style:
              const TextStyle(
                color: Colors.white,
                fontSize: 11
              ),
            ),
            transitionBuilder: (child, animation)=>FadeTransition(opacity: animation, child: child,)
          ),
        ),
      ),

    );
  }
}
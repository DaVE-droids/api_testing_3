import 'package:api_testing_3/Widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../Widgets/app_bar.dart';
import '../consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  String cityName = 'Lagos';
  bool isLoading = true;


  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
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
    return Scaffold(
      key: scaffoldKey,
      appBar: MyAppBar(),
      drawer: MyDrawer(
        onCountrySelected: (selectedCountry)async{
          setState(() {
            cityName = selectedCountry;
          });
          await _fetchWeather();

        },
      ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill
            ),
            border: Border.all(
              color: Colors.black
            )
          ),
            child: _buildUI()
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
                  _weatherTemperature(),
            SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,),
                _weatherIcon(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,),      
                  _dateTimeInfo(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,),
                  _extraInfo(),
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
        Text(_weather?.areaName ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
            color: Colors.white
        ),
        ),
       const SizedBox(width: 4,),
        Text(_weather?.country ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            color: Colors.white
          ),
        ),
      ],
    );
  }
  Widget _dateTimeInfo(){
    DateTime now = _weather!.date!;
    print("This is now date: $now");
    return Column(
      children: [
        Text (DateFormat('h:mm a').format(now),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white

        ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
    Text (DateFormat.yMMMEd().format(now),
    style: const TextStyle(
      fontWeight: FontWeight.w700,
        color: Colors.white
    ),
    ),
          ],
        )
      ],
    );
  }
  Widget _weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        if(_weather?.weatherMain != null && _weather?.weatherMain?.toLowerCase() == "clouds")...[
          const Icon(Icons.wb_cloudy_rounded, size: 40,),
          //Image.asset("assets/images/cloudy.jpg", height: 100, width: 100,),
        ],
        if(_weather?.weatherMain != null && _weather?.weatherMain?.toLowerCase() == "rain")...[
          //Image.asset("assets/images/thunderstormRain.jpg", height: 100, width: 100,),
          const Icon(Icons.water_drop_outlined, size: 40,), const Icon(Icons.umbrella, size: 40,)
        ],
        if(_weather?.weatherMain != null && _weather?.weatherMain?.toLowerCase() == "snow")...[
          const Icon(Icons.snowing, size: 40,), const Icon(Icons.severe_cold, size: 40,)
        ],



      ],
    );
  }
  Widget _weatherTemperature(){
    return Column(
      children: [
        Text('${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C', style:
          const TextStyle(
            fontSize: 50,
            color: Colors.black,
            fontWeight: FontWeight.w900
          ),
        ),
        Text(_weather?.weatherDescription?.toUpperCase()??'Not found', style:
        const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          color: Colors.black
        ),
        )
      ],
    );
  }
  Widget _extraInfo(){
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.8,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(25)
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
                  Icon(Icons.thermostat_outlined),
                  Text('${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C, ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C'),
                  const Text('Min/Max')
                ],
              ),
              Column(
                children: [
                  Icon(Icons.water_drop),
                  Text('${_weather?.humidity?.toStringAsFixed(0)}%'),
                  const Text('Humidity')
                ],
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Column(
                children: [
                  Icon(Icons.wind_power_sharp),
                  Text('${_weather?.windSpeed} m/s'),
                  const Text('Wind Speed')
                ],
              ),
              Column(
                children: [
                  Icon(Icons.speed_rounded),
                  Text('${_weather?.pressure} atm'),
                  const Text('Pressure')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
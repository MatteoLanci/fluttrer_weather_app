// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/themes/themes.dart';

class WeatherPage extends StatefulWidget {
  final Function(ThemeData) onThemeChange;

  const WeatherPage({
    super.key,
    required this.onThemeChange,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isError = false;

  //? init state
  @override
  void initState() {
    //! fetch weather on startup
    _fetchWeather();
    super.initState();
  }

  //? fetch weather method
  _fetchWeather([String? cityName]) async {
    setState(() {
      _isError = false;
    });

    final selectedCityName = cityName ?? await _weatherService.getCurrentCity();

    //? get current city
    // String cityName = await _weatherService.getCurrentCity();

    //? get weather data for selected city
    try {
      final weather = await _weatherService.getWeather(selectedCityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);

      setState(() {
        _isError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching weather data. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    //? clear searchbar + hiding keyboard after function triggered
    _searchController.clear();
    FocusScope.of(context).unfocus();

    var now = DateTime.now();
    if (now.hour >= 17 || now.hour <= 5) {
      widget.onThemeChange(AppThemes.darkTheme);
    } else {
      widget.onThemeChange(AppThemes.lightTheme);
    }
  }

  //? weather animations > lottie
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json'; //!default to sunny condition
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';

      case 'thunderstorm':
        return 'assets/thunder.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search a city...',
            suffixIcon: IconButton(
              onPressed: () => _fetchWeather(_searchController.text),
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: _isError
                ? const Text(
                    'Error while fetching weather data, please try again')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      //? city name
                      Text(_weather?.cityName ?? 'loading city ...'),

                      //? animation
                      Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition)),

                      //? temperature
                      Text('${_weather?.temperature.round().toString()} °C'),

                      //? weather condition
                      Text(_weather?.mainCondition ?? ''),

                      //? additional info
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_down_sharp),
                                Text(
                                  '${_weather?.minTemp.round().toString()} °C',
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_drop_up_sharp),
                                Text(
                                  '${_weather?.maxTemp.round().toString()} °C',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city, bool isCelcius) async {
    Map<String, String>? queryParameters;
    if (isCelcius == true) {
      queryParameters = {
        'q': city,
        'appid': 'd453dea62661dc625be44ab725def653',
        'units': 'metric',
        'lang': 'fr'
      };
    } else {
      queryParameters = {
        'q': city,
        'appid': 'd453dea62661dc625be44ab725def653',
        'lang': 'fr'
      };
    }
    final uri = Uri.https(
        'api.openweathermap.org', "/data/2.5/weather", queryParameters);

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      return WeatherResponse(cityName: 'Not Found');
    }

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}

class WeekDataService {
  Future<WeekWeatherResponse> getWeekWeather(
      bool isCelcius, double? lat, double? lon) async {
    String metric = "";
    String latt = lat.toString();
    String long = lon.toString();

    if (isCelcius == true) {
      metric = 'metric';
    } else {
      metric = 'standard';
    }
    final queryParameters = {
      'lat': latt,
      'lon': long,
      'exclude': 'hourly,current,alerts,minutely',
      'appid': 'd453dea62661dc625be44ab725def653',
      'units': metric,
      'lang': 'fr'
    };
    final uri = Uri.https(
        'api.openweathermap.org', "/data/2.5/onecall", queryParameters);

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return WeekWeatherResponse.fromJson(json);
  }
}

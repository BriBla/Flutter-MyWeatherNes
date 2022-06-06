class Cities {
  final int id;
  final String name;

  const Cities({
    required this.id,
    required this.name,
  });
}

class WeatherResponse {
  final String? cityName;
  final TemperatureInfo? mainInfo;
  final WeatherInfo? weatherInfo;
  final WindInfo? windInfo;
  final double? lat;
  final double? lon;

  WeatherResponse(
      {this.cityName,
      this.mainInfo,
      this.weatherInfo,
      this.windInfo,
      this.lat,
      this.lon});

  //Pour le nom de la ville
  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];

    //Pour les temperatures
    final mainInfoJson = json['main'];
    final mainInfo = TemperatureInfo.fromJson(mainInfoJson);

    //Pour la meteo
    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    //Pour le vent
    final windInfoJson = json['wind'];
    final windInfo = WindInfo.fromJson(windInfoJson);

    //Pour la longitude et lattitude
    final coordInfoJson = json['coord'];
    final lon = coordInfoJson['lon'];
    final lat = coordInfoJson['lat'];

    //Pour la semaine

    return WeatherResponse(
        cityName: cityName,
        mainInfo: mainInfo,
        weatherInfo: weatherInfo,
        windInfo: windInfo,
        lat: lat,
        lon: lon);
  }
}

class WindInfo {
  final num? speed;
  final int? deg;

  WindInfo({this.speed, this.deg});

  factory WindInfo.fromJson(Map<String, dynamic> json) {
    final speed = json['speed'];
    final deg = json['deg'];

    return WindInfo(speed: speed, deg: deg);
  }
}

class TemperatureInfo {
  final num? temperature;
  final num? tempMin;
  final num? tempMax;
  final int? humidity;
  final int? pressure;

  TemperatureInfo(
      {this.temperature,
      this.tempMax,
      this.tempMin,
      this.humidity,
      this.pressure});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    final tempMin = json['temp_min'];
    final tempMax = json['temp_max'];
    final humidity = json['humidity'];
    final pressure = json['pressure'];

    return TemperatureInfo(
        temperature: temperature,
        tempMax: tempMax,
        tempMin: tempMin,
        humidity: humidity,
        pressure: pressure);
  }
}

class WeatherInfo {
  final String? description;
  final String? icon;

  WeatherInfo({this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class WeekWeatherResponse {
  final ListWeatherInfo? dayOne;
  WeekWeatherResponse({this.dayOne});

  factory WeekWeatherResponse.fromJson(Map<String, dynamic> json) {
    final datetimeJson = json['daily'][1];
    final dayOne = ListWeatherInfo.fromJson(datetimeJson);
    print(datetimeJson);

    return WeekWeatherResponse(dayOne: dayOne);
  }
}

class ListWeatherInfo {
  final TemperatureInfo? tempInfo;
  final WeatherInfo? weatherInfo;

  ListWeatherInfo({this.tempInfo, this.weatherInfo});

  factory ListWeatherInfo.fromJson(Map<String, dynamic> json) {
    //Pour les temperatures
    final tempInfoJson = json['temp'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    //Pour la meteo
    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    return ListWeatherInfo(tempInfo: tempInfo, weatherInfo: weatherInfo);
  }
}

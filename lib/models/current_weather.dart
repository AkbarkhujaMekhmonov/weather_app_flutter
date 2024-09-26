class CurrentWeather {
  String? weather;
  dynamic temp;

  CurrentWeather({this.weather, this.temp});

  CurrentWeather.fromJson(Map<String, dynamic> json) {
    weather=json["cloud_amount"];
    temp=json["air_t"];
  }


}

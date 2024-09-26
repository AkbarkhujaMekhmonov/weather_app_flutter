import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/current_weather.dart';

import '../utills/dimension.dart';

class WeatherLandscapeWidget extends StatefulWidget {
  const WeatherLandscapeWidget({super.key, required this.currentWeather});
  final CurrentWeather currentWeather;

  @override
  State<WeatherLandscapeWidget> createState() => _WeatherLandscapeWidgetState();
}

class _WeatherLandscapeWidgetState extends State<WeatherLandscapeWidget> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.height/5,
      padding: EdgeInsets.only(right: 30,left: 30),
      height: MediaQuery.of(context).size.height/2.89,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            height: MediaQuery.of(context).size.height/5,
            "assets/images/${widget.currentWeather.weather}.png",
          ),
          widget.currentWeather.temp==100?Text("Internet connection problem"):
          Text(
            widget.currentWeather.temp!.round().toString()+"°",
            style: TextStyle(fontSize: 60, color: defaultColorScheme.primary),
          ),
          widget.currentWeather.temp!=100?
          Text(
            "Тошкент",
            style: TextStyle(fontSize: 30, color: defaultColorScheme.primary),
          ):Text(""),
        ],
      ),
    );
  }
}

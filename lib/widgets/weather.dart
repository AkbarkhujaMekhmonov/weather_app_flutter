import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/utills/dimension.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key, required this.currentWeather});

  final CurrentWeather currentWeather;

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;


    return Container(
      height: MediaQuery.of(context).size.height / 3.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              "assets/images/${widget.currentWeather.weather}.png",
              height: MediaQuery.of(context).size.height / 7.6,
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
          Expanded(
            flex: 1,
            child:widget.currentWeather.temp==100?Text("Internet connection problem"):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.currentWeather.temp!.round().toString()+"°",
                  style: TextStyle(
                      fontSize: 60, color: defaultColorScheme.primary),
                ),
                Text(
                  "Тошкент",
                  style: TextStyle(
                      fontSize: 30, color: defaultColorScheme.primary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

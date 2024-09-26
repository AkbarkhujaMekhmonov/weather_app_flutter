import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:weather/models/current_date.dart';
import 'package:weather/models/current_weather.dart';
import 'package:weather/services/date_service.dart';
import 'package:weather/widgets/date.dart';
import 'package:weather/widgets/weather.dart';
import '../utills/date.dart';
import '../widgets/date_landscape.dart';
import '../widgets/weather_landscape.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  //Widget? dateWidget;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  CurrentDate? date;
  CurrentWeather? weather;
  bool isWeatherLoading = true;
  bool isDateLoading = true;
  String? weatherErrorMessage;
  String? dateErrorMessage;
  bool colon = true;
  String nowMinute = "",
      nowSecond = "",
      nowHour = "",
      nowMonth = "",
      nowWeekday = "",
      nowDay = "";

  @override
  void initState() {
    DateTime now;
    int hour = 0;
    int minute = 0;
    int second = 0;
    if (DateService().date == null) {
      now = DateTime.now();
    } else {
      String? date = DateService().date?.datetime.toString();
      now = DateTime.parse(date!);
      now = now.add(Duration(
          hours: int.parse(
              DateService().date!.abbreviation.toString().substring(1, 3))));
    }
    hour = now.hour;
    minute = now.minute;
    second = now.second;

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (colon == true) {
          colon = false;
        } else {
          colon = true;
        }
        second++;
        if (second == 60) {
          second = 0;
          minute++;
          if (minute == 60) {
            minute = 0;
            hour++;
          }
        }
        nowSecond = second.toString().padLeft(2, "0");
        nowMinute = minute.toString().padLeft(2, "0");
        nowHour = hour.toString().padLeft(2, "0");
        nowMonth = Date().months.keys.firstWhere(
            (key) => Date().months[key] == DateTime.now().month,
            orElse: () => "null");
        nowWeekday = Date().weekdays.keys.firstWhere(
            (key) => Date().weekdays[key] == DateTime.now().weekday,
            orElse: () => "null");
        nowDay = DateTime.now().day.toString();
      });
    });
    super.initState();
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkConnectivity();
    WidgetsBinding.instance.addObserver(this);

    fetchWeather();
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }

    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          _connectionStatus = 'Connected';
          fetchWeather();
          DateService()
              .apiGetDate(); // Internet mavjud bo'lsa, API dan ma'lumotlarni yangilash
          break;
        case ConnectivityResult.none:
          _connectionStatus = 'No Internet Connection';
          break;
        default:
          _connectionStatus = 'Unknown';
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await fetchWeather();
    await DateService().apiGetDate();
  }

  Future<void> fetchWeather() async {
    try {
      final weatherData = await apiGetWeather();
      setState(() {
        weather = weatherData;
        print(weatherData);
        isWeatherLoading = false;
      });
    } catch (e) {
      final weatherData = await apiGetWeather();

      setState(() {
        weatherErrorMessage = e.toString();
        weather = weatherData;
        isWeatherLoading = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      fetchWeather();
      DateService()
          .apiGetDate(); // Resume qilganda ma'lumotlarni yangilash so'rovi
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    ThemeMode themeMode = ThemeMode.system;

    String i = Theme.of(context).brightness == Brightness.light
        ? 'assets/images/background.png'
        : 'assets/images/background_light.png';

    return Scaffold(
      backgroundColor: defaultColorScheme.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox.fromSize(
            size: MediaQuery.of(context).size,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  i,
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          dateErrorMessage == null
                              ? Expanded(
                                  child: MediaQuery.of(context).size.width < 500
                                      ? DateWidget(
                                          nowDay: nowDay,
                                          nowHour: nowHour,
                                          nowMinute: nowMinute,
                                          nowMonth: nowMonth,
                                          nowSecond: nowSecond,
                                          nowWeekday: nowWeekday,
                                          colon: colon,
                                        )
                                      : DateLandscapeWidget(
                                          nowDay: nowDay,
                                          nowHour: nowHour,
                                          nowMinute: nowMinute,
                                          nowMonth: nowMonth,
                                          nowSecond: nowSecond,
                                          nowWeekday: nowWeekday,
                                          colon: colon,
                                        ),
                                )
                              : Text(dateErrorMessage.toString()),
                          weatherErrorMessage == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.6,
                                  width:
                                      MediaQuery.of(context).size.width / 1.22,
                                  child: MediaQuery.of(context).size.width < 500
                                      ? WeatherWidget(
                                          currentWeather: weather ??
                                              CurrentWeather(
                                                  weather: "sad", temp: 100),
                                        )
                                      : WeatherLandscapeWidget(
                                          currentWeather: weather ??
                                              CurrentWeather(
                                                  weather: "sad", temp: 100),
                                        ),
                                )
                              : Text(weatherErrorMessage.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<CurrentWeather?> apiGetWeather() async {
    CurrentWeather? currentWeather;
    try {
      final uri = Uri.parse(
          "https://www.meteo.uz/api/v2/weather/current.json?city=tashkent&language=uz");
      final response =
          await http.get(uri, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        var a = json.decode(utf8.decode(response.bodyBytes));
        currentWeather =
            CurrentWeather(weather: a["cloud_amount"], temp: a["air_t"] );
        print(currentWeather);
      }
      throw response.statusCode;
    } catch (error) {
      print(error.toString());
    }
    return currentWeather;
  }
}

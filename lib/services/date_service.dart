import 'dart:convert';

import '../models/current_date.dart';
import 'package:http/http.dart' as http;

class DateService{
  CurrentDate? date;
  Future<CurrentDate?> apiGetDate() async {
    CurrentDate? currentDate;
    try {
      final uri =
      Uri.parse("http://worldtimeapi.org/api/timezone/Asia/Tashkent");
      final response =
      await http.get(uri, headers: {"Content-Type": "application/json"});
      if(response.statusCode==200){
        currentDate =
            CurrentDate.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }throw"Internet Connection Problem";

    } catch (error) {
      print(error.toString());
    }

    return currentDate;
  }
  void fetchDate() async{
    try{
      final timeData= await apiGetDate();
      date=timeData;
    }catch(e){
      print(e);
    }
  }
}
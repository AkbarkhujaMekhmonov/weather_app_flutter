import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({
    super.key, required this.colon, required this.nowMinute, required this.nowSecond, required this.nowHour, required this.nowMonth, required this.nowWeekday, required this.nowDay,
  });

  final bool colon;

  final String nowMinute;
  final String nowSecond;

  final String nowHour;

  final String nowMonth;

  final String nowWeekday;

  final String nowDay;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
      decoration: BoxDecoration(
          border: Border.all(color: defaultColorScheme.onPrimary, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      constraints: BoxConstraints.tightForFinite(
          height: MediaQuery.of(context).size.height / 1.64,
          width: MediaQuery.of(context).size.width / 1.1),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height / 5.44 / 2,
            child: Image.asset(
              'assets/images/gerb.png',
              height: MediaQuery.of(context).size.height / 5.44,
              width: MediaQuery.of(context).size.width / 4.72,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.nowHour,
                    style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: defaultColorScheme.primary),
                  ),
                  Visibility(
                    visible: widget.colon,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Text(
                      ":",
                      style: TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.bold,
                          color: defaultColorScheme.primary),
                    ),
                  ),
                  Text(
                    widget.nowMinute,
                    style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: defaultColorScheme.primary),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "${widget.nowDay} ${widget.nowMonth}",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: defaultColorScheme.secondary),
                ),
              ),
              Container(
                child: Text(
                  widget.nowWeekday,
                  style: TextStyle(
                      fontSize: 45, color: defaultColorScheme.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

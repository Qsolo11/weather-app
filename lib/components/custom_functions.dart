import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String weekDayNameFromEpoch(int epoch) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch((epoch * 1000).toInt());
  String weekDayName;
  // String formattedDateTime = "${dateTime.day}/${dateTime.month}/${dateTime.year} ${getWeekDayName(dateTime.weekday)}";
  switch (dateTime.weekday) {
    case DateTime.monday:
      weekDayName = 'Monday';
    case DateTime.tuesday:
      weekDayName = 'Tuesday';
    case DateTime.wednesday:
      weekDayName = 'Wednesday';
    case DateTime.thursday:
      weekDayName = 'Thursday';
    case DateTime.friday:
      weekDayName = 'Friday';
    case DateTime.saturday:
      weekDayName = 'Saturday';
    case DateTime.sunday:
      weekDayName = 'Sunday';
    default:
      weekDayName = '';
  }
  return weekDayName;
}

String dateFromEpoch(int epoch) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch((epoch * 1000).toInt());
  String formattedDateTime =
      "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  return formattedDateTime;
}

String convertLatLngToString(LatLng latlng) {
  String latLngString = "${latlng.latitude},${latlng.longitude}";
  return latLngString;
}

List<String> returnStringListForAutoComplete(List<dynamic> responseList) {
  List<String> combinedList = responseList.map((location) {
    return "${location['name']}, ${location['country']}";
  }).toList();
  return combinedList;
}

LatLng getLatLon(
  List<dynamic> originalList,
  String locationString,
) {
  // Split the location string into name and country
  List<String> parts = locationString.split(', ');
  String name = parts[0];
  String country = parts[1];

  // Find the item in the original list
  Map<String, dynamic>? item = originalList.firstWhere(
    (item) => item['name'] == name && item['country'] == country,
    orElse: () => null,
  );

  // If item is found, return lat,lon; otherwise, return null
  return item != null ? LatLng(item['lat'], item['lon']) : LatLng(0.0, 0.0);
}

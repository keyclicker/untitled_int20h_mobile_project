import 'package:flutter/material.dart';
import 'dart:core';


class Activity{
  String type;
  DateTime actionDate;
  DateTime actionDuration;
  double distance;

  Activity(String type, DateTime actionDate, DateTime actionDuration, double distance){
    this.type = type;
    this.actionDate = actionDate;
    this.actionDuration = actionDuration;
    this.distance = distance;
  }
}

import 'package:esprit_ebook_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


ValueNotifier<User> currentUser = new ValueNotifier(User());

class AppConfig {
  static User MAIN_USER;
  // AppConfig({
  //   this.MAIN_USER,
  // });

  User getMainUser() {
    return MAIN_USER;
  }

  static Future<bool> checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String url = '${GlobalConfiguration().getString('base_url')}login';
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    if (value == 0) {
      return Future<bool>.value(false);
    } else {

      var response = await http.get(url + "/users", headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $value"
      });
      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    }
  }

  static String dateFormat(DateTime date) {
    return new DateFormat.yMMMMd().add_Hm().format(date);
  }

  static String dateFormatAppointment(DateTime date) {
    return new DateFormat.yMMMMd().add_jm().format(date);
  }

  static String timeFormat(DateTime date) {
    return new DateFormat.jm().format(date);
  }

  static String rateFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static String currencyFormat() {
    return "TND";
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
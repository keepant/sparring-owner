import 'package:flutter/material.dart';
import 'package:sparring_owner/pages/bookings/bookings.dart';
import 'package:sparring_owner/pages/login/login.dart';
import 'package:sparring_owner/pages/more/more.dart';
import 'package:sparring_owner/pages/root.dart';

final routes = {
  '/': (BuildContext context) => Root(),
  '/login': (BuildContext context) => LoginPage(),
  '/booking': (BuildContext context) => Bookings(),
  '/more': (BuildContext context) => More(),
};

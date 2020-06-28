import 'package:flutter/material.dart';
import 'package:sparring_owner/pages/bookings/cancelled_bookings.dart';
import 'package:sparring_owner/pages/bookings/completed_bookings.dart';
import 'package:sparring_owner/pages/bookings/upcoming_bookings.dart';

class Bookings extends StatefulWidget {
  Bookings({
    Key key,
  }) : super(key: key);

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffdee4eb),
        appBar: AppBar(
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Bookings",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 21.0,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black54,
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "Completed",
              ),
              Tab(
                text: "Cancelled",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UpcomingBookings(),
            CompletedBookings(),
            CancelledBookings(),
          ],
        ),
      ),
    );
  }
}

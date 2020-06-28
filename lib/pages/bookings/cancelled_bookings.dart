import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/booking_card.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/graphql/bookings.dart';
import 'package:sparring_owner/pages/bookings/booking_details.dart';
import 'package:intl/intl.dart';

class CancelledBookings extends StatefulWidget {
  @override
  _CancelledBookingsState createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  SharedPreferences sharedPreferences;
  String _userId;

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getAllBookings),
            pollInterval: 5,
            variables: {
              'id': _userId,
              'status': 'cancelled',
            }),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.loading) {
            return Loading();
          }

          if (result.data['bookings'].length == 0) {
            return EmptyListWidget(
              title: 'No bookings',
              subTitle: 'No cancelled bookings available yet',
              image: null,
              packageImage: PackageImage.Image_4,
            );
          }

          return ListView.builder(
            itemCount: result.data['bookings'].length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var booking = result.data['bookings'][index];
              var court = result.data['bookings'][index]['court'];
              var img =
                  result.data['bookings'][index]['court']['court_images'][0];

              return BookingCard(
                imgUrl: img['name'],
                title: court['name'],
                location: court['address'],
                date: new DateFormat.yMMMMd('en_US')
                    .format(DateTime.parse(booking['date']))
                    .toString(),
                timeStart: new DateFormat.Hm()
                    .format(DateTime.parse(
                        booking['date'] + ' ' + booking['time_start']))
                    .toString(),
                timeEnd: new DateFormat.Hm()
                    .format(DateTime.parse(
                        booking['date'] + ' ' + booking['time_end']))
                    .toString(),
                icon: FontAwesomeIcons.calendarAlt,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: BookingDetails(
                        //id: booking['id'],
                        ),
                    platformSpecific: false,
                    withNavBar: false,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

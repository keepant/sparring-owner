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
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/bookings/booking_details.dart';
import 'package:sparring_owner/utils/utils.dart';

class CompletedBookings extends StatefulWidget {
  @override
  _CompletedBookingsState createState() => _CompletedBookingsState();
}

class _CompletedBookingsState extends State<CompletedBookings> {
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
              'status': 'completed',
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
              title: I18n.of(context).noBookingsText,
              subTitle: I18n.of(context).noCompletedBookingsText,
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
                date: formatDate(booking['date']),
                timeStart: formatTime(booking['time_start']),
                timeEnd: formatTime(booking['time_end']),
                icon: FontAwesomeIcons.calendarAlt,
                status: booking['booking_status'].toUpperCase(),
                color: Colors.blue,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: BookingDetails(
                        id: booking['id'],
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

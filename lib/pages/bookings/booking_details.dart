import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/graphql/bookings.dart';
import 'package:intl/intl.dart';
import 'package:sparring_owner/models/booking_payment_status.dart';
import 'package:sparring_owner/api/client.dart' as midtransClient;

class BookingDetails extends StatelessWidget {
  final int id;

  BookingDetails({
    Key key,
    this.id,
  }) : super(key: key);

  Color getColorStatus(String status) {
    if (status == 'completed') {
      return Colors.green;
    } else if (status == 'upcoming') {
      return Colors.blue;
    }

    return Colors.red;
  }

  Color getColorPayment(String status) {
    if (status == 'settlement') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.blue;
    }

    return Colors.red;
  }

  IconData getIconStatus(String status) {
    if (status == 'completed') {
      return FontAwesomeIcons.solidCalendarCheck;
    } else if (status == 'upcoming') {
      return FontAwesomeIcons.calendarDay;
    }

    return FontAwesomeIcons.solidCalendarTimes;
  }

  IconData getIconPayment(String status) {
    if (status == 'settlement') {
      return FontAwesomeIcons.solidCheckCircle;
    } else if (status == 'pending') {
      return FontAwesomeIcons.solidQuestionCircle;
    }

    return FontAwesomeIcons.solidTimesCircle;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();

    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
          documentNode: gql(getBookingById),
          pollInterval: 10,
          variables: {
            'id': id,
          },
        ),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.loading) {
            return Loading();
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Booking details"),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: result.data['bookings'].length,
              itemBuilder: (context, index) {
                var booking = result.data['bookings'][index];
                var court = result.data['bookings'][index]['court'];
                var img =
                    result.data['bookings'][index]['court']['court_images'][0];
                var user = result.data['bookings'][index]['user'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(500),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(img['name']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                      child: Text(
                        court['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Text(court['address']),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              getIconStatus(booking['booking_status']),
                              color: getColorStatus(booking['booking_status']),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              booking['booking_status'].toUpperCase(),
                              style: TextStyle(
                                color:
                                    getColorStatus(booking['booking_status']),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.yMMMMd('en_US')
                                    .format(DateTime.parse(booking['date']))
                                    .toString()),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 14.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(new DateFormat.Hm()
                                        .format(DateTime.parse(booking['date'] +
                                            ' ' +
                                            booking['time_start']))
                                        .toString() +
                                    " - " +
                                    new DateFormat.Hm()
                                        .format(DateTime.parse(booking['date'] +
                                            ' ' +
                                            booking['time_end']))
                                        .toString()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(height: 10.0, color: Colors.black12),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                      child: Text(
                        'Booking Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Name",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              user['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Phone number",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              user['phone_number'] ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Address",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: Text(
                              user['address'] ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
                      child: Text(
                        'Payment Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    FutureBuilder<BookingPaymentStatus>(
                      future: midtransClient
                          .bookingPaymentStatus(booking['order_id']),
                      builder: (BuildContext context,
                          AsyncSnapshot<BookingPaymentStatus> snapshot) {
                        if (snapshot.hasError) {
                          return Expanded(
                            child: Center(
                              child: Text(snapshot.error.toString()),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        getIconPayment(
                                            snapshot.data.transactionStatus),
                                        color: getColorPayment(
                                            snapshot.data.transactionStatus),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data.transactionStatus
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: getColorPayment(
                                              snapshot.data.transactionStatus),
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Payment Method",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        snapshot.data.paymentType.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 4.0, 16.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Total price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Rp " +
                                            booking['total_price'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

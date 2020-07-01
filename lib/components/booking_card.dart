import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparring_owner/utils/env.dart';

class BookingCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String location;
  final String date;
  final String timeStart;
  final String timeEnd;
  final IconData icon;
  final Color color;
  final String status;
  final GestureTapCallback onTap;

  BookingCard({
    this.imgUrl,
    this.title,
    this.location,
    this.date,
    this.timeStart,
    this.timeEnd,
    this.icon,
    this.color,
    this.status,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0)
        ),
        height: 150,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: FirebaseImage(
                              fbCourtURI + imgUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 2.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: FaIcon(
                              FontAwesomeIcons.calendarAlt,
                              size: 14.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(date),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: FaIcon(
                              FontAwesomeIcons.clock,
                              size: 14.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(timeStart + " - " + timeEnd),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Divider(
                //   height: 2.0,
                //   thickness: 1.0,
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Padding(
                //         padding: EdgeInsets.all(4.0),
                //         child: Icon(
                //           icon,
                //           color: color,
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(4.0),
                //         child: Text(
                //           status,
                //           style: TextStyle(
                //             color: color,
                //             fontStyle: FontStyle.italic
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

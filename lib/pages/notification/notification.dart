import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/components/text_style.dart';
import 'package:sparring_owner/graphql/notification.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/notification/detail_notif.dart';
import 'package:sparring_owner/services/auth.dart';
import 'package:sparring_owner/services/prefs.dart';
import 'package:sparring_owner/utils/utils.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String title = "";
  String body = "";

  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      title = notification.payload.title;
      body = notification.payload.body;
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("On tap");
    });

    _getUserId();
  }

  SharedPreferences sharedPreferences;
  String _userId;

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  _signOut() async {
    await auth.signOut();

    await prefs.clearToken();

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdee4eb),
      appBar: AppBar(
        title: Text(
          I18n.of(context).notification,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
            documentNode: gql(getOwner),
            pollInterval: 10,
            variables: {
              'id': _userId,
            },
          ),
          builder: (QueryResult result,
              {FetchMore fetchMore, VoidCallback refetch}) {
            if (result.loading) {
              return Loading();
            }

            if (result.exception.toString().contains('Could not verify JWT') ||
                result.exception.toString().contains(
                    'ClientException: Unhandled Failure Invalid argument(s)')) {
              _signOut();
              return Flushbar(
                message: "Your session is over. Please login again.",
                margin: EdgeInsets.all(8),
                borderRadius: 8,
                duration: Duration(seconds: 2),
              )..show(context);
            }

            if (result.hasException) {
              return Center(
                child: Text(result.exception.toString()),
              );
            }

            var owner = result.data['owners'];

            return owner.length == 0
                ? Loading()
                : Query(
                    options: QueryOptions(
                      documentNode: gql(getNotif),
                      pollInterval: 1,
                      variables: {
                        'user_id': _userId,
                        'created_at': owner[0]['created_at']
                      },
                    ),
                    builder: (QueryResult result,
                        {FetchMore fetchMore, VoidCallback refetch}) {
                      if (result.loading) {
                        return Loading();
                      }

                      if (result.hasException) {
                        return Center(
                          child: Text(result.exception.toString()),
                        );
                      }

                      var itemLength = result.data['notifications'];

                      return ListView.builder(
                        itemCount: itemLength.length,
                        itemBuilder: (context, index) {
                          var notif = itemLength[index];

                          return SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 4.0),
                              child: Container(
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _notifCard(
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: DetailNotif(
                                        title: notif['title'],
                                        content: notif['content'],
                                        date: notif['created_at'],
                                      ),
                                      withNavBar: false,
                                    );
                                  },
                                  title: notif['title'],
                                  content: notif['content'],
                                  date: notif['created_at'],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _notifCard({
    String title,
    String content,
    String date,
    GestureTapCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              NormalText(
                text: content,
                color: Colors.grey,
                size: 14,
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(),
                  Text(
                    formatDate(date),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

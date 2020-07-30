import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/components/text_style.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/more/about.dart';
import 'package:sparring_owner/pages/more/court/court.dart';
import 'package:sparring_owner/pages/more/profile.dart';
import 'package:sparring_owner/services/auth.dart';
import 'package:sparring_owner/services/auth_check.dart';
import 'package:sparring_owner/services/prefs.dart';

class More extends StatefulWidget {
  More({
    Key key,
  }) : super(key: key);
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  SharedPreferences sharedPreferences;
  String _userId;

  _signOut() async {
    await auth.signOut();

    await prefs.clearToken();

    pushNewScreen(
      context,
      screen: AuthCheck(),
      platformSpecific: false,
      withNavBar: false,
    );
  }

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
    return _userId == null
        ? Loading()
        : GraphQLProvider(
            client: API.client,
            child: Query(
              options: QueryOptions(
                documentNode: gql(getOwner),
                //pollInterval: 10,
                variables: {
                  'id': _userId,
                },
              ),
              builder: (QueryResult result,
                  {FetchMore fetchMore, VoidCallback refetch}) {
                if (result.loading) {
                  return Loading();
                }

                if (result.exception
                    .toString()
                    .contains('Could not verify JWT')) {
                  return _signOut();
                }

                if (result.exception.toString().contains(
                    'ClientException: Unhandled Failure Invalid argument(s)')) {
                  return _signOut();
                }

                if (result.hasException) {
                  print(result.exception.toString());
                  return Center(
                    child: Text(result.exception.toString()),
                  );
                }

                var owner = result.data['owners'][0];

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text(
                      I18n.of(context).account,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 21.0,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                child: owner["profile_picture"] == null
                                    ? Image.asset('assets/img/pp.png')
                                    : Image.network(owner["profile_picture"]),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    BoldText(
                                        text: owner["name"],
                                        size: 20.0,
                                        color: Colors.black),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Theme.of(context).primaryColor,
                                          size: 15.0,
                                        ),
                                        NormalText(
                                          text: owner["address"] == null
                                              ? "-"
                                              : owner["address"],
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        _profileItem(
                          icon: FontAwesomeIcons.userAlt,
                          text: I18n.of(context).myInfoText,
                          onTap: () {
                            print('my info');
                            pushNewScreen(
                              context,
                              screen: Profile(
                                userId: _userId,
                                sex: owner['sex'],
                              ),
                              platformSpecific: true,
                              withNavBar: false,
                            );
                          },
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        _profileItem(
                            icon: FontAwesomeIcons.futbol,
                            text: I18n.of(context).myCourt,
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: Court(
                                  accountStatus: owner['account_status'],
                                ),
                                platformSpecific: true,
                                withNavBar: false,
                              );
                            }),
                        SizedBox(
                          height: 5.0,
                        ),
                        _profileItem(
                            icon: FontAwesomeIcons.infoCircle,
                            text: "About Us ",
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: AboutUs(),
                                platformSpecific: false,
                                withNavBar: false,
                              );
                            }),
                        SizedBox(
                          height: 5.0,
                        ),
                        _profileItem(
                          icon: FontAwesomeIcons.signOutAlt,
                          text: I18n.of(context).logoutText,
                          onTap: () async {
                            final auth = new Auth();
                            await auth.signOut();

                            await prefs.clearToken();

                            pushNewScreen(
                              context,
                              screen: AuthCheck(),
                              platformSpecific: false,
                              withNavBar: false,
                            );

                            OneSignal.shared.removeExternalUserId();

                            Flushbar(
                              message: I18n.of(context).logoutSuccessText,
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                              duration: Duration(seconds: 4),
                            )..show(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

Widget _profileItem({IconData icon, String text, GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 16, bottom: 6, top: 6),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Color(0xffff8964),
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          NormalText(
            text: text,
            color: Colors.black,
            size: 20.0,
          )
        ],
      ),
    ),
  );
}

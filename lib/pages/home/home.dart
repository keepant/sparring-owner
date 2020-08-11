import 'package:firebase_image/firebase_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/components/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/home/verification.dart';
import 'package:sparring_owner/pages/more/court/add_court.dart';
import 'package:sparring_owner/pages/more/court/court.dart';
import 'package:sparring_owner/services/auth.dart';
import 'package:sparring_owner/services/auth_check.dart';
import 'package:sparring_owner/services/prefs.dart';
import 'package:sparring_owner/utils/env.dart';
import 'package:sparring_owner/utils/utils.dart';

class IconColors {
  static const Color send = Color(0xffecfaf8);
  static const Color transfer = Color(0xfffdeef5);
  static const Color passbook = Color(0xfffff4eb);
  static const Color more = Color(0xffeff1fe);
}

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Color getColorStatus(String status) {
    if (status == 'verified') {
      return Colors.green;
    } else if (status == 'process') {
      return Colors.blue;
    }

    return Colors.red[700];
  }

  IconData getIconStatus(String status) {
    if (status == 'verified') {
      return FontAwesomeIcons.solidCheckCircle;
    } else if (status == 'process') {
      return FontAwesomeIcons.tasks;
    }

    return FontAwesomeIcons.solidTimesCircle;
  }

  String getStatus(String status) {
    if (status == 'verified') {
      return "Verified";
    } else if (status == 'process') {
      return "On process";
    }

    return "Not verified";
  }

  _signOut() async {
    await auth.signOut();

    await prefs.clearToken();

    Navigator.pushReplacementNamed(context, '/login');
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
                  pollInterval: 1,
                  variables: {
                    'id': _userId,
                  }),
              builder: (QueryResult result,
                  {FetchMore fetchMore, VoidCallback refetch}) {
                if (result.loading) {
                  return Loading();
                }

                if (result.exception
                        .toString()
                        .contains('Could not verify JWT') ||
                    result.exception.toString().contains(
                        'ClientException: Unhandled Failure Invalid argument(s)')) {
                  _signOut();
                  return Loading();
                }

                if (result.hasException) {
                  return Center(
                    child: Text(result.exception.toString()),
                  );
                }

                var owner = result.data['owners'][0];

                return Scaffold(
                  backgroundColor: Color(0xffdee4eb),
                  appBar: AppBar(
                    title: Text(
                      "Home",
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
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.grey[300],
                                spreadRadius: 5.0,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(51),
                              bottomLeft: Radius.circular(51),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 35.0),
                                    child: BoldText(
                                      text: "Hi, \n" + owner['name'],
                                      size: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35.0),
                                    child: VerificationBadge(
                                      text: getStatus(owner['account_status']),
                                      color: getColorStatus(
                                          owner['account_status']),
                                      icon: getIconStatus(
                                          owner['account_status']),
                                      onTap: () async {
                                        await prefs.setDocsId(owner['docs_id']);

                                        showCupertinoModalBottomSheet(
                                          expand: true,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder:
                                              (context, scrollController) =>
                                                  Verification(
                                            status: owner['account_status'],
                                            scrollController: scrollController,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  child: Query(
                                    options: QueryOptions(
                                        documentNode: gql(getTotalIncome),
                                        pollInterval: 5,
                                        variables: {
                                          'id': _userId,
                                        }),
                                    builder: (QueryResult result,
                                        {FetchMore fetchMore,
                                        VoidCallback refetch}) {
                                      if (result.loading) {
                                        return Shimmer.fromColors(
                                          highlightColor: Colors.grey[100],
                                          baseColor: Colors.grey[300],
                                          child: Container(
                                            height: 86,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.fromLTRB(
                                                31, 21, 31, 41),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }

                                      if (result.hasException) {
                                        return Center(
                                          child:
                                              Text(result.exception.toString()),
                                        );
                                      }

                                      var income = 0;
                                      var length = result
                                          .data['owners'][0]['courts'].length;

                                      for (var i = 0; i < length; i++) {
                                        var cos = result.data['owners'][0]
                                                    ['courts'][i]
                                                ['bookings_aggregate']
                                            ['aggregate']['sum']['total_price'];

                                        if (cos != null) {
                                          income += result.data['owners'][0]
                                                          ['courts'][i]
                                                      ['bookings_aggregate']
                                                  ['aggregate']['sum']
                                              ['total_price'];
                                        }
                                      }

                                      //print("income: " + income.toString());

                                      return CardContainer(
                                        caption: I18n.of(context).totalIncome,
                                        label: formatCurrency(income),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Query(
                                options: QueryOptions(
                                    documentNode: gql(getCountCourt),
                                    pollInterval: 5,
                                    variables: {
                                      'id': _userId,
                                    }),
                                builder: (QueryResult result,
                                    {FetchMore fetchMore,
                                    VoidCallback refetch}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Text(result.exception.toString()),
                                    );
                                  }

                                  if (result.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }

                                  var totalCourt = result.data['owners'][0]
                                          ['courts_aggregate']['aggregate']
                                      ['count'];

                                  return CustomIconButton(
                                    circleColor: IconColors.send,
                                    txt: totalCourt.toString(),
                                    buttonTitle: I18n.of(context).court,
                                    onTap: () async {
                                      // await prefs.setDocsId(owner['docs_id']);
                                      // owner['account_status'] != "verified"
                                      //     ? showCupertinoModalBottomSheet(
                                      //         expand: true,
                                      //         context: context,
                                      //         backgroundColor:
                                      //             Colors.transparent,
                                      //         builder:
                                      //             (context, scrollController) =>
                                      //                 Verification(
                                      //           status: owner['account_status'],
                                      //           scrollController:
                                      //               scrollController,
                                      //         ),
                                      //       )
                                      //     : pushNewScreen(
                                      //         context,
                                      //         screen: Court(),
                                      //         withNavBar: false,
                                      //       );
                                    },
                                  );
                                },
                              ),
                              Query(
                                options: QueryOptions(
                                    documentNode:
                                        gql(getCountBookingsBaseOnStatus),
                                    pollInterval: 5,
                                    variables: {
                                      'id': _userId,
                                      'status': 'upcoming',
                                    }),
                                builder: (QueryResult result,
                                    {FetchMore fetchMore,
                                    VoidCallback refetch}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Text(result.exception.toString()),
                                    );
                                  }

                                  if (result.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }

                                  var status = result.data['bookings_aggregate']
                                      ['aggregate']['count'];

                                  return CustomIconButton(
                                    circleColor: IconColors.passbook,
                                    txt: status.toString(),
                                    buttonTitle: I18n.of(context).upcomingText,
                                    onTap: () {},
                                  );
                                },
                              ),
                              Query(
                                options: QueryOptions(
                                    documentNode:
                                        gql(getCountBookingsBaseOnStatus),
                                    pollInterval: 5,
                                    variables: {
                                      'id': _userId,
                                      'status': 'completed',
                                    }),
                                builder: (QueryResult result,
                                    {FetchMore fetchMore,
                                    VoidCallback refetch}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Text(result.exception.toString()),
                                    );
                                  }

                                  if (result.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }

                                  var status = result.data['bookings_aggregate']
                                      ['aggregate']['count'];

                                  return CustomIconButton(
                                    circleColor: IconColors.more,
                                    txt: status.toString(),
                                    buttonTitle: I18n.of(context).completedText,
                                    onTap: () {},
                                  );
                                },
                              ),
                              Query(
                                options: QueryOptions(
                                    documentNode: gql(getCountBookings),
                                    pollInterval: 5,
                                    variables: {
                                      'id': _userId,
                                    }),
                                builder: (QueryResult result,
                                    {FetchMore fetchMore,
                                    VoidCallback refetch}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Text(result.exception.toString()),
                                    );
                                  }

                                  if (result.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }

                                  var totalBookings = 0;
                                  var length =
                                      result.data['owners'][0]['courts'].length;

                                  for (var i = 0; i < length; i++) {
                                    var sum = result.data['owners'][0]['courts']
                                            [i]['bookings_aggregate']
                                        ['aggregate']['count'];

                                    if (sum != null) {
                                      totalBookings += result.data['owners'][0]
                                                  ['courts'][i]
                                              ['bookings_aggregate']
                                          ['aggregate']['count'];
                                    }
                                  }

                                  return CustomIconButton(
                                    circleColor: IconColors.transfer,
                                    txt: totalBookings.toString(),
                                    buttonTitle: I18n.of(context).bookings,
                                    onTap: () {},
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    I18n.of(context).yourCourt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  CustomRoundedButton(
                                    buttonText: I18n.of(context).more,
                                    color: Colors.blue,
                                    onTap: () async {
                                      await prefs.setDocsId(owner['docs_id']);
                                      owner['account_status'] != "verified"
                                          ? showCupertinoModalBottomSheet(
                                              expand: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder:
                                                  (context, scrollController) =>
                                                      Verification(
                                                status: owner['account_status'],
                                                scrollController:
                                                    scrollController,
                                              ),
                                            )
                                          : pushNewScreen(
                                              context,
                                              screen: Court(),
                                              withNavBar: false,
                                            );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Query(
                                options: QueryOptions(
                                    documentNode: gql(getOwnerCourt),
                                    pollInterval: 5,
                                    variables: {
                                      'id': _userId,
                                    }),
                                builder: (QueryResult result,
                                    {FetchMore fetchMore,
                                    VoidCallback refetch}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Text(result.exception.toString()),
                                    );
                                  }

                                  if (result.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Container(
                                              height: 14,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                            isThreeLine: true,
                                            leading: Container(
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }

                                  var courtList =
                                      result.data['owners'][0]['courts'];

                                  return courtList.length < 1
                                      ? EmptyCourt(onTap: () async {
                                          await prefs
                                              .setDocsId(owner['docs_id']);
                                          owner['account_status'] != "verified"
                                              ? showCupertinoModalBottomSheet(
                                                  expand: true,
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context,
                                                          scrollController) =>
                                                      Verification(
                                                    status:
                                                        owner['account_status'],
                                                    scrollController:
                                                        scrollController,
                                                  ),
                                                )
                                              : pushNewScreen(
                                                  context,
                                                  screen: AddCourt(),
                                                  withNavBar: false,
                                                );
                                        })
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: courtList.length,
                                          itemBuilder: (context, index) {
                                            var court = courtList[index];
                                            var img = courtList[index]
                                                ['court_images'][0];

                                            return CourtListTile(
                                              title: court['name'],
                                              address: court['address'],
                                              img: img['name'],
                                            );
                                          },
                                        );
                                },
                              )
                            ],
                          ),
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

class CourtListTile extends StatelessWidget {
  final Color iconColor;
  final String title, address;
  final GestureTapCallback onTap;
  final String img;

  const CourtListTile({
    Key key,
    this.iconColor,
    this.title,
    this.address,
    this.onTap,
    this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        subtitle: Text(address),
        isThreeLine: true,
        leading: Container(
          width: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FirebaseImage(
                fbCourtURI + img,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        enabled: true,
        onTap: onTap,
      ),
    );
  }
}

class EmptyCourt extends StatelessWidget {
  final GestureTapCallback onTap;

  const EmptyCourt({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(I18n.of(context).dontHaveCourtText),
        subtitle: Text(I18n.of(context).pleaseAddCourt),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              FontAwesomeIcons.plus,
              //color: Theme.of(context).primaryColor,
              size: 25,
            ),
          ),
        ),
        enabled: true,
      ),
    );
  }
}

class CustomRoundedButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final GestureTapCallback onTap;
  CustomRoundedButton({
    @required this.color,
    @required this.buttonText,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            I18n.of(context).more,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  final Color color;
  final String text;
  final GestureTapCallback onTap;
  final IconData icon;

  VerificationBadge({
    @required this.color,
    @required this.text,
    @required this.onTap,
    @required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(icon, color: Colors.white),
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String buttonTitle, txt;
  final GestureTapCallback onTap;
  final Color circleColor;
  const CustomIconButton({
    @required this.circleColor,
    @required this.buttonTitle,
    @required this.txt,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundColor: circleColor,
                child: Text(txt),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                buttonTitle,
                overflow: TextOverflow.clip,
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final String label;
  final String caption;

  const CardContainer({
    Key key,
    this.label,
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(31, 21, 31, 41),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.red[200],
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [
            Color(0xffff8964),
            Color(0xffff5d6e),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(),
            Text(
              caption,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  CustomContainer({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[300],
            spreadRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.circular(41),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

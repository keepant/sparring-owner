import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/components/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/pages/home/verification.dart';
import 'package:sparring_owner/services/auth.dart';
import 'package:sparring_owner/services/auth_check.dart';
import 'package:sparring_owner/services/prefs.dart';

class IconColors {
  static const Color send = Color(0xffecfaf8);
  static const Color transfer = Color(0xfffdeef5);
  static const Color passbook = Color(0xfffff4eb);
  static const Color more = Color(0xffeff1fe);
}

class Home extends StatefulWidget {
  final String userID;
  final String name;

  Home({
    Key key,
    this.userID,
    this.name,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  String getStatus (String status) {
    if (status == 'verified') {
      return "Verified";
    } else if (status == 'process') {
      return "On process";
    }

    return "Not verified";
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getOwner),
            pollInterval: 1,
            variables: {
              'id': "sRqSjUusf1fi521PgR9qMZvSti12",
            }),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 35.0),
                              child: BoldText(
                                text: "Hi, \n" + owner['name'],
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35.0),
                              child: VerificationBadge(
                                text: getStatus(owner['account_status']),
                                color: getColorStatus(owner['account_status']),
                                icon: getIconStatus(owner['account_status']),
                                onTap: () {
                                  showCupertinoModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context, scrollController) =>
                                        Verification(
                                      status: 'not',
                                      scrollController: scrollController,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag: "card",
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: CardContainer(),
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
                        CustomIconButton(
                          circleColor: IconColors.send,
                          txt: "2",
                          buttonTitle: "Court",
                          onTap: () {},
                        ),
                        CustomIconButton(
                          circleColor: IconColors.transfer,
                          txt: "3",
                          buttonTitle: "Completed Booking",
                          onTap: () {},
                        ),
                        CustomIconButton(
                          circleColor: IconColors.passbook,
                          txt: "5",
                          buttonTitle: "Upcoming Booking",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Your court",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            CustomRoundedButton(
                              buttonText: "More",
                              color: Colors.blue,
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        // EmptyCourt(
                        //   title: "You don\'t have any court yet",
                        //   subtitle: "Please add to see your court here",
                        //   onTap: () {
                        //     print("add court");
                        //   },
                        // )
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            CourtListTile(
                              iconColor: IconColors.transfer,
                              onTap: () {},
                              title: "Lapangan Laris Manis",
                              address: "Karanganyar",
                            ),
                            CourtListTile(
                              iconColor: IconColors.transfer,
                              onTap: () {},
                              title: "Cybdom Lapangan Laris Manis",
                              address: "Surakarta",
                            ),
                            CourtListTile(
                              iconColor: IconColors.send,
                              onTap: () {},
                              title: "Lapangan Laris Manis II",
                              address: "Klaten",
                            ),
                          ],
                        ),
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
  const CourtListTile({
    Key key,
    this.iconColor,
    this.title,
    this.address,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        subtitle: Text(address),
        isThreeLine: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            'https://adhyasta.com/assets/images/3-lapangan-futsal.jpg',
          ),
        ),
        enabled: true,
        onTap: onTap,
      ),
    );
  }
}

class EmptyCourt extends StatelessWidget {
  final Color iconColor;
  final String title, subtitle;
  final GestureTapCallback onTap;

  const EmptyCourt({
    Key key,
    this.iconColor,
    this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
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
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            "More",
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
  const CardContainer({
    Key key,
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
              "Summary",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              "Rp. 3.000.000,00",
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

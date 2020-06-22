import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/pages/home/home.dart';
import 'package:sparring_owner/pages/home/verification/get_start.dart';

class Verification extends StatelessWidget {
  final ScrollController scrollController;
  final String status;

  Verification({
    Key key,
    this.scrollController,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: Text("Account status"),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              pushNewScreen(
                context,
                screen: Home(),
                platformSpecific: false,
                withNavBar: true,
              );
            },
          ),
        ),
        child: status == 'verified'
            ? VerificationStatus(
                img: "assets/img/verified-account.png",
                title: "Horray your account is verified!",
                icon: FontAwesomeIcons.solidCheckCircle,
                color: Colors.green,
                isVerified: true,
                subtitle:
                    "Now you can using full feature of our app. Take a adventure of it!",
              )
            : status == 'process'
                ? VerificationStatus(
                    img: "assets/img/onprocess.png",
                    title: "Yeeyy your account under review!",
                    icon: FontAwesomeIcons.history,
                    color: Colors.blue,
                    isVerified: true,
                    subtitle:
                        "Please wait our team to verify your information. It'\s takes 1-3 work days.",
                  )
                : VerificationStatus(
                    img: "assets/img/not-verified.png",
                    title: "Oh no! Your account not verified yet!",
                    icon: FontAwesomeIcons.solidTimesCircle,
                    color: Colors.red,
                    subtitle: "Verify now to freely access our feature!",
                  ),
      ),
    );
  }
}

class VerificationStatus extends StatelessWidget {
  final String img;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isVerified;

  VerificationStatus({
    Key key,
    @required this.img,
    @required this.subtitle,
    @required this.title,
    @required this.icon,
    @required this.color,
    this.isVerified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xfff1eefc),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          icon,
                          color: color,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, height: 1.6),
                    ),
                  ),
                  isVerified == false
                      ? Container(
                          padding: EdgeInsets.only(top: 20, bottom: 50.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  width: size.width - 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(180.0),
                                  ),
                                  child: Text(
                                    "Verify now!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  pushNewScreen(
                                    context,
                                    screen: GetStart(),
                                    withNavBar: false,
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

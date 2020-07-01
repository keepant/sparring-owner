import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/court_card.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/pages/more/court/add_court.dart';

class Court extends StatefulWidget {
  final String accountStatus;

  Court({
    Key key,
    this.accountStatus,
  }) : super(key: key);

  @override
  _CourtState createState() => _CourtState();
}

class _CourtState extends State<Court> {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Court",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              pushNewScreen(
                context,
                screen: AddCourt(),
                withNavBar: false,
              );
            },
            icon: widget.accountStatus != "verified"
                ? Container()
                : Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
          )
        ],
      ),
      body: GraphQLProvider(
        client: API.client,
        child: Query(
          options: QueryOptions(
              documentNode: gql(getOwnerCourt),
              pollInterval: 5,
              variables: {
                'id': _userId,
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

            var courtList = result.data['owners'][0]['courts'];

            return _userId == null
                ? Loading()
                : widget.accountStatus != "verified"
                    ? VerificationStatus(
                        img: "assets/img/not-verified.png",
                        title: "Account not yet verified!",
                        icon: FontAwesomeIcons.solidTimesCircle,
                        color: Colors.red,
                        subtitle: "Verify now to add court!",
                      )
                    : courtList.length < 1
                        ? emptyCourt()
                        : Container(
                            height: size.height,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Color(0xfff1eefc),
                            ),
                            child: SafeArea(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: courtList.length,
                                itemBuilder: (context, index) {
                                  var court = courtList[index];
                                  var img = courtList[index]['court_images'][0];
                                  return CourtCard(
                                    onTap: () {},
                                    imgUrl: img['name'],
                                    title: court['name'],
                                    location: court['address'],
                                  );
                                },
                              ),
                            ),
                          );
          },
        ),
      ),
    );
  }

  Widget emptyCourt() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xfff1eefc),
      ),
      child: SafeArea(
        child: Center(
          child: Container(
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
                      image: AssetImage("assets/img/field.png"),
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
                        "You don\'t have any court yet!",
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
                        FontAwesomeIcons.solidTimesCircle,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    "Add your court to manage",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, height: 1.6),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 50.0),
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
                            "Add court now!",
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
                            screen: AddCourt(),
                            withNavBar: false,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

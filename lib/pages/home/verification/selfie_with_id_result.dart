import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/pages/home/home.dart';

class SelfieWithIDResult extends StatefulWidget {
  final String imagePath;

  SelfieWithIDResult({
    Key key,
    this.imagePath,
  }) : super(key: key);

  @override
  _SelfieWithIDResultState createState() => _SelfieWithIDResultState();
}

class _SelfieWithIDResultState extends State<SelfieWithIDResult> {
  bool popup = false;

  showPopup() {
    setState(() {
      this.popup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xfff1eefc),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios, size: 20.0),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Step 3/3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        Icon(Icons.arrow_back_ios,
                            size: 20.0, color: Color(0xfff1eefc)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "Result your selfie with ID",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: size.width - 50.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                    decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width - 90.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 13.0),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10.0),
                          //   border: Border.all(color: Colors.black12),
                          // ),
                          child: Container(
                            width: size.width - 210,
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            margin: EdgeInsets.only(top: 30.0),
                            width: size.width - 90.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(180.0),
                            ),
                            child: Text(
                              "Finish",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          onTap: () {
                            this.showPopup();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          (this.popup)
              ? Container(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  width: size.width,
                  height: size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 189.0, horizontal: 30.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/img/success.png"),
                            fit: BoxFit.fill,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            "Congratulations",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Now you are registered",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 40.0),
                          child: Center(
                            child: Text(
                              "Please wait our admin to verify your information. It'\s takes 1-3 work days.",
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            margin: EdgeInsets.only(top: 30.0),
                            width: size.width - 90.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(180.0),
                            ),
                            child: Text(
                              "Ok, I got it",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff)),
                            ),
                          ),
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: Home(),
                              platformSpecific: false,
                              withNavBar: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

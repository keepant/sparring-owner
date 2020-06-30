import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/graphql/verify.dart';
import 'package:sparring_owner/pages/home/verification/take_selfie.dart';
import 'package:sparring_owner/services/prefs.dart';

class IDCardResult extends StatefulWidget {
  final String imagePath;

  IDCardResult({
    Key key,
    this.imagePath,
  }) : super(key: key);

  @override
  _IDCardResultState createState() => _IDCardResultState();
}

class _IDCardResultState extends State<IDCardResult> {
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

  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: 'gs://sparring-b92ed.appspot.com/',
  );
  StorageUploadTask uploadTask;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
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
                      "Step 1/3",
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
                  "Your ID Card",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: size.width - 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                    GraphQLProvider(
                      client: API.client,
                      child: Mutation(
                        options: MutationOptions(
                          documentNode: gql(updateIdCard),
                          update: (Cache cache, QueryResult result) {
                            return cache;
                          },
                          onCompleted: (dynamic resultData) {
                            print(resultData);
                            // Flushbar(
                            //   message: "ID Card saved!",
                            //   margin: EdgeInsets.all(8),
                            //   borderRadius: 8,
                            //   duration: Duration(seconds: 2),
                            // )..show(context);
                          },
                          onError: (error) => print(error),
                        ),
                        builder: (RunMutation runMutation, QueryResult result) {
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              margin: EdgeInsets.only(top: 30.0),
                              width: size.width - 90.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(180.0),
                              ),
                              child: Text(
                                "Save and continue",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                            onTap: () async {
                              String fileName =
                                  "$_userId-idCard-${DateTime.now()}.png";
                              String filePath = 'verify/$fileName';

                              runMutation({
                                'id': await prefs.getDocsId(),
                                'file': fileName,
                              });

                              setState(() {
                                uploadTask = _storage
                                    .ref()
                                    .child(filePath)
                                    .putFile(File(widget.imagePath));
                              });

                              pushNewScreen(
                                context,
                                screen: TakeSelfie(),
                                platformSpecific: false,
                                withNavBar: false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

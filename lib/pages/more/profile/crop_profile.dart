import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/more/profile/profile.dart';
import 'package:sparring_owner/utils/env.dart';

class CropProfile extends StatefulWidget {
  final String file;
  final String name;
  final String id;
  final String gender;

  CropProfile({
    Key key,
    this.file,
    this.name,
    this.id,
    this.gender,
  }) : super(key: key);

  @override
  _CropProfileState createState() => _CropProfileState();
}

class _CropProfileState extends State<CropProfile> {
  final cropKey = GlobalKey<ImgCropState>();

  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: fbStorageURI,
  );

  StorageUploadTask uploadTask;

  @override
  Widget build(BuildContext context) {
    print(widget.file);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: widget.file != null
          ? Center(
              child: ImgCrop(
                chipShape: 'circle',
                chipRadius: 150,
                key: cropKey,
                maximumScale: 3,
                image: FileImage(File(widget.file)),
              ),
            )
          : Container(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: GraphQLProvider(
          client: API.client,
          child: Mutation(
            options: MutationOptions(
              documentNode: gql(updateProfilePicture),
              onCompleted: (dynamic resultData) {
                print(resultData);

                pushNewScreen(
                  context,
                  screen: Profile(
                    userId: widget.id,
                    sex: widget.gender,
                  ),
                  withNavBar: false,
                );

                Flushbar(
                  message: I18n.of(context).dataSavedText,
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 2),
                )..show(context);
              },
              onError: (error) => print(error),
            ),
            builder: (RunMutation runMutation, QueryResult result) {
              return RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  I18n.of(context).saveText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  final crop = cropKey.currentState;
                  final croppedFile = await crop.cropCompleted(
                    File(widget.file),
                    pictureQuality: 900,
                  );

                  String name = widget.name;
                  String fileName = "$name-profile-${DateTime.now()}.png";
                  String imgTrim = fileName.replaceAll(" ", "");
                  String logoPath = 'profile/$imgTrim';

                  runMutation({
                    'profile_picture': imgTrim,
                    'id': widget.id,
                  });

                  setState(() {
                    uploadTask =
                        _storage.ref().child(logoPath).putFile(croppedFile);
                  });

                  print("new pp: $imgTrim");
                  Flushbar(
                    message: I18n.of(context).saveText,
                    showProgressIndicator: true,
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                  )..show(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/pages/home/home.dart';
import 'package:sparring_owner/pages/home/verification/take_id.dart';

class Verification extends StatefulWidget {
  final ScrollController scrollController;
  final String imagePath;

  Verification({Key key, this.scrollController, this.imagePath})
      : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _idCardTxt = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: Text("Verify your account"),
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
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                "Please fill the following information to verify your account",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: EditView(
                  label: "ID card number (KTP)",
                  textEditingController: _idCardTxt,
                  keyboardType: TextInputType.number,
                  hintText: "ID card number ex. 3318261923172",
                  warningText: "ID card number cannot be empty!",
                ),
              ),
            ),
            widget.imagePath == ""
                ? RaisedButton(
                    child: Text("Take ID"),
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: TakeID(),
                        platformSpecific: false,
                        withNavBar: false,
                      );
                    },
                  )
                : Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        )),
      ),
    );
  }
}

class EditView extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final String warningText;
  final TextInputType keyboardType;

  EditView({
    @required this.label,
    this.hintText,
    this.textEditingController,
    this.warningText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextFormField(
            controller: textEditingController,
            keyboardType: keyboardType,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            validator: (value) => value.isEmpty ? warningText : null,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

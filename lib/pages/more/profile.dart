import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _emailTxt = new TextEditingController();
  final TextEditingController _phoneTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _picked = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 8.0),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://toppng.com/uploads/preview/happy-person-11545688398rslqmyfw4g.png'),
                ),
              ),
            ),
            EditView(
              label: "Name",
              textEditingController: _nameTxt,
              keyboardType: TextInputType.text,
              hintText: "Full name",
              warningText: "Name cannot be empty!",
            ),
            EditView(
              label: "Email",
              textEditingController: _emailTxt,
              keyboardType: TextInputType.emailAddress,
              hintText: "Email",
              warningText: "Email cannot be empty!",
            ),
            _radioBtn(),
            EditView(
              label: "Phone number",
              textEditingController: _phoneTxt,
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              warningText: "Phone number cannot be empty!",
            ),
            EditView(
              label: "Address",
              textEditingController: _addressTxt,
              keyboardType: TextInputType.text,
              hintText: "Address",
              warningText: "Address cannot be empty!",
            ),
            FieldView(
              label: "Joined",
              text: "20 Juni 2020",
              useDivider: false,
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              onPressed: () {
                print("name: " +
                    _nameTxt.text +
                    "\nemail: " +
                    _emailTxt.text +
                    "\nsex: " +
                    _picked +
                    "\nphone number: " +
                    _phoneTxt.text +
                    "\naddress: " +
                    _addressTxt.text);

                if (_formKey.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  Flushbar(
                    message: "Saving changes..",
                    showProgressIndicator: true,
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                  )..show(context);
                }
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _radioBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("Sex"),
        ),
        RadioButtonGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          onSelected: (String selected) => setState(() {
            _picked = selected;
          }),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          activeColor: Theme.of(context).primaryColor,
          labels: <String>[
            "Laki-laki",
            "Perempuan",
          ],
          picked: _picked,
          itemBuilder: (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
        ),
      ],
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

class FieldView extends StatelessWidget {
  final String label;
  final String text;
  final bool useDivider;

  FieldView({
    @required this.label,
    @required this.text,
    this.useDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: Text(label),
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        useDivider ? Divider() : Container(),
      ],
    );
  }
}

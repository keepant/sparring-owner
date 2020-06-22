import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class AddCourt extends StatefulWidget {
  @override
  _AddCourtState createState() => _AddCourtState();
}

class _AddCourtState extends State<AddCourt> {
  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _openHourTxt = new TextEditingController();
  final TextEditingController _closedHourTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();
  final TextEditingController _openDayTxt = new TextEditingController();
  final TextEditingController _closedDayTxt = new TextEditingController();
  final TextEditingController _priceTxt = new TextEditingController();
  final TextEditingController _latitudeTxt = new TextEditingController();
  final TextEditingController _longitudeTxt = new TextEditingController();
  final TextEditingController _phoneTxt = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add court",
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
            EditView(
              label: "Name",
              textEditingController: _nameTxt,
              keyboardType: TextInputType.text,
              hintText: "Futsal court name",
              warningText: "Name cannot be empty!",
            ),
            EditView(
              label: "Address",
              textEditingController: _addressTxt,
              keyboardType: TextInputType.text,
              hintText: "Address futsal court",
              warningText: "Address cannot be empty!",
            ),
            EditView(
              label: "Phone number",
              textEditingController: _phoneTxt,
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              warningText: "Phone number cannot be empty!",
            ),
            EditView(
              label: "Open day",
              textEditingController: _openDayTxt,
              keyboardType: TextInputType.text,
              hintText: "Open day",
              warningText: "Open day cannot be empty!",
            ),
            EditView(
              label: "Closed day",
              textEditingController: _closedDayTxt,
              keyboardType: TextInputType.text,
              hintText: "Closed day",
              warningText: "Closed day cannot be empty!",
            ),
            EditView(
              label: "Open hour",
              textEditingController: _openHourTxt,
              keyboardType: TextInputType.text,
              hintText: "Open hour",
              warningText: "Price cannot be empty!",
            ),
            EditView(
              label: "Closed hour",
              textEditingController: _closedHourTxt,
              keyboardType: TextInputType.text,
              hintText: "Closed hour",
              warningText: "Closed hour cannot be empty!",
            ),
            EditView(
              label: "Price per hour",
              textEditingController: _priceTxt,
              keyboardType: TextInputType.number,
              hintText: "Price per hour",
              warningText: "Price cannot be empty!",
            ),
            EditView(
              label: "Latitude",
              textEditingController: _latitudeTxt,
              keyboardType: TextInputType.number,
              hintText: "Latitude location futsal court",
              warningText: "Latitude cannot be empty!",
            ),
            EditView(
              label: "Longtitude",
              textEditingController: _longitudeTxt,
              keyboardType: TextInputType.number,
              hintText: "Longtitude location futsal court",
              warningText: "Longtitude cannot be empty!",
            ),
            
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              onPressed: () {
                print("name: " +
                    _nameTxt.text +
                    "\naddress: " +
                    _addressTxt.text +
                    "\nprice: " +
                    _priceTxt.text +
                    "\nphone number: " +
                    _phoneTxt.text +
                    "\nopen hour: " +
                    _openHourTxt.text +
                    "\nclosed hour: " +
                    _closedHourTxt.text +
                    "\nopen day: " +
                    _openDayTxt.text +
                    "\nclosed Day: " +
                    _closedDayTxt.text +
                    "\nlatitude: " +
                    _latitudeTxt.text +
                    "\nlongtitude: " +
                    _longitudeTxt.text 
                  );

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
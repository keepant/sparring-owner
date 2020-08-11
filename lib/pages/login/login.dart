import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring_owner/components/bezier.dart';
import 'package:sparring_owner/i18n.dart';
import 'package:sparring_owner/pages/login/register.dart';
import 'package:sparring_owner/pages/root.dart';
import 'package:sparring_owner/services/auth.dart';
import 'package:sparring_owner/services/prefs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwdControl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _formWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      // child: Text('Forgot Password ?',
                      //     style: TextStyle(
                      //         fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    // divider(),
                    //SizedBox(height: 20),
                    //_facebookButton(),
                    // googleButton(),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            //Positioned(top: 35, left: 0, child: backButton()),
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text(
              I18n.of(context).back,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller, {
    bool isPassword = false,
    String hint = "",
    TextInputType keyboardType,
    String warningText,
    Widget suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            obscureText: isPassword,
            validator: (value) => value.isEmpty ? warningText : null,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hint,
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState.validate()) {
          Flushbar(
            message: I18n.of(context).loading,
            showProgressIndicator: true,
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 3),
          )..show(context);

          //auth
          final auth = new Auth();
          String _token;

          try {
            _token = await auth.signInWithEmail(
                _emailControl.text, _passwdControl.text);
          } catch (e) {
            Flushbar(
              message: e,
              margin: EdgeInsets.all(8),
              borderRadius: 8,
              duration: Duration(seconds: 4),
            )..show(context);
            FocusScope.of(context).requestFocus(new FocusNode());
          }

          if (_token != null) {
            print(_emailControl.text + _passwdControl.text);

            await prefs.setToken(_token);

            String userId = await auth.getUid();
            await prefs.setUserId(userId);
            
            print("token: " + _token + "userid: " + userId);

            String displayName = await auth.getName();
            await prefs.setUserName(displayName);

            pushNewScreen(
              context,
              screen: Root(),
              platformSpecific: false,
              withNavBar: true,
            );

            FocusScope.of(context).unfocus();
            Flushbar(
              message: I18n.of(context).loginSuccessText,
              margin: EdgeInsets.all(8),
              borderRadius: 8,
              duration: Duration(seconds: 3),
            )..show(context);

            OneSignal.shared.setExternalUserId(userId);
          } else {
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          I18n.of(context).login,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(I18n.of(context).orText),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            I18n.of(context).questionAccountText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text(
              I18n.of(context).registerText,
              style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: I18n.of(context).title,
        style: TextStyle(
          //textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xffe46b10),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            I18n.of(context).emailText,
            _emailControl,
            hint: "john@mayer.me",
            keyboardType: TextInputType.emailAddress,
            warningText: I18n.of(context).emailEmptyWarningText,
          ),
          _entryField(
            I18n.of(context).passwordText,
            _passwdControl,
            isPassword: _isHidePassword,
            warningText: I18n.of(context).passwordEmptyWarningText,
            suffixIcon: GestureDetector(
              onTap: () {
                _togglePasswordVisibility();
              },
              child: Icon(
                _isHidePassword ? Icons.visibility_off : Icons.visibility,
                color: _isHidePassword ? Colors.grey : Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 20),
          _submitButton(),
        ],
      ),
    );
  }
}

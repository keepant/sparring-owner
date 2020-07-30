import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/components/loading.dart';
import 'package:sparring_owner/graphql/owner.dart';
import 'package:intl/intl.dart';
import 'package:sparring_owner/i18n.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String sex;

  Profile({
    Key key,
    this.userId,
    this.sex,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _emailTxt = new TextEditingController();
  final TextEditingController _phoneTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.sex;
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: API.client,
      child: Query(
        options: QueryOptions(
            documentNode: gql(getOwner),
            //pollInterval: 10,
            variables: {
              'id': widget.userId,
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

          // _picked = owner['sex'] ?? '';

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                I18n.of(context).profileText,
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
                        backgroundImage: owner['profile_picture'] == null
                            ? AssetImage("assets/img/pp.png")
                            : NetworkImage(owner['profile_picture']),
                      ),
                    ),
                  ),
                  EditView(
                    label: I18n.of(context).fullNameText,
                    textEditingController: _nameTxt..text = owner['name'],
                    keyboardType: TextInputType.text,
                    hintText: I18n.of(context).fullNameText,
                    warningText: I18n.of(context).fullNameEmptyWarningText,
                  ),
                  EditView(
                    label: I18n.of(context).emailText,
                    textEditingController: _emailTxt..text = owner['email'],
                    keyboardType: TextInputType.emailAddress,
                    hintText: I18n.of(context).emailText,
                    warningText: I18n.of(context).emailEmptyWarningText,
                    enabled: false,
                  ),
                  _radioBtn(),
                  EditView(
                    label: I18n.of(context).phoneNumber,
                    textEditingController: _phoneTxt
                      ..text = owner['phone_number'],
                    keyboardType: TextInputType.number,
                    hintText: I18n.of(context).phoneNumber,
                    warningText: I18n.of(context).phoneNumberEmptyWarningText,
                  ),
                  EditView(
                    label: I18n.of(context).address,
                    textEditingController: _addressTxt..text = owner['address'],
                    keyboardType: TextInputType.text,
                    hintText: I18n.of(context).address,
                    warningText: I18n.of(context).addressEmptyWarningText,
                  ),
                  FieldView(
                    label: I18n.of(context).joinedText,
                    text: new DateFormat.yMMMMd('en_US')
                        .format(DateTime.parse(owner['created_at']))
                        .toString(),
                    useDivider: false,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Mutation(
                      options: MutationOptions(
                        documentNode: gql(updateOwner),
                        update: (Cache cache, QueryResult result) {
                          return cache;
                        },
                        onCompleted: (dynamic resultData) {
                          print(resultData);
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
                        return RaisedButton(
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
                              runMutation({
                                'id': widget.userId,
                                'name': _nameTxt.text,
                                'sex': _picked,
                                'phone': _phoneTxt.text,
                                'address': _addressTxt.text
                              });
                              FocusScope.of(context).unfocus();
                              Flushbar(
                                message: I18n.of(context).savingChangesText,
                                showProgressIndicator: true,
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            I18n.of(context).saveText,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        },
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
          child: Text(I18n.of(context).genderText),
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
  final bool enabled;

  EditView({
    @required this.label,
    this.hintText,
    this.textEditingController,
    this.warningText,
    this.keyboardType,
    this.enabled,
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
            enabled: enabled,
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

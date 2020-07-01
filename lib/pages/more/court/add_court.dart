import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring_owner/api/api.dart';
import 'package:sparring_owner/graphql/court.dart';
import 'package:sparring_owner/pages/more/court/court.dart';
import 'package:sparring_owner/utils/env.dart';

class AddCourt extends StatefulWidget {
  final String accountStatus;

  AddCourt({
    Key key,
    this.accountStatus,
  }) : super(key: key);

  @override
  _AddCourtState createState() => _AddCourtState();
}

class _AddCourtState extends State<AddCourt> {
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

  final TextEditingController _nameTxt = new TextEditingController();
  final TextEditingController _addressTxt = new TextEditingController();
  final TextEditingController _priceTxt = new TextEditingController();
  final TextEditingController _latitudeTxt = new TextEditingController();
  final TextEditingController _longitudeTxt = new TextEditingController();
  final TextEditingController _phoneTxt = new TextEditingController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String openDay;
  String closedDay;
  String openHour;
  String closedHour;
  List facility;

  List<Asset> images = List<Asset>();
  List img;

  final FirebaseStorage _storage = FirebaseStorage(
    storageBucket: fbStorageURI,
  );

  StorageUploadTask uploadTask;

  Future<List> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    List<File> fileImage = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#FF5722",
          statusBarColor: "#FF5722",
          actionBarTitle: "Pick court images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    resultList.forEach((resultList) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(resultList.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileImage.add(tempFile);
      }
    });

    setState(() {
      images = resultList;
    });

    return fileImage;
  }

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
      body: GraphQLProvider(
        client: API.client,
        child: FormBuilder(
          key: _fbKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: <Widget>[
              FormBuilderTextField(
                attribute: "name",
                decoration: InputDecoration(labelText: "Name"),
                controller: _nameTxt,
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              FormBuilderTextField(
                attribute: "address",
                decoration: InputDecoration(labelText: "Address"),
                controller: _addressTxt,
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              FormBuilderTextField(
                attribute: "phone_number",
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.number,
                controller: _phoneTxt,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: "Phone number must be a numeric!"),
                ],
              ),
              FormBuilderDropdown(
                attribute: "open_day",
                decoration: InputDecoration(labelText: "Open day"),
                hint: Text('Select Open day'),
                validators: [FormBuilderValidators.required()],
                onChanged: (value) {
                  setState(() {
                    openDay = value;
                  });
                },
                items: [
                  'Senin',
                  'Selasa',
                  'Rabu',
                  'Kamis',
                  'Jum\'at',
                  'Sabtu',
                  'Minggu'
                ]
                    .map((open) =>
                        DropdownMenuItem(value: open, child: Text("$open")))
                    .toList(),
              ),
              FormBuilderDropdown(
                attribute: "closed_day",
                decoration: InputDecoration(labelText: "Closed day"),
                hint: Text('Select closed day'),
                validators: [FormBuilderValidators.required()],
                onChanged: (value) {
                  setState(() {
                    closedDay = value;
                  });
                },
                items: [
                  'Senin',
                  'Selasa',
                  'Rabu',
                  'Kamis',
                  'Jum\'at',
                  'Sabtu',
                  'Minggu'
                ]
                    .map((close) =>
                        DropdownMenuItem(value: close, child: Text("$close")))
                    .toList(),
              ),
              FormBuilderDropdown(
                attribute: "open_hour",
                decoration: InputDecoration(labelText: "Open hour"),
                hint: Text('Select open hour'),
                validators: [FormBuilderValidators.required()],
                onChanged: (value) {
                  setState(() {
                    openHour = value;
                  });
                },
                items: [
                  '01:00',
                  '02:00',
                  '03:00',
                  '04:00',
                  '05:00',
                  '06:00',
                  '07:00',
                  '08:00',
                  '09:00',
                  '10:00',
                  '11:00',
                  '12:00',
                  '13:00',
                  '14:00',
                  '15:00',
                  '16:00',
                  '17:00',
                  '18:00',
                  '19:00',
                  '20:00',
                  '21:00',
                  '22:00',
                  '23:00',
                  '24:00',
                ]
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text("$value"),
                        ))
                    .toList(),
              ),
              FormBuilderDropdown(
                attribute: "closed_hour",
                decoration: InputDecoration(labelText: "Closed hour"),
                hint: Text('Select closed hour'),
                validators: [FormBuilderValidators.required()],
                onChanged: (value) {
                  setState(() {
                    closedHour = value;
                  });
                },
                items: [
                  '01:00',
                  '02:00',
                  '03:00',
                  '04:00',
                  '05:00',
                  '06:00',
                  '07:00',
                  '08:00',
                  '09:00',
                  '10:00',
                  '11:00',
                  '12:00',
                  '13:00',
                  '14:00',
                  '15:00',
                  '16:00',
                  '17:00',
                  '18:00',
                  '19:00',
                  '20:00',
                  '21:00',
                  '22:00',
                  '23:00',
                  '24:00',
                ]
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text("$value"),
                        ))
                    .toList(),
              ),
              FormBuilderTextField(
                attribute: "price",
                decoration: InputDecoration(labelText: "Price per hour"),
                keyboardType: TextInputType.number,
                controller: _priceTxt,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: "Price must be a numeric!"),
                ],
              ),
              FormBuilderTextField(
                attribute: "latitude",
                decoration:
                    InputDecoration(labelText: "Latitude (Location on maps)"),
                keyboardType: TextInputType.number,
                controller: _latitudeTxt,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: "Latitude must be a numeric!"),
                ],
              ),
              FormBuilderTextField(
                attribute: "Longitude",
                decoration:
                    InputDecoration(labelText: "Longitude (Location on maps)"),
                keyboardType: TextInputType.number,
                controller: _longitudeTxt,
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: "Longitude must be a numeric!"),
                ],
              ),
              Query(
                options: QueryOptions(
                  documentNode: gql(getCourtFacilities),
                  pollInterval: 5,
                ),
                builder: (QueryResult result,
                    {FetchMore fetchMore, VoidCallback refetch}) {
                  if (result.hasException) {
                    return Center(
                      child: Text(result.exception.toString()),
                    );
                  }

                  if (result.loading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  }

                  List facilities = result.data['court_facilities'];

                  return FormBuilderCheckboxList(
                    decoration:
                        InputDecoration(labelText: "Select court facility "),
                    attribute: "facility",
                    onChanged: (value) {
                      facility = value;
                    },
                    options: facilities.map((item) {
                      return FormBuilderFieldOption(
                        label: item['name'],
                        value: item['id'],
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text("Court images"),
              IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 30,
                ),
                onPressed: () async {
                  img = await loadAssets();
                },
              ),
              SizedBox(
                height: 10,
              ),
              buildGridView(),
              SizedBox(
                height: 40,
              ),
              Mutation(
                options: MutationOptions(
                  documentNode: gql(addCourt),
                  update: (Cache cache, QueryResult result) {
                    return cache;
                  },
                  onCompleted: (dynamic resultData) {
                    print(resultData);
                    pushNewScreen(
                      context,
                      screen: Court(),
                      platformSpecific: true,
                      withNavBar: true,
                    );
                    Flushbar(
                      message: "Court saved!",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 2),
                    )..show(context);
                  },
                  onError: (error) => print(error),
                ),
                builder: (RunMutation runMutation, QueryResult result) {
                  return RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {
                      String name = _nameTxt.text;
                      String fileName1 = "$name-court1-${DateTime.now()}.png";
                      String imgTrim1 = fileName1.replaceAll(" ", "");
                      String filePath1 = 'courts/$imgTrim1';
                      String fileName2 = "$name-court2-${DateTime.now()}.png";
                      String imgTrim2 = fileName2.replaceAll(" ", "");
                      String filePath2 = 'courts/$imgTrim2';
                      String fileName3 = "$name-court3-${DateTime.now()}.png";
                      String imgTrim3 = fileName3.replaceAll(" ", "");
                      String filePath3 = 'courts/$imgTrim3';

                      runMutation({
                        'name': _nameTxt.text,
                        'address': _addressTxt.text,
                        'open_hour': openHour,
                        'closed_hour': closedHour,
                        'open_day': openDay,
                        'closed_day': closedDay,
                        'price_per_hour': _priceTxt.text,
                        'phone_number': _phoneTxt.text,
                        'latitude': _latitudeTxt.text,
                        'longitude': _longitudeTxt.text,
                        'owner_id': _userId,
                        'img1': imgTrim1,
                        'img2': imgTrim1,
                        'img3': imgTrim1,
                        'fas1': facility[0],
                        'fas2': facility[1],
                        'fas3': facility[2],
                      });

                      setState(() {
                        uploadTask =
                            _storage.ref().child(filePath1).putFile(img[0]);
                        uploadTask =
                            _storage.ref().child(filePath2).putFile(img[1]);
                        uploadTask =
                            _storage.ref().child(filePath3).putFile(img[2]);
                      });

                      print(
                        "name: " +
                            _nameTxt.text +
                            "\naddress: " +
                            _addressTxt.text +
                            "\nprice: " +
                            _priceTxt.text +
                            "\nphone number: " +
                            _phoneTxt.text +
                            "\nopen hour: " +
                            openHour +
                            "\nclosed hour: " +
                            closedHour +
                            "\nopen day: " +
                            openDay +
                            "\nclosed Day: " +
                            closedDay +
                            "\nlatitude: " +
                            _latitudeTxt.text +
                            "\nlongtitude: " +
                            _longitudeTxt.text +
                            "\nfacility: " +
                            facility[0].toString() +
                            "\nimages: " +
                            img[0].toString(),
                      );

                      if (_fbKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        Flushbar(
                          message: "Saving court..",
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );
  }
}
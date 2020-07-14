import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:sparring_owner/components/text_style.dart';
import 'package:sparring_owner/utils/navigation.dart';

class AboutUs extends StatefulWidget {

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  child: Image.asset('assets/icon/launcher_icon.png'),
                  backgroundColor: Colors.white,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BoldText(
                        text: "Sparring App",
                        size: 17.0,
                        color: Colors.black,
                      ),
                      NormalText(
                        text: "application to find futsal court and opponents",
                        color: Colors.grey,
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "</> with \u2764️ by keepant",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Icon(FontAwesomeIcons.github),
                  onTap: () {
                    Navigation.launchURL("https://github.com/keepant");
                  },
                ),
                SizedBox(
                  width: 15.0,
                ),
                InkWell(
                  child: Icon(FontAwesomeIcons.linkedin),
                  onTap: () {
                    Navigation.launchURL(
                        "https://www.linkedin.com/in/keepant/");
                  },
                ),
                SizedBox(
                  width: 15.0,
                ),
                InkWell(
                  child: Icon(FontAwesomeIcons.twitter),
                  onTap: () {
                    Navigation.launchURL("https://twitter.com/keepant");
                  },
                ),
                SizedBox(
                  width: 15.0,
                ),
                InkWell(
                  child: Icon(FontAwesomeIcons.instagram),
                  onTap: () {
                    Navigation.launchURL("https://instagram.com/keepant");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "App Version ${_packageInfo.version}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

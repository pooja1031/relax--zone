// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        // ignore: prefer_const_constructors
        child: SafeArea(
            // ignore: prefer_const_constructors
            child: Scaffold(
          // ignore: prefer_const_constructors
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    // ignore: duplicate_ignore, duplicate_ignore
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        // ignore: prefer_const_constructors
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Text(
                        'Privacy and Policy',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                    'Pooja Padmakumar built the App as A free App.This service is provided by Pooja Padmakumar at no cost and is inted for usese as is.\n \nThis page is used to inform the visitors regarding my policies with the collection,use,and  disclosure of personal information if anyone decide to use my service\n \n If you choose to use my service ,then you agree to the collection and use of information in relation to this policy.The personal information that i collect is used for providing and improving  the service Service. I will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Moosic unless otherwise defined in this Privacy Policy.\n \nInformation Collection and Use\n \nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to pooja. The information that I request will be retained on your device and is not collected by me in any way.\n\nThe app does use third-party services that may collect information used to identify you.\n\nLink to the privacy policy of third-partyservice providers used by the app \n\nGoogle Play Services\n\nLog Data\n\nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.\nCookies\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory.This Service does not use these "cookies" explicitly. However, the app may use third- party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.  '),
              ),
              //  )
              Padding(
                padding: const EdgeInsets.only(top: 158.0),
                child: Center(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color.fromARGB(255, 18, 15, 15)),
                    ),
                    color: Color.fromARGB(255, 8, 219, 117),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  // child: Text('NO SONGS'),
                ),
              )
            ],
          ),
        )));
  }
}

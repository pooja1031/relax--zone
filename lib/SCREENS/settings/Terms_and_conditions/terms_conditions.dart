// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 131, 116, 167),
          body: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
              Padding(
                padding: const EdgeInsets.only(left: 38.0, right: 38),
                child: Text(
                  "\n\nBy accessing or using our music player app 'RelaxZone', you agree to be bound by these terms and conditions (the terms). If you do not agree to these terms, do not use the app.\n\nWe reserve the right to change these terms at any time, and you are responsible for reviewing these terms for any updates. Your continued use of the app after any changes have been made constitutes your acceptance of the revised terms.\n\nUse of the App:\n\nThe app is intended for personal, non-commercial use. You may not use the app for any illegal or unauthorized purpose. You may not use the app to distribute or download any material that is illegal, copyrighted, or that violates these terms.\nWe grant you a limited, non-exclusive, non-transferable license to use the app for your personal, non-commercial use. This license does not include the right to sell or distribute the app, or to modify or create derivative works of the app.\nContent and Intellectual Property\n\nThe app includes content that is owned or licensed by us, including but not limited to text, images, music, and other audio and visual materials. This content is protected by copyright and other intellectual property laws, and you may not use this content except as provided in these terms or with the express written permission of the owner.\n\nThe app also includes music and other audio files that are owned or licensed by third parties. We do not claim ownership of these files, and you are responsible for obtaining the necessary permissions to use them.\n\nAccounts and Privacy:\n\nIn order to access certain features of the app, you may be required to create an account. You are responsible for maintaining the confidentiality of your account and password, and for all activities that occur under your account.\nWe respect your privacy and will not share your personal information with third parties, except as required by law or as necessary to provide the app to you. For more information on how we handle your personal information, please see our privacy policy.\n\nDisclaimer of Warranties:\n\nThe app is provided on an as is and as available basis, without warranty of any kind, either express or implied, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, and non-infringement. We do not guarantee that the app will be available at all times or that it will be error-free.\n\nLimitation of Liability:\n\nWe will not be liable for any damages arising out of or in connection with your use of the app, including but not limited to direct, indirect, incidental, consequential, or punitive damages. This limitation applies even if we have been advised of the possibility of such damages.\n\nGoverning Law:\n\nThese terms are governed by the laws of the state of [state], and you agree to submit to the exclusive jurisdiction of the courts located in [county] for any disputes arising out of or in connection with these terms or the app.\n\nContact Us:\n\nIf you have any questions about these terms or the app, please contact us at [poojapadmakumar03@gmail.com]\n                                                    ",
                ),
              ),
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
        ),
      ),
    );
  }
}

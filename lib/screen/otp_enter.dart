import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'terms.dart';
import 'dart:convert';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var stateInfoUrl = 'https://app.famile.care/api/v1/verifyotp';
  void setProfile(String id) async
  {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('profileId', id.toString());
    myPrefs.setString('token', 'loggedin');
  }
  String tokens;
  @override
  void initState() {
    final FirebaseMessaging _firebaseMessaging =
    FirebaseMessaging();

    _firebaseMessaging.getToken()
        .then((String token) {
          setState(() {
            tokens = token;
          });
      print("Push Messaging token: $token");
      // Push messaging to this token later
    });
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    listenotp();

  }
  listenotp() async {
    await SmsAutoFill().code.listen((event) {
      setState(() {
        currentText = event;
        textEditingController.text = event;
      });
    });
  }


  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top:30.0,bottom: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 170,
                ),
                Visibility(
                  visible: false,
                  maintainState: true,
                  child: PinFieldAutoFill( //code submitted callback
                      onCodeChanged: (val) {
                        print(val);
                      },
                      codeLength: 4//code length, default 6
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                  child: Row(
                    children: [
                      Text('Enter ',style: TextStyle(color: Color(0xFF686868),fontSize: 24,fontFamily: 'ProximaNova')),
                      Text('OTP',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24,fontWeight: FontWeight.bold,fontFamily: 'ProximaNova'))
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0,bottom: 10.0),
                  child: Text(
                    hasError ? "You have entered the wrong PIN!" : "",
                    style: TextStyle(
                        color: Color(0xFFC20D0D),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 3) {
                            return "I'm from validator";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(9),
                          inactiveColor: Color(0xFFFFC4D4),
                          activeColor: Color(0xFFFFC4D4),
                          selectedColor: Color(0xFFFFC4D4),
                          fieldHeight: 54,
                          fieldWidth: 54,
                          activeFillColor:
                          hasError ? Colors.orange : Colors.white,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Theme.of(context).canvasColor,
                        enableActiveFill: false,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          print("Completed");
                        },
                        onTap: () {
                          print("Pressed");
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),

                Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      onPressed: () async {
                        formKey.currentState.validate();
                        // conditions for validating
                        if (currentText.length != 4) {
                          errorController.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            hasError = false;
//                          scaffoldKey.currentState.showSnackBar(SnackBar(
//                            content: Text("Aye!!"),
//                            duration: Duration(seconds: 2),
//                          ));
                          });
                        }
                        final signcode = await SmsAutoFill().getAppSignature;
                        print(signcode);
                        print(SmsAutoFill().code);
                        http.post(stateInfoUrl, body: {
                          "phone": widget.phoneNumber.toString(),
                          "otp" : currentText.toString(),
                          "token" : tokens.toString()
                        }).then((response) {
                          if(response.statusCode == 201)
                            {
                              errorController.add(ErrorAnimationType
                                  .shake);
                              setState(() {
                                hasError = true;
                              });
                            }
                          if(response.statusCode == 200)
                          { var responseData = response.body;
                            var parsedJson = json.decode(responseData);
                            print(parsedJson['user']);
                            print('herehererer');
                            setProfile(parsedJson['user'].toString());
                            print(response.body);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Terms()),
                                  (Route<dynamic> route) => false,
                            );
                          }
                        });
                      },
                      child: Center(
                          child: Text(
                            "CONTINUE TO APP".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFF33CAFF),
                      borderRadius: BorderRadius.circular(5),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: [
                            CountdownFormatted(
                              duration: Duration(minutes: 2,seconds: 30),
                              builder: (BuildContext ctx, String remaining) {
                                return Text(remaining); // 01:00:00
                              },
                            ),
                            Text(" REMAINING",style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14))
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: " RESEND OTP",
                            recognizer: onTapRecognizer,
                            style: TextStyle(
                                color: Color(0xFF33CAFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Image.asset('assets/famile.png',height: 30,width: 65,)//Your widget here,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                  child: ConnectivityWidget(
                      showOfflineBanner: true,
                      offlineBanner: Flushbar(
                        message: "No Internet Connection",
                        backgroundColor: Colors.red,
                      ),
                      builder: (context, isOnline) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Text("${isOnline ? 'Online' : 'Offline'}", style: TextStyle(fontSize: 30, color: isOnline ? Colors.green : Colors.red),),

                          ],
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
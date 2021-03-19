
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/otp_enter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flushbar/flushbar.dart';

class OtpPhone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OtpPhoneState();
  }
}

class _OtpPhoneState extends State<OtpPhone> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  var phone;
  var stateInfoUrl = 'https://app.famile.care/api/v1/sendotp';

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get gurrent location"),
              content:
              const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = const AndroidIntent(
                      action: 'action_location_source_settings',
                    );
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkGps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 170,
            ),
            Text('Enter Your',style: TextStyle(color: Color(0xFF686868),fontSize: 24)),
            Text('Phone Number',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24,fontWeight: FontWeight.bold)),
            Spacer(flex: 2,),
            InternationalPhoneNumberInput(
              maxLength: 11,
              hintText: 'Enter Phone Number',
              countries: ['IN'],
              countrySelectorScrollControlled: false,
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
                setState(() {
                  phone = number;
                });
              },
              onInputValidated: (bool value) {
                print(value);
              },
              ignoreBlank: false,
              autoValidate: false,
              inputDecoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFC4D4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFC4D4)),
                ),hintText: 'Enter Phone Number'),
              selectorTextStyle: TextStyle(color: Colors.black),
              textFieldController: controller,
              inputBorder: OutlineInputBorder(),
            ),
            Spacer(flex: 1,),
            SizedBox(
              height: 50,
                width: double.infinity, // match_parent
                child: RaisedButton(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),),
                  onPressed: () {
                    http.post(stateInfoUrl, body: {
                      "phone": phone.toString(),
                    }).then((response) {
                      if(response.statusCode == 200)
                        {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => PinCodeVerificationScreen(phone.toString())),
                                (Route<dynamic> route) => false,
                          );
                        }
                    });
                  },
                  color: Color(0xFF33CAFF),
                  textColor: Colors.white,
                  child: Text("Get OTP".toUpperCase(),
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                ),
            ),
            Spacer(flex: 1,),
            Text('A 4 digit OTP will be sent via SMS to verify\n your mobile number.',style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14),),
            Spacer(flex: 10,),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Image.asset('assets/famile.png',height: 30,width: 65,)//Your widget here,
                ),
              ),
            ),
            ConnectivityWidget(
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
          ],
        ),
      ),
    );
  }

}
import 'package:flutter/cupertino.dart';

import 'shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screen/otp_enter_phone.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

void setFirebase() {
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('ic_launcher');

  var initializationSettingsIOS =
  IOSInitializationSettings();

  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS,);

  flutterLocalNotificationsPlugin
      .initialize(initializationSettings,
      onSelectNotification: onSelect);
// flutterLocalNotificationsPlugin.no
  final FirebaseMessaging _firebaseMessaging =
  FirebaseMessaging();

  _firebaseMessaging.configure(
    onBackgroundMessage: Platform.isIOS ?
    null : myBackgroundMessageHandler,
    onMessage: (message) async {
      print("onMessage: $message");
      othernotification(
        message['notification']['title'],
      message['notification']['body'],
      message['notification']['image']
      
      );
    },
    onLaunch: (message) async {
      print("onLaunch: $message");
    },
    onResume: (message) async {
      print("onResume: $message");
    },
  );

  _firebaseMessaging.getToken()
      .then((String token) {
    print("Push Messaging token: $token");
    // Push messaging to this token later
  });

}
void othernotification(String title, String body,String image){
  var initializationSettingsIOS =
  IOSInitializationSettings();
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin
      .initialize(initializationSettings,
      onSelectNotification: onSelect);
  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'your channel id', 'your channel name',
      'your channel description', 
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      // icon:"newlogo" ,

      importance: Importance.max,
      priority: Priority.high, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin
      .show(4,
      title,
      body, platformChannelSpecifics,
      payload: 'payload');
}
Future<String> onSelect(String data) async {
  print("onSelectNotification $data");
}
//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String,
    dynamic> message) async {
  print("myBackgroundMessageHandler message: $message");
  int msgId = int.tryParse(message["data"]["msgId"]
      .toString()) ?? 0;
  print("msgId $msgId");
  var androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'your channel id', 'your channel name',
      'your channel description', 
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      // icon:"newlogo" ,

   

      importance: Importance.max,
      priority: Priority.high, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin
      .show(msgId,
      message["data"]["msgTitle"],
      message["data"]["msgBody"],
      // message['data']['msgmage'],
      
       platformChannelSpecifics,
      payload: message["data"]["data"]);
  return Future<void>.value();
}
void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, //top bar icons
      )
  );
  runApp(MyApp());
  setFirebase();
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Famile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'ProximaNova',
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: 'ProximaNova')
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//By default makes your app always load the StartUpWidget
      home: StartUpWidget(),
      routes: {
        '/view-image': (content) => ViewImagePage()
      },
    );
  }
}
class StartUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
            future: SharedPreferencesManager().isFreshInstalled(),
            builder: (context, isFreshInstalledSnapshot) {
              if (isFreshInstalledSnapshot.hasData) {
                if (isFreshInstalledSnapshot.data) {
//You can return for example your onboarding widget/page
                  return OnboardingPage();
                } else {
//You can return your HomePage() or whatever widget/page
                  return CheckAuth();
                }
              } else {
//For good user Experiance you can show Your App Logo/loading Screen
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => CheckAuth()),
          (Route<dynamic> route) => false,
    );
  }
  @override
  List<PageViewModel> getPages() {
    return [
      PageViewModel(bodyWidget:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text("A digital locker for your \nmedical records.",style: TextStyle(fontSize: 26,color: Colors.white),textAlign: TextAlign.left),
              SizedBox(
                height: 99,
              ),
              Image.asset("assets/onboarding/locker.png",alignment: Alignment.bottomCenter,height: 273.2,width: 246,),
            ],
          ),
          title: "",
          decoration: const PageDecoration(
            pageColor: Color(0xFFFC608C),
          )
      ),
      PageViewModel(
        bodyWidget:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Text("Upload medical reports, \nprescriptions and \ntest results.",style: TextStyle(fontSize: 24,color: Colors.white),textAlign: TextAlign.left),
            SizedBox(
              height: 99,
            ),
            Image.asset("assets/onboarding/report.png",alignment: Alignment.bottomCenter,height: 273.2,width: 246,),
          ],
        ),
        title: "",
        decoration: const PageDecoration(
          pageColor: Color(0xFF1ABFF9),
        ),
      ),
      PageViewModel(
          bodyWidget:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "We respect your\ndata rights.\n\n",style: TextStyle(fontSize: 24,color: Colors.white)),
                      TextSpan(text: "None of your data can be shared with anyone, without your permission (not even with a doctor). Your can request access to all your data at anytime and also opt out of our data program if you want.",style: TextStyle(fontSize: 14,color: Color(0xFF004132))),
                    ]
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset("assets/onboarding/privacy.png",alignment: Alignment.bottomCenter,height: 273.2,width: 246,),
            ],
          ),
          title: "",
          decoration: const PageDecoration(
            pageColor: Color(0xFF33ECC1),
          )),

    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Introduction Screen"),
//      ),
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        next: Image.asset("assets/onboarding/next-btn.png"),
        showSkipButton: false,
        isProgress: false,
        skip: Text("Skip"),
        done: Image.asset("assets/onboarding/next-btn.png"),
        onDone: () => _onIntroEnd(context),
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("My Home Page"),
      ),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Home();
    } else {
      child = OtpPhone();
    }
    return Scaffold(
      body: child,
    );
  }
}

class ViewImagePage extends StatefulWidget {

  @override
  _ViewImagePageState createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  final _fileNameController = TextEditingController();
  final String phpEndPoint = 'https://app.famile.care/api/v1/image';
  ProgressDialog progressDialog;
  File file;

  void _upload() async{
    progressDialog.show();
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String profileId = myPrefs.getString('memberidselected');
    final String userId = myPrefs.getString('profileId');
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
      "profileId" : profileId,
      "userId" : userId,
      "userfilename" : _fileNameController.text,
    }).then((res) {
      print(res.statusCode);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Home()),
            (Route<dynamic> route) => false,
      );
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    _fileNameController.text = "Name of Document";
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    final ImageArgs args = ModalRoute.of(context).settings.arguments;
    file = args.image;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFFFEEF3),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),),
                  onPressed: _upload,
                  color: Color(0xFF33CAFF),
                  textColor: Colors.white,
                  child: Text("Save Document".toUpperCase(),
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _fileNameController,
                ),
                SizedBox(
                  height: 10,
                ),
                Image.file(args.image),
              ],
            ),
          ),
        ),
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Image.file(args.image),
//        ),
      ),
    );
  }



}
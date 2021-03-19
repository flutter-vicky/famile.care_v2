import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/screen/familepage.dart';
import 'package:flutter_app/screen/timeline.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as scharts;
import 'login.dart';
import 'package:flutter_app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'profile_form.dart';
import 'bottomsheet.dart';
import 'profileconvert.dart';
import 'profiledetail.dart';
import 'package:flutter_app/constants.dart';
import 'edit_profile.dart';
import 'gallery_upload.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import '../pre/bottom_navigation_icons.dart' as bottomicon;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:share/share.dart';
import 'package:async/async.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class ImageArgs {
  final File image;

  ImageArgs(this.image);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var vehicaleyear = "2021";
var currentid;

class _HomeState extends State<Home> {
  String profileId;
  bool isFloatVisible = true;
  List<Time> _times = List<Time>();
  var temp = 1;
  Future<List<Time>> fetchTime() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
    var url = 'https://app.famile.care/api/v1/gettimelineinfo';
    var response = await http.post(url, body: {
      "profileid": profileId.toString(),
    });

    var members = List<Time>();

    if (response.statusCode == 200) {
      print(response.body);
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        members.add(Time.fromJson(noteJson));
      }
    }
    temp = 0;
    return members;
  }

//  members called here
  List<Member> _members = List<Member>();

  Future<List<Member>> fetchMembers() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
    var url = 'https://app.famile.care/api/v1/getmembers';
    var response =
        await http.post(url, body: {"profileid": profileId.toString()});

    var members = List<Member>();

    if (response.statusCode == 200) {
      print(response.body);
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        members.add(Member.fromJson(noteJson));
      }
    }
    return members;
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      var url = 'https://app.famile.care/api/v1/setlocation';
      http.post(url, body: {
        "profileid": profileId,
        "location": _currentAddress,
      });
    } catch (e) {
      print(e);
    }
  }

//
  int _currentIndex = 0;
  int _value = 1;
  final titleText = [
    Text('Timeline',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    Text('Dashboard',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    Text('Profile',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    Text('Share',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
  ];
  SharedPreferences myPrefs;
  void getinfo() async {
    myPrefs = await SharedPreferences.getInstance();
    SharedPreferences myPref = await SharedPreferences.getInstance();
    profileId = myPref.getString('profileId');
  }

  List tabs = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    tabs = [
      Column(
        children: [
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
                  )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: fetchTime(),
                      builder: (context, snapshot) {
                          return timelist();

                      })
                ],
              ),
            ),
          ),
        ],
      ),

      Scaffold(
        body: Column(
          children: [
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
                    )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DashboardPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
//    Center(child: Text('Dashboard')),

      Column(
        children: [
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
                  )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                ProfilePage(),
              ]),
            ),
          ),
        ],
      ),

      Column(
        children: [
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
                  )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    color: Color(0xfffffbfc),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Text('Share & Care',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.070,
                        ),
                        Image.asset("assets/Famile-logo-app.png"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "Care ",
                                style: TextStyle(color: Colors.pinkAccent)),
                            TextSpan(
                                text: "for ",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text: "Loved ",
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                )),
                            TextSpan(
                                text: "ones ! ",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ]),
                        ),
                        // Text('Care for loved ones !',
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold)),
                        Text('Digitized Your Family Medical History',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text('For A Healthier Future',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Share your link',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 30.0, left: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFFC608C),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextField(
                        enabled: true,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: 'Semiqolon',
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 18),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFFFEEF3),
                                border: Border.all(
                                  width: 4,
                                  color: Color(0xFFFFEEF3),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: IconButton(
                              icon: Image.asset("assets/ic-copy.png"),
                              onPressed: () {
                                Share.share('https://www.semiqolon.com/');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ];

    super.didChangeDependencies();
  }

//CALLING STATE API HERE
// Get State information by API
  image(String s, String q) {
    if (s == 'default') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          'https://app.famile.care/default.png',
          width: 40,
          height: 40,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          'https://app.famile.care/prescriptions/' + q + '/avatar.jpg',
          width: 40,
          height: 40,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  membersList() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: image(_members[index].image, _members[index].memberid),
          title: Text(
            _members[index].name,
            style: TextStyle(color: Color(0xFF000000), fontSize: 16),
          ),
          onTap: () {
            myPrefs.setString('memberidselected', _members[index].memberid);
            print(_members[index].memberid);
            Navigator.of(context).pop();
            showAlertDialog(context);
          },
        );
      },
      itemCount: _members.length,
    );
  }

  createlist(List s, String b) {
    List temp = [];
    for (var item in s) {
      temp.add('https://app.famile.care/prescriptions/' + b + '/' + item);
    }
    print(temp);
    return temp;
  }

  timelist() {
    if(temp == 1){
      return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],

                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                
                              ),
                               SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                
                              ),
                               SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                
                              ),
                               SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 80,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                
                              ),
                            ],
                          ),

                        
                        );
      //  Padding(
      //   padding: const EdgeInsets.only(top: 250,bottom: 15),
      //   child: Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );
    }

    if(_times.isEmpty)
    {
       return Center(
         child: Column(
           children: [
             SizedBox(
               height: 180,
             ),
             Text('There is nothing to show',style: TextStyle(color: Colors.black,fontSize: 24)),
             RichText(
               text: TextSpan(
                 children: [
                   TextSpan(text: 'in ',style: TextStyle(color: Colors.black,fontSize: 24)),
                   TextSpan(text: 'your timeline',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24)),
                 ]
               ),
             ),
             SizedBox(
               height: 18,
             ),
             Text('You can start by uploading your first',style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14)),
             Text('medical report or prescription slip',style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14)),
             SizedBox(
               height: 22,
             ),
             Container(
               height: 48.6,
               width: 190,
               child: FlatButton(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                     side: BorderSide(color: Color(0xFFFC608C))),
                 onPressed: onPressed,
                 color: Color(0xFFFC608C),
                 textColor: Colors.white,
                 child: Row(
                   children: [
                     Icon(Icons.camera_alt),
                     Text("  Upload a document",
                         style: TextStyle(fontSize: 14)),
                   ],
                 ),
               ),
             ),
           ],
         ),
       );
    }
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GalleryPage(createlist(_times[index].images, _times[index].id))),

          ),
          child: Container(
            margin: const EdgeInsets.only(left: 30.0,right: 30.0),
            child: TimelineTile(
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  color: Color(0xFF55F2CD),
                ),
                topLineStyle: const LineStyle(
                  width: 6,
                  color: Color(0xFFABFFEB),
                ),
                bottomLineStyle: const LineStyle(
                  width: 6,
                  color: Color(0xFFABFFEB),
                ),
                rightChild: Padding(
                  padding: const EdgeInsets.only(left:25.0,top: 40.0,bottom: 40.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_times[index].date+' | '+_times[index].time ,style: TextStyle(color: Color(0xFF686868)),textAlign: TextAlign.left),
                                  ),
                                ),
                                Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_times[index].doc+' Documents Uploaded',style: TextStyle(color: Color(0xFFFC608C)),textAlign: TextAlign.left),
                                    )
                                ),
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ButtonTheme(
                                          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), //adds padding inside the button
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
                                          minWidth: 0, //wraps child's width
                                          height: 0, //wraps child's height
                                          child: OutlineButton(onPressed: null, child: Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left)), //your original button
                                        )
//                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
                                    )
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(5.0),child: Image.network('https://app.famile.care/prescriptions/'+_times[index].id+'/'+_times[index].firstimage,width: 60,height: 110,fit: BoxFit.fill,
                                    
                                      loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Center(
                                                                          child: Shimmer.fromColors(
                                                                        baseColor:
                                                                            Colors.grey[300],
                                                                        highlightColor:
                                                                            Colors.grey[100],
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              100,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      )),
                                                                    );
                                                                  },
                                    )),
                                    Text(_times[index].count)
                                  ],
                                )

                              ],
                            )
                          ],
                        ), 
                      )
                      
                    ],
                  ),
                )
            ),
          ),
        );
      },
      itemCount: _times.length,
    );
  }

  showAlertDialog(BuildContext context) {
    Widget openCameraButton = FlatButton(
      child: Text("Take Picture"),
      onPressed: () {
//        Navigator.of(context).pop();
        openCamera();
      },
    );

    Widget openGalleryButton = FlatButton(
      child: Text("Open Gallery"),
      onPressed: () {
//        Navigator.of(context).pop();
        openGallery();
      },
    );

    // set up the button
//    Widget cancelButton = FlatButton(
//      child: Text("Cancel"),
//      onPressed: () {Navigator.of(context).pop(); },
//    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose from where to pick image"),
      content: Text("Either from camera or from gallery"),
      actions: [openCameraButton, openGalleryButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String name;
  @override
  void initState() {
    getinfo();
    fetchTime().then((value) {
      setState(() {
        _times.addAll(value);
      });
    });
    // timelist();
    fetchMembers().then((value) {
      setState(() {
        _members.addAll(value);
      });
    });
    _getCurrentLocation();
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['fname'];
      });
    }
  }

  addMember() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyCustomForm()),
    );
  }

  void onPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 1250,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10))),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.add,
                      color: Color(0xFFFC608C),
                    ),
                    title: Text(
                      'Add New Member',
                      style: TextStyle(color: Color(0xFFFC608C), fontSize: 16),
                    ),
                    onTap: addMember,
                  ),
                  Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Color(0xFFE8E8E8)),
                  Expanded(
                    child: membersList(),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> openCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 85);
    if (image != null) {
      Navigator.pushNamed(context, '/view-image', arguments: ImageArgs(image));
    }
  }

  Future<void> openGallery() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Upload()),
    );
    // ignore: deprecated_member_use
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if(image != null){
//      Navigator.pushNamed(context, '/view-image', arguments: ImageArgs(image));
//    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFEEF3));
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: titleText[_currentIndex],
        backgroundColor: Color(0xFFFFEEF3),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Color(0xFFFC608C)),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              if (_currentIndex == 2 && _members.isNotEmpty) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }
              if (_currentIndex == 0 && _members.isNotEmpty ||
                  _currentIndex == 1 ||
                  _currentIndex == 3) {
                return FamilePage.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }
            },
          ),
        ],
      ),
      body: tabs[_currentIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            backgroundColor: Color(0xFFFC608C),
            onPressed: () {
//          showAlertDialog(context);
              onPressed();
            },
          ),
          visible: isFloatVisible,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedItemColor: Color(0xFFFC608C),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                bottomicon.BottomNavigation.timeline,
                size: 25,
              ),
              title: Text('Timeline'),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                bottomicon.BottomNavigation.dashboard,
                size: 25,
              ),
              title: Text('Dashboard'),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                bottomicon.BottomNavigation.profile,
                size: 25,
              ),
              title: Text('Profile'),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.share_outlined,
                size: 25,
              ),
              title: Text('Share'),
              backgroundColor: Colors.white)
        ],
        onTap: (index) {
          if (index == 3) {
            setState(() {
              isFloatVisible = false;
            });
          } else {
            setState(() {
              isFloatVisible = true;
            });
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.EditProfile) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditProfile()),
      );
    }
    if (choice == Constants.Famile) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => familePage()),
      );
    }
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    getinfo();
    _getProfileList();
    super.initState();
  }

  var tempp = 1;
  //profile data start
  String age = ".....";
  String blood = ".....";
  String height = ".....";
  String weight = "......";
  String occupation = ".....";
  String email = ".....";
  String mobile = ".....";
  String state = ".....";
  String city = ".....";
  String address = ".....";

  void changedata(String s) {
    print(s);
    setState(() {
      String url = "https://app.famile.care/api/v1/profiledetail";
      http.post(url, body: {
        "memberid": s,
      }).then((response) {
        var data = json.decode(response.body);
        var user = UserDetail.fromJson(data[0]);
        setState(() {
          age = '${user.age}';
          blood = '${user.blood}';
          height = '${user.height}';
          weight = '${user.weight}';
          occupation = '${user.occupation}';
          email = '${user.email}';
          mobile = '${user.mobile}';
          state = '${user.state}';
          city = '${user.city}';
          address = '${user.address}';
          tempp = 0;
        });
//      print(statesList);
      });
    });
  }

  //profile data end

  List statesList;
  String _myState;
  String profileid;
  editProfileUpdate(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('editProfileId', s);
  }

  getinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profileid = prefs.getString('profileId');
  }

  String stateInfoUrl = 'https://app.famile.care/api/v1/profile';
  Future<String> _getProfileList() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileid = myPrefs.getString('profileId');
    await http.post(stateInfoUrl,
        body: {"profileid": profileid.toString()}).then((response) {
      var data = json.decode(response.body);
      var temp = data[0];
      var user = User.fromJson(temp);
      editProfileUpdate('${user.id}'.toString());
      changedata('${user.id}'.toString());
      setState(() {
        _myState = '${user.id}'.toString();
        statesList = data;
      });
//      print(statesList);
    });
  }

  image(String s, String q) {
    if (s == 'default') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          'https://app.famile.care/default.png',
          width: 40,
          height: 40,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          'https://app.famile.care/prescriptions/' + q + '/avatar.jpg',
          width: 40,
          height: 40,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // if(tempp == 1){
    //   return Padding(
    //     padding: const EdgeInsets.only(top: 250),
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 30,
                        icon: Icon(
                          // Add this
                          Icons.keyboard_arrow_down, // Add this
                          color: Color(0xFFFC608C), // Add this
                        ),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select Profile'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myState = newValue;
//                      print(_myState);
                          });
                          changedata(_myState);
                          editProfileUpdate(_myState);
                        },
                        items: statesList?.map((item) {
                              return new DropdownMenuItem(
                                child: Row(
                                  children: <Widget>[
//                                  i,
                                    image(item["image"].toString(),
                                        item['id'].toString()),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(item["name"],
                                            style:
                                                TextStyle(color: Colors.black)))
                                  ],
                                ),
                                value: item['id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Age',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$age',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Blood',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$blood',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Height',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$height',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Weight',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$weight',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Occupation',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$occupation',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Email',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$email',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Mobile',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$mobile',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('State',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$state',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('City',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('$city',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Address',
                            style: TextStyle(
                                color: Color(0xFFFC608C), fontSize: 12)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text('$address',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 6),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

    throw UnimplementedError();
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  _onTap(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: widget,
        ),
      ),
    );
  }

  AsyncMemoizer _memoizer;
  String profileId;
  SharedPreferences myPrefs;
  CarouselController buttonCarouselController = CarouselController();
  void getinfo() async {
    myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
  }

  List<Time> _times = List<Time>();
  var temp = 1;
  List imageList = [];
  Future<List<Time>> fetchTime() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
    var url = 'https://app.famile.care/api/v1/gettimelineinfo';
    var response = await http.post(url, body: {
      "profileid": profileId.toString(),
    });

    var members = List<Time>();

    if (response.statusCode == 200) {
      print(response.body);
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        members.add(Time.fromJson(noteJson));
      }
    }
    temp = 0;
    return members;
  }

  List data = List();
  Future getJSONData(String id, String year) {
    http.post(
      "https://app.famile.care/api/v1/getprofilechartdata",
      body: jsonEncode({"profile_id": id.toString(), "year": year.toString()}),
      // Only accept JSON response
      headers: {"Content-Type": "application/json"},
    ).then((response) {
      print("res" + response.body);
      print("pro" + profileId.toString());
      final json = jsonDecode(response.body);
      print(json);
      print(json.length);
      //----------------------------------------------------------------------

      for (var word in json) {
        if (word["monthname"] == "January") {
          setState(() {
            jan = word["count"];
            print(word["count"]);
          });
        } else if (jan != null) {
        } else {
          setState(() {
            jan = null;
          });
        }

        //----------------------------------------------------------------------

        if (word["monthname"] == "February") {
          setState(() {
            feb = word["count"];
            print(word["count"]);
          });
        } else if (feb != null) {
        } else {
          setState(() {
            feb = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "March") {
          setState(() {
            mar = word["count"];
          });
        } else if (mar != null) {
        } else {
          setState(() {
            mar = null;
          });
        }

        //----------------------------------------------------------------------
        if (word["monthname"] == "April") {
          setState(() {
            apr = word["count"];
          });
        } else if (apr != null) {
        } else {
          setState(() {
            apr = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "May") {
          setState(() {
            may = word["count"];
          });
        } else if (may != null) {
        } else {
          setState(() {
            may = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "June") {
          setState(() {
            jun = word["count"];
          });
        } else if (jun != null) {
        } else {
          setState(() {
            jun = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "July") {
          setState(() {
            jul = word["count"];
          });
        } else if (jan != null) {
        } else {
          setState(() {
            jul = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "Augest") {
          setState(() {
            aug = word["count"];
          });
        } else {
          setState(() {
            aug = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "September") {
          setState(() {
            sep = word["count"];
          });
        } else {
          setState(() {
            sep = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "October") {
          setState(() {
            oct = word["count"];
          });
        } else {
          setState(() {
            oct = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "November") {
          setState(() {
            nov = word["count"];
          });
        } else {
          setState(() {
            nov = null;
          });
        }
        //----------------------------------------------------------------------
        if (word["monthname"] == "December") {
          setState(() {
            dec = word["count"];
          });
        } else {
          setState(() {
            dec = null;
          });
        }
        //----------------------------------------------------------------------

      }
    });
    
  }

  int jan;
  int feb;
  int mar;
  int apr;
  int may;
  int jun;
  int jul;
  int aug;
  int sep;
  int oct;
  int nov;
  int dec;

  var date;
  int choose ;

  timelist() {
    if (timelinemode == 'default') 
    {

      // return SizedBox.shrink();
      return Card(
        elevation: 1,
        shadowColor: Color(0xffe4e4e4),
        color: Color(0xfff2f2f2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Tap on circle to view respective Vists.",
                    style: TextStyle(color: Colors.pink),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 70,
                    child: Container(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: vehicaleyear,
                        hint: Text("Year"),
                        items: <String>['2020', "2021"].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            vehicaleyear = value;
                            getJSONData(currentid, vehicaleyear);
                            jan = null;
                            feb = null;
                            mar = null;
                            apr = null;
                            may = null;
                            jun = null;
                            jul = null;
                            aug = null;
                            sep = null;
                            oct = null;
                            nov = null;
                            dec = null;

                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              scharts.SfCartesianChart(
                  // enableAxisAnimation: true,
                  zoomPanBehavior: _zoomPanBehavior,
                  onPointTapped: (scharts.PointTapArgs args) {
                    print(args.seriesIndex);
                    print(args.pointIndex);

                    if (args.pointIndex == 1) {

                      setState(() {
                        
                        choose = jan;
                      });
                    }
                    if (args.pointIndex == 2) {
                      setState(() {
                        choose = feb;
                      });
                    }
                  },
                  primaryXAxis: scharts.CategoryAxis(
                    edgeLabelPlacement: scharts.EdgeLabelPlacement.shift,
                    interval: 1,
                    labelRotation: -90,
                  ),
                  primaryYAxis: scharts.NumericAxis(
                    interval: 1,
                  ),
                  series: <scharts.ChartSeries>[
                    scharts.BubbleSeries<SalesData, String>(
                        selectionBehavior: _selectionBehavior,
                        dataSource: [
                          SalesData("Jan", jan, Color(0xff1ec0fe)),
                          SalesData('Feb', feb, Color(0xff1ec0fe)),
                          SalesData('Mar', mar, Color(0xff1ec0fe)),
                          SalesData('Apr', apr, Color(0xff1ec0fe)),
                          SalesData('May', may, Color(0xff1ec0fe)),
                          SalesData("Jun", jun, Color(0xff1ec0fe)),
                          SalesData('Jul', jul, Color(0xff1ec0fe)),
                          SalesData('Aug', aug, Color(0xff1ec0fe)),
                          SalesData('sep', sep, Color(0xff1ec0fe)),
                          SalesData('Oct', oct, Color(0xff1ec0fe)),
                          SalesData('Nov', nov, Color(0xff1ec0fe)),
                          SalesData('Dec', dec, Color(0xff1ec0fe)),
                        ],
                        // sizeValueMapper: (SalesData sales, _) => 1,
                        pointColorMapper: (SalesData sales, _) =>
                            sales.segmentColor,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales),
                    //  dataLabelSettings:DataLabelSettings(isVisible : true),
                  ]),
              SizedBox(
                height: 60,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => 
                          // PrescriptionHistory(),
                          DynamicExpansionTile()
                          ),
                    );
                  },
                  child: Card(
                    color: Color(0xff1ec0fe),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          elevation: 0,
                          height: 25,
                          minWidth: 10,
                          onPressed: () {},
                          color: Colors.white,
                          child: Text(
                            choose.toString(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Visits to Doctor/Hosiptal',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //   return SizedBox.shrink();
    //   return Container(
    //     height: 100,
    //     child: ListView.builder(
    //       shrinkWrap: true,
    //       scrollDirection: Axis.horizontal,
    //       itemBuilder: (context, index) {
    //         return Container(
    //           width: 150,
    //           height: 90,
    //           child: Column(
    //             children: [
    //               Text(
    //                 _times[index].date,
    //                 style: TextStyle(fontSize: 16.0),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   Expanded(
    //                     child: Divider(
    //                       thickness: 3,
    //                       color: Colors.blue,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                     width: 20,
    //                     child: Theme(
    //                       data: ThemeData(
    //                         unselectedWidgetColor: Colors.blue,
    //                       ),
    //                       child: Radio(
    //                         activeColor: Color(0xFF9F4576),
    //                         value: _times[index].groupid,
    //                         groupValue: _radioValue1,
    //                         onChanged: _handleRadioValueChange1,
    //                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                       ),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     child: Divider(
    //                       thickness: 3,
    //                       color: Colors.blue,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Text(
    //                 'Prescription',
    //                 style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
    //               ),
    //             ],
    //           ),
    //         );

    //       },
    //       itemCount: _times.length,
    //     ),
    //   );
    // }
    if (timelinemode == 'prescription') {
      return Container(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                items: imageList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                        child: PhotoView(
                          backgroundDecoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                          ),
                          imageProvider: NetworkImage(imgUrl),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.6,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (timelinemode == 'report') {
      return Center(
        child: Text(
          'No Reports Available Yet',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFC608C)),
        ),
      );
    }
  }

  var sharecode = '0000';
  var sharecodeprofileid;
  Future fetchsharecode() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
    sharecodeprofileid = myPrefs.getString('profileId');
    var url = 'https://app.famile.care/api/v1/sharecode';
    var response = await http.post(url, body: {
      "id": profileId.toString(),
    });
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson['sharecode']);
      setState(() {
        sharecode = notesJson['sharecode'];
      });
    }
  }

  scharts.SelectionBehavior _selectionBehavior;
  scharts.ZoomPanBehavior _zoomPanBehavior;
  TabController _controller;
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    fetchsharecode();
    _selectionBehavior = scharts.SelectionBehavior(
      enable: true,
      selectedBorderWidth: 4,
      selectedBorderColor: Color(0xff1dc473),
      selectedColor: Colors.blue,
      unselectedColor: Colors.grey,
    );

    _zoomPanBehavior = scharts.ZoomPanBehavior(
        enablePinching: true,
        zoomMode: scharts.ZoomMode.x,
        enablePanning: true,
        selectionRectBorderColor: Colors.yellow);
    fetchTime().then((value) {
      setState(() {
        _times.addAll(value);
      });
      for (var i = 0; i < _times.length; i++) {
        if (i == 0) {
          setState(() {
            _radioValue1 = _times[i].groupid;
          });
        }
      }
    });

    timelist();
    _getProfileList();
    super.initState();
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  var tempp = 1;
  var touch = 0;
  bool button1 = true;
  bool button2 = false;
  bool button3 = false;
  //profile data start
  String timelinemode = 'default';
  String age = ".....";
  String blood = ".....";
  String height = ".....";
  String weight = "......";
  String occupation = ".....";
  String email = ".....";
  String mobile = ".....";
  String state = ".....";
  String city = ".....";
  String address = ".....";

  createlist(List s, String b) {
    List temp = [];
    for (var item in s) {
      temp.add('https://app.famile.care/prescriptions/' + b + '/' + item);
    }
    print(temp);
    setState(() {
      imageList = temp;
    });
  }

  void changedata(String s) {
    print('pleasedont');
    print(s);
    setState(() {
      String url = "https://app.famile.care/api/v1/profiledetail";
      http.post(url, body: {
        "memberid": s,
      }).then((response) {
        var data = json.decode(response.body);
        String reencode = json.encode(data[0]);
        var tagsJson = jsonDecode(reencode)['image_links'];
        List<String> tags = tagsJson != null ? List.from(tagsJson) : null;
        createlist(tags, s);
        var user = UserDetail.fromJson(data[0]);
        setState(() {
          age = '${user.age}';
          blood = '${user.blood}';
          height = '${user.height}';
          weight = '${user.weight}';
          occupation = '${user.occupation}';
          email = '${user.email}';
          mobile = '${user.mobile}';
          state = '${user.state}';
          city = '${user.city}';
          address = '${user.address}';
        });
//      print(statesList);
      });
    });
  }

  //profile data end

  List statesList;
  String _myState;
  editProfileUpdate(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('editProfileId', s);
  }

  String stateInfoUrl = 'https://app.famile.care/api/v1/profile';
  Future<String> _getProfileList() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
    await http.post(stateInfoUrl,
        body: {"profileid": profileId.toString()}).then((response) {
      var data = json.decode(response.body);
      var temp = data[0];
      var user = User.fromJson(temp);
      editProfileUpdate('${user.id}'.toString());
      changedata('${user.id}'.toString());
      getJSONData('${user.id}'.toString(), vehicaleyear);
      setState(() {
        _myState = '${user.id}'.toString();
        statesList = data;
        tempp = 0;
        currentid = _myState;
      });

//      print(statesList);
    });
  }

  image(String s, String q) {
    if (s == 'default') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          'https://app.famile.care/default.png',
          width: 36,
          height: 36,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          'https://app.famile.care/prescriptions/' + q + '/avatar.jpg',
          width: 36,
          height: 36,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  int _radioValue1 = -1;
  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      print(_radioValue1);
    });
  }

  update(String value) {
    setState(() {
      timelinemode = value;
      _radioValue1 = -1;
      print(value);
    });
  }

  lastbutton() {
    if (_radioValue1 == -1) {
      return SizedBox.shrink();
    } else {
      return SizedBox.shrink();
      // return SizedBox(
      //   height: 50,
      //   width: MediaQuery.of(context).size.width * 0.7,
      //   child: RaisedButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => GraphDetail()),
      //       );
      //     },
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(7.0),
      //     ),
      //     color: Color(0xFF33CAFF),
      //     child: Text("Prescription History".toUpperCase(),
      //         style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 14,
      //             fontWeight: FontWeight.bold)),
      //   ),
      // );
    }
  }

  Future<List<Description>> _fetchJobs() async {
    final jobsListAPIUrl =
        'https://app.famile.care/api/v1/getprofilechartdatadetail';
    final response = await http.post(jobsListAPIUrl,
        body: jsonEncode({"profile_id": "11", "year": "2021"}),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Description.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  int _id;

  belowtimeline() {
    if (_radioValue1 == -1) {
      return SizedBox.shrink();
    } else {
      print("//");
      print(_myState);
      print(sharecode);
      print(sharecodeprofileid);
      print("//");

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Share with Doctor',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.black,
          ),
          new Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Color(0xFF707070)),
              ),
              color: Colors.white,
            ),
            child: new TabBar(
              controller: _controller,
              labelStyle: TextStyle(
                  //up to your taste
                  fontWeight: FontWeight.w700),
              indicatorSize: TabBarIndicatorSize.label, //makes it better
              labelColor: Color(0xFF33CAFF), //Google's sweet blue
              unselectedLabelColor: Color(0xff707070), //niceish grey
              isScrollable: true, //up to your taste
              indicator: MD2Indicator(
                  //it begins here
                  indicatorHeight: 3,
                  indicatorColor: Color(0xFF33CAFF),
                  indicatorSize: MD2IndicatorSize
                      .normal //3 different modes tiny-normal-full
                  ),
              tabs: [
                Container(
                  width: (MediaQuery.of(context).size.width * 0.7) / 1.7,
                  child: new Tab(
                    text: 'Share Link',
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width * 0.7) / 1.7,
                  child: new Tab(
                    text: 'Scan QR',
                  ),
                ),
              ],
            ),
          ),
          new Container(
            height: 250.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'Your prescription and reports sharing URL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF858585)),
                      ),
                    ),
                    Center(
                      child: Text(
                        'with Doctor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF858585)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, right: 30.0, left: 30.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: TextField(
                          enabled: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            hintText: "https://app.famile.care/docview/" +
                                sharecodeprofileid +
                                '/' +
                                _myState +
                                '/' +
                                sharecode,
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 18),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Container(
                              decoration: BoxDecoration(
                                  // color: Color(0xFFFFEEF3),
                                  // border: Border.all(
                                  //   width: 4,
                                  //   color: Color(0xFFFFEEF3),
                                  // ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: IconButton(
                                icon: Image.asset("assets/ic-copy.png"),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: "https://app.famile.care/docview/" +
                                          sharecodeprofileid +
                                          '/' +
                                          _myState +
                                          '/' +
                                          sharecode));
                                },
                              ),
                            ),
                            suffixIcon: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF33CAFF),
                                  border: Border.all(
                                    width: 4,
                                    color: Color(0xFF33CAFF),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: IconButton(
                                icon: Icon(
                                  Icons.share_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Share.share(
                                      "https://app.famile.care/docview/" +
                                          sharecodeprofileid +
                                          '/' +
                                          _myState +
                                          '/' +
                                          sharecode);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'Your prescription and reports scan QR code',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF858585)),
                      ),
                    ),
                    Center(
                      child: Text(
                        'with Doctor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF858585)),
                      ),
                    ),
                    Center(
                      child: QrImage(
                        data: "https://app.famile.care/docview/" +
                            sharecodeprofileid +
                            '/' +
                            _myState +
                            '/' +
                            sharecode,
                        version: QrVersions.auto,
                        size: 170.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (tempp == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 250, bottom: 15),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 15,
                        icon: Icon(
                          // Add this
                          Icons.keyboard_arrow_down, // Add this
                          color: Color(0xFFFC608C), // Add this
                        ),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select Profile'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myState = newValue;
                            currentid = _myState;
//                      print(_myState);
                          });
                          changedata(_myState);

                          getJSONData(_myState, vehicaleyear);
                          editProfileUpdate(_myState);
                        },
                        items: statesList?.map((item) {
                              return new DropdownMenuItem(
                                child: Row(
                                  children: <Widget>[
//                                  i,

                                    image(item["image"].toString(),
                                        item['id'].toString()),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        // margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                      item["name"].split(' ').first,
                                      style: TextStyle(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                                value: item['id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonTheme(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal:
                                      3.0), //adds padding inside the button
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, //limits the touch area to the button area
                              minWidth: 0, //wraps child's width
                              height: 0, //wraps child's height
                              child: OutlineButton(
                                  borderSide: BorderSide(
                                      color: button1
                                          ? Color(0xFFFC608C)
                                          : Color(0xFFB5B3B4)),
                                  onPressed: () {
                                    setState(() {
                                      button1 = true;
                                      button2 = false;
                                      button3 = false;
                                    });
                                    update('default');
                                  },
                                  child: Text('Quick View',
                                      style: TextStyle(
                                          color: button1
                                              ? Color(0xFFFC608C)
                                              : Color(0xFFB5B3B4),
                                          fontSize: 10),
                                      textAlign: TextAlign
                                          .left)), //your original button
                            )
//                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
                            )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonTheme(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal:
                                      3.0), //adds padding inside the button
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, //limits the touch area to the button area
                              minWidth: 0, //wraps child's width
                              height: 0, //wraps child's height
                              child: OutlineButton(
                                  borderSide: BorderSide(
                                      color: button2
                                          ? Color(0xFFFC608C)
                                          : Color(0xFFB5B3B4)),
                                  onPressed: () {
                                    setState(() {
                                      button1 = false;
                                      button2 = true;
                                      button3 = false;
                                    });
                                    update('prescription');
                                  },
                                  child: Text('Prescription',
                                      style: TextStyle(
                                          color: button2
                                              ? Color(0xFFFC608C)
                                              : Color(0xFFB5B3B4),
                                          fontSize: 10),
                                      textAlign: TextAlign
                                          .left)), //your original button
                            )
//                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
                            )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonTheme(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal:
                                      3.0), //adds padding inside the button
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, //limits the touch area to the button area
                              minWidth: 0, //wraps child's width
                              height: 0, //wraps child's height
                              child: OutlineButton(
                                  borderSide: BorderSide(
                                      color: button3
                                          ? Color(0xFFFC608C)
                                          : Color(0xFFB5B3B4)),
                                  onPressed: () {
                                    setState(() {
                                      button1 = false;
                                      button2 = false;
                                      button3 = true;
                                    });
                                    update('report');
                                  },
                                  child: Text('Reports',
                                      style: TextStyle(
                                          color: button3
                                              ? Color(0xFFFC608C)
                                              : Color(0xFFB5B3B4),
                                          fontSize: 10),
                                      textAlign: TextAlign
                                          .left)), //your original button
                            )
//                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
                            )),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                                bottomicon.BottomNavigation.bloodgroup,
                                size: 30,
                                color: Color(0xFF858585))),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Blood Group\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: 'O+',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                                bottomicon.BottomNavigation.bloodpressure,
                                size: 30,
                                color: Color(0xFF858585))),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Blood Pressure\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: '120/80',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                                bottomicon.BottomNavigation.bloodglucose,
                                size: 30,
                                color: Color(0xFF858585))),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Blood Glucose\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: '140 mg/dL',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                                bottomicon.BottomNavigation.temperature,
                                size: 30,
                                color: Color(0xFF858585))),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Temperature\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: '98.6°F',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                              bottomicon.BottomNavigation.pulserate,
                              size: 30,
                              color: Color(0xFF858585)),
                        ),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Pulse Rate\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: '80/min',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              bottomicon.BottomNavigation.hemoglobin,
                              size: 27,
                              color: Color(0xFF858585),
                            )),
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Hemoglobin\n',
                                  style: TextStyle(
                                      color: Color(0xFFFC608C), fontSize: 14)),
                              TextSpan(
                                  text: '15 g/dL',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        // sample3(context),
        Container(
          width: double.infinity,
          // height: 200,
          child: FutureBuilder(
              future: fetchTime(),
              builder: (context, snapshot) {
                return timelist();
              }),
        ),
     
       
        belowtimeline(),


        lastbutton()
       
      ],
    );

    // throw UnimplementedError();
  }
}

class GalleryPage extends StatefulWidget {
  GalleryPage(this.data);
  final List data;

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  CarouselController buttonCarouselController = CarouselController();
  AsyncMemoizer _memoizer;
  @override
  void initState() {
    fetchTime();
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  List temp = [];
  int index;
  fetchTime() async {
    return this._memoizer.runOnce(() async {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      var profileId = myPrefs.getString('profileId');
      var url = 'https://app.famile.care/api/v1/getscrollableimages';
      var response = await http.post(url, body: {
        "profileid": profileId.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        final json = jsonDecode(response.body);
        if (json != null) {
          json.forEach((element) {
            temp.add('https://app.famile.care/prescriptions/' +
                element['id'].toString() +
                '/' +
                element['name']);
          });
          print(temp);
          var tempIndex;
          temp.asMap().forEach((index, value) => {
                if (value == widget.data[0]) {tempIndex = index}
              });
          setState(() {
            index = tempIndex;
          });
        }
      }
    });
  }

  timelist() {
    if (temp.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 250, bottom: 15),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return CarouselSlider(
        carouselController: buttonCarouselController,
        items: temp.map((imgUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  imageProvider: NetworkImage(imgUrl),
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.6,
          viewportFraction: 1,
          initialPage: index,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Color(0xFFFC608C),
        ),
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFEEF3),
      ),
      // Implemented with a PageView, simpler than setting it up yourself
      // You can either specify images directly or by using a builder as in this tutorial
      body: Column(
        children: [
          SizedBox(
            height: 45,
          ),
          Container(
            height: 400,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: fetchTime(),
                      builder: (context, snapshot) {
                        return timelist();
                      }),
                  // CarouselSlider(
                  //   carouselController: buttonCarouselController,
                  //   items: temp.map((imgUrl) {
                  //     return Builder(
                  //       builder: (BuildContext context) {
                  //         return Container(
                  //           width: MediaQuery.of(context).size.width,
                  //           decoration: BoxDecoration(
                  //             color: Theme.of(context).canvasColor,
                  //           ),
                  //           child: PhotoView(
                  //             backgroundDecoration: BoxDecoration(
                  //               color: Theme.of(context).canvasColor,
                  //             ),
                  //             imageProvider: NetworkImage(imgUrl),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   }).toList(),
                  //   options: CarouselOptions(
                  //     height: MediaQuery.of(context).size.height*0.6,
                  //     viewportFraction: 1,
                  //     initialPage: index,
                  //     enableInfiniteScroll: false,
                  //     reverse: false,
                  //     autoPlay: false,
                  //     autoPlayInterval: Duration(seconds: 3),
                  //     autoPlayAnimationDuration: Duration(milliseconds: 800),
                  //     autoPlayCurve: Curves.fastOutSlowIn,
                  //     enlargeCenterPage: true,
                  //     scrollDirection: Axis.horizontal,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () => buttonCarouselController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    FlatButton(
                      onPressed: () => buttonCarouselController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GraphDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GraphDetailState();
  }
}

class _GraphDetailState extends State<GraphDetail> {
  Future<List<Description>> getJSONData() async {
    http.post(
      "https://app.famile.care/api/v1/getprofilechartdata/detail",
      body: jsonEncode({"profile_id": "11", "year": "2021"}),
      // Only accept JSON response
      headers: {"Content-Type": "application/json"},
    ).then((response) {
      final json = jsonDecode(response.body);
      print(json);
      print(json.length);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((job) => Description.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load jobs from api');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Color(0xFFFC608C),
          ),
          title: Text(
            'Prescription History',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xFFFFEEF3),
        ),
        body: FutureBuilder<List<Description>>(
          future: getJSONData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Description> data = snapshot.data;
              if (data.length > 0) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionPanelList(
                        animationDuration: Duration(seconds: 1),
                        children: [
                          ExpansionPanel(
                            body: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'PRICE: ${data[index].followUpDate}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'QUANTITY: ${data[index].height}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  data[index].height,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                            // isExpanded: data[index],
                          )
                        ],
                        expansionCallback: (int item, bool status) {
                          setState(() {
                            // prepareData[index].isExpanded =
                            //     !prepareData[index].isExpanded;
                          });
                        },
                      );
                    },
                  ),
                );

                // Container(
                //   child:ListView.builder(
                //     itemCount: data.length,
                //     itemBuilder: (BuildContext context ,int index){

                //       return ExpansionPanelList.radio(
                //   children: [
                //     ExpansionPanelRadio(
                //       value: 1,
                //       headerBuilder: (BuildContext context, bool isExpanded) {
                //         return ListTile(
                //           title: Text(data[index].consultationDate,
                //             // "29 Aug 2020 | 21:19:35",
                //           ),
                //           subtitle: Text(data[index].doctorQualifications,
                //             // 'AIMS',
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         );
                //       },
                //       body: ListTile(
                //         title: Text("Doctor :"+ data[index].doctorName),
                //         subtitle: Text('Speciality : Neurologist'),
                //       ),
                //     ),

                //   ],
                // );
                //   })
                // );

              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class PrescriptionDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrescriptionDetailState();
  }
}

class _PrescriptionDetailState extends State<PrescriptionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Color(0xFFFC608C),
        ),
        title: Text(
          'Prescription Detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFEEF3),
      ),
      body: Container(),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales, this.segmentColor);
  final String year;
  final int sales;
  final Color segmentColor;
}

class Autogenerated {
  int count;
  String monthname;

  Autogenerated({this.count, this.monthname});

  factory Autogenerated.fromJson(Map<String, dynamic> json) {
    return Autogenerated(count: json["count"], monthname: json["monthname"]);
  }
}

class FamilePage {
  static const String Famile = 'Famile';

  static const List<String> choices = <String>[Famile];
}

class Description {
  int id;
  String docId;
  int profileId;
  String patientName;
  String patientAge;
  String patientGender;
  String doctorName;
  String doctorQualifications;
  String height;
  String weight;
  String temperature;
  String symptoms;
  String diagnosis;
  String hospital;
  String consultationDate;
  String followUpDate;
  String suggestion;
  String healthtip;
  String createdAt;
  String updatedAt;

  Description(
      {this.id,
      this.docId,
      this.profileId,
      this.patientName,
      this.patientAge,
      this.patientGender,
      this.doctorName,
      this.doctorQualifications,
      this.height,
      this.weight,
      this.temperature,
      this.symptoms,
      this.diagnosis,
      this.hospital,
      this.consultationDate,
      this.followUpDate,
       this.suggestion,
       this.healthtip,
      this.createdAt,
      this.updatedAt});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      id: json['id'],
      docId: json['doc_id'],
      profileId: json['profile_id'],
      patientName: json['patient_name'],
      patientAge: json['patient_age'],
      patientGender: json['patient_gender'],
      doctorName: json['doctor_name'],
      doctorQualifications: json['doctor_qualifications'],
      height: json['height'],
      weight: json['weight'],
      temperature: json['temperature'],
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      hospital :  json['hospital'],
      consultationDate: json['consultation_date'],
      followUpDate: json['follow_up_date'],
      // suggestion : json['suggestion'],
     // healthtip : json['healthtip'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
class DynamicExpansionTile extends StatefulWidget {
  @override
  _DynamicExpansionTileState createState() => new _DynamicExpansionTileState();
}

class _DynamicExpansionTileState extends State<DynamicExpansionTile> {
  Future<http.Response> _responseFuture;

  @override
  void initState() {
    super.initState();
    _responseFuture =

        http.post(
      "https://app.famile.care/api/v1/getprofilechartdatadetail",
      body: jsonEncode({"profile_id": "11", "year": "2021"}),
      // Only accept JSON response
      headers: {"Content-Type": "application/json"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Prescription History'),
        backgroundColor: Color(0xFFFC608C),
      ),
      body: new FutureBuilder(
        future: _responseFuture,
        builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
          if (!response.hasData) {
            return const Center(
              child: const Text('Loading...'),
            );
          } else if (response.data.statusCode != 200) {
            return const Center(
              child: const Text('Error loading data'),
            );
          } else {
            List<dynamic> json = jsonDecode(response.data.body);
 
            return new MyExpansionTileList(json);
          }
        },
      ),
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<dynamic> elementList;

  MyExpansionTileList(this.elementList);

  List<Widget> _getChildren() {
    List<Widget> children = [];
    elementList.forEach((element) {
      children.add(
        new MyExpansionTile(
          element['consultation_date'],
          element['doctor_name'],
          element['doctor_qualifications'],
          element['hospital'],
          element['diagnosis'],
          element['Medicine_data'],
          
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
print("123"+elementList.toString());

    return new ListView(
      children: _getChildren(),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final String consdate;
  final String docname;
  final String doctorqual;
  final String hos;
  final String diagnosis;
  final String medicine_data;

  MyExpansionTile(
      this.consdate, this.docname, this.doctorqual, this.hos, this.diagnosis,this.medicine_data);
  @override
  State createState() => new MyExpansionTileState();
}

class MyExpansionTileState extends State<MyExpansionTile> {
  //Future<http.Response> _responseFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("check");
    print(widget.diagnosis);
    final List<Map<String, String>> listOfColumns = [
      {
        "Name": "Abacavir ",
        "Frequency": "1",
        "Duration": "10 Days",
        "Remarks": "Before Dinner "
      },
      {
        "Name": "Alemtuzumab",
        "Frequency": "2",
        "Duration": "1 Week",
        "Remarks": "Before Dinner"
      },
      {
        "Name": "Allopurinol",
        "Frequency": "3",
        "Duration": "1 Week",
        "Remarks": "Before Dinner"
      },
    ];
    // bool open;
    return Card(
      elevation: 0,
      child: new ExpansionTile(
// initiallyExpanded: true,
        title: new Text(widget.consdate,
            style: TextStyle(fontSize: 16, color: Colors.black)),
        subtitle: widget.hos == null
            ? Text("nahi diya")
            : Text(widget.hos,
                style: TextStyle(fontSize: 14, color: Colors.grey)),
        children: <Widget>[
          Column(
            children: [
              ListTile(
                dense: true,
                title: new Text(
                  "Doctor : " + widget.docname,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                subtitle: new Text(
                  "Speciality : " + widget.doctorqual,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Diagnosis : ',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        TextSpan(
                            text: widget.diagnosis,
                            style:
                                TextStyle(color: Colors.black, fontSize: 13)),
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey, height: 2),
              DataTable(
                columnSpacing: 20,
                // dataRowHeight: 100,
                headingRowHeight: 30,
                // headingRowColor:
                headingTextStyle: TextStyle(color: Colors.black),
                dataTextStyle: TextStyle(color: Colors.grey),

                columns: [
                  DataColumn(label: Center(child: Text('Name'))),
                  DataColumn(label: Center(child: Text('Frequency'))),
                  DataColumn(label: Center(child: Text('Duration'))),
                  DataColumn(label: Center(child: Text('Remark')))
                ],
                rows:
                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(element["Name"])),
                                  DataCell(Center(
                                      child: Text(element["Frequency"]))),
                                  DataCell(
                                      Center(child: Text(element["Duration"]))),
                                  DataCell(
                                      Center(child: Text(element["Remarks"])))
                                ],
                              )),
                        )
                        .toList(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class  History {
  int id;
  String docId;
  int profileId;
  String patientName;
  String patientAge;
  String patientGender;
  String doctorName;
  String doctorQualifications;
  String height;
  String weight;
  String temperature;
  String symptoms;
  String diagnosis;
  String hospital;
  String consultationDate;
  String followUpDate;
  String suggestion;
  String healthtip;
  String createdAt;
  String updatedAt;
  List<MedicineData> medicineData;

  History(
      {this.id,
      this.docId,
      this.profileId,
      this.patientName,
      this.patientAge,
      this.patientGender,
      this.doctorName,
      this.doctorQualifications,
      this.height,
      this.weight,
      this.temperature,
      this.symptoms,
      this.diagnosis,
      this.hospital,
      this.consultationDate,
      this.followUpDate,
      this.suggestion,
      this.healthtip,
      this.createdAt,
      this.updatedAt,
      this.medicineData});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docId = json['doc_id'];
    profileId = json['profile_id'];
    patientName = json['patient_name'];
    patientAge = json['patient_age'];
    patientGender = json['patient_gender'];
    doctorName = json['doctor_name'];
    doctorQualifications = json['doctor_qualifications'];
    height = json['height'];
    weight = json['weight'];
    temperature = json['temperature'];
    symptoms = json['symptoms'];
    diagnosis = json['diagnosis'];
    hospital = json['hospital'];
    consultationDate = json['consultation_date'];
    followUpDate = json['follow_up_date'];
    suggestion = json['suggestion'];
    healthtip = json['healthtip'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['medicine_data'] != null) {
      medicineData = new List<MedicineData>();
      json['medicine_data'].forEach((v) {
        medicineData.add(new MedicineData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_id'] = this.docId;
    data['profile_id'] = this.profileId;
    data['patient_name'] = this.patientName;
    data['patient_age'] = this.patientAge;
    data['patient_gender'] = this.patientGender;
    data['doctor_name'] = this.doctorName;
    data['doctor_qualifications'] = this.doctorQualifications;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['temperature'] = this.temperature;
    data['symptoms'] = this.symptoms;
    data['diagnosis'] = this.diagnosis;
    data['hospital'] = this.hospital;
    data['consultation_date'] = this.consultationDate;
    data['follow_up_date'] = this.followUpDate;
    data['suggestion'] = this.suggestion;
    data['healthtip'] = this.healthtip;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.medicineData != null) {
      data['medicine_data'] = this.medicineData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicineData {
  int id;
  String docId;
  String name;
  String frequency;
  String duration;
  String notes;
  String createdAt;
  String updatedAt;

  MedicineData(
      {this.id,
      this.docId,
      this.name,
      this.frequency,
      this.duration,
      this.notes,
      this.createdAt,
      this.updatedAt});

  MedicineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docId = json['doc_id'];
    name = json['name'];
    frequency = json['frequency'];
    duration = json['duration'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_id'] = this.docId;
    data['name'] = this.name;
    data['frequency'] = this.frequency;
    data['duration'] = this.duration;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// class PrescriptionHistory extends StatefulWidget {
//   @override
//   _PrescriptionHistoryState createState() => _PrescriptionHistoryState();
// }

// class _PrescriptionHistoryState extends State<PrescriptionHistory> {
//   Future<List<History>> historyJSONData() async {
//     http.post(
//       "https://app.famile.care/api/v1/getprofilechartdata/detail",
//       body: jsonEncode({"profile_id": "11", "year": "2021"}),
//       headers: {"Content-Type": "application/json"},
//     ).then((response) {
//       final json = jsonDecode(response.body);
//       print(json);
//       print(json.length);
//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         return jsonResponse.map((job) =>History.fromJson(job)).toList();
//       } else {
//         throw Exception('Failed to load jobs from api');
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: new AppBar(
//         title: new Text('Prescription History'),
//         backgroundColor: Color(0xFFFC608C),
//       ),
//       body: FutureBuilder(
//         future: historyJSONData(),
//         builder:(BuildContext context ,AsyncSnapshot snapshot){
//             if(snapshot.hasData){
//               List<History> data =snapshot.data;
//               if(data.length!=0){
//                 return  ListView.builder(
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (BuildContext context, int i) {
//                     return Card(
//                       child: ExpansionPanelList(
//                         expansionCallback: (int index, bool status) {
//                           // setState(() {
//                           //   _activeMeterIndex =
//                           //       _activeMeterIndex == i ? null : i;
//                           // });
//                         },
//                         children: [
//                           ExpansionPanel(
//                             // isExpanded: _activeMeterIndex == i,
//                             headerBuilder:
//                                 (BuildContext context, bool isExpanded) =>
//                                     Container(
//                               padding: const EdgeInsets.only(left: 15.0),
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 historyJSONData,
//                               ),
//                             ),
//                             body: Column(
//                               children: snapshot.data[i].subcategory.map((e) {
//                                 return Text(e);
//                               }).toList(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );

//               }
//             }
//             return CircularProgressIndicator();
//         } )
      
//     );
//   }
// }

// Skip to content
// Pull requests
// Issues
// Marketplace
// Explore
// @flutter-vicky
// Learn Git and GitHub without any code!

// Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.
// sanket-semiqolon /
// famile.care
// Private

// 1
// 0

//     0

// Code
// Issues
// Pull requests
// Actions
// Projects
// Security

//     Insights

// famile.care/lib/screen/home.dart
// @krishnav05
// krishnav05 first commit
// Latest commit 116f29a 22 days ago
// History
// 1 contributor
// 2707 lines (2598 sloc) 98.1 KB
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter_app/screen/timeline.dart';
// import 'login.dart';
// import 'package:flutter_app/network_utils/api.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:async';
// import 'package:timeline_tile/timeline_tile.dart';
// import 'package:http/http.dart' as http;
// import 'profile_form.dart';
// import 'bottomsheet.dart';
// import 'profileconvert.dart';
// import 'profiledetail.dart';
// import 'package:flutter_app/constants.dart';
// import 'edit_profile.dart';
// import 'gallery_upload.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
// import '../pre/bottom_navigation_icons.dart' as bottomicon;
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:connectivity_widget/connectivity_widget.dart';
// import 'package:flushbar/flushbar.dart';
// import 'package:share/share.dart';
// import 'package:async/async.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:md2_tab_indicator/md2_tab_indicator.dart';

// class ImageArgs {
//   final File image;

//   ImageArgs(this.image);
// }

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home>{

// String profileId;
// bool isFloatVisible = true;
// List<Time> _times = List<Time>();
// var temp =1;
// Future<List<Time>> fetchTime() async {
//   SharedPreferences myPrefs = await SharedPreferences.getInstance();
//   profileId = myPrefs.getString('profileId');
//   var url = 'https://app.famile.care/api/v1/gettimelineinfo';
//   var response = await http.post(url,body: {
//     "profileid" : profileId.toString(),
//   });


//   var members = List<Time>();

//   if (response.statusCode == 200) {
//     print(response.body);
//     var notesJson = json.decode(response.body);
//     for (var noteJson in notesJson) {
//       members.add(Time.fromJson(noteJson));
//     }
//   }
//   temp =0;
//   return members;
// }

// //  members called here
//   List<Member> _members = List<Member>();

//   Future<List<Member>> fetchMembers() async {
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     profileId = myPrefs.getString('profileId');
//     var url = 'https://app.famile.care/api/v1/getmembers';
//     var response = await http.post(url,body: {
//       "profileid" : profileId.toString()
//     });

//     var members = List<Member>();

//     if (response.statusCode == 200) {
//       print(response.body);
//       var notesJson = json.decode(response.body);
//       for (var noteJson in notesJson) {
//         members.add(Member.fromJson(noteJson));
//       }
//     }
//     return members;
//   }
//   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

//   Position _currentPosition;
//   String _currentAddress;
//   _getCurrentLocation(){
//     geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//       });
//       _getAddressFromLatLng();
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   _getAddressFromLatLng() async {
//     try {
//       List<Placemark> p = await geolocator.placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);

//       Placemark place = p[0];

//       setState(() {
//         _currentAddress =
//         "${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//       var url = 'https://app.famile.care/api/v1/setlocation';
//       http.post(url,body: {
//         "profileid" : profileId,
//         "location" : _currentAddress,
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

// //
//   int _currentIndex = 0;
//   int _value = 1;
//   final titleText = [
//     Text('Timeline',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
//     Text('Dashboard',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
//     Text('Profile',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
//     Text('Share',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
//   ];
//   SharedPreferences myPrefs;
//   void getinfo() async{
//     myPrefs = await SharedPreferences.getInstance();
//     SharedPreferences myPref = await SharedPreferences.getInstance();
//     profileId = myPref.getString('profileId');
//   }




//   List tabs = [];
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//       tabs = [
//         Column(
//           children: [
//             ConnectivityWidget(
//                 showOfflineBanner: true,
//                 offlineBanner: Flushbar(
//                   message: "No Internet Connection",
//                   backgroundColor: Colors.red,
//                 ),
//                 builder: (context, isOnline) => Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       // Text("${isOnline ? 'Online' : 'Offline'}", style: TextStyle(fontSize: 30, color: isOnline ? Colors.green : Colors.red),),

//                     ],
//                   ),
//                 )
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     FutureBuilder(
//                         future: fetchTime(),
//                         builder: ( context,  snapshot) {
//                           return timelist();
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),

//         Scaffold(
//           body: Column(
//             children: [
//               ConnectivityWidget(
//                   showOfflineBanner: true,
//                   offlineBanner: Flushbar(
//                     message: "No Internet Connection",
//                     backgroundColor: Colors.red,
//                   ),
//                   builder: (context, isOnline) => Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         // Text("${isOnline ? 'Online' : 'Offline'}", style: TextStyle(fontSize: 30, color: isOnline ? Colors.green : Colors.red),),

//                       ],
//                     ),
//                   )
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       DashboardPage(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
// //    Center(child: Text('Dashboard')),

//       Column(
//         children: [
//           ConnectivityWidget(
//               showOfflineBanner: true,
//               offlineBanner: Flushbar(
//                 message: "No Internet Connection",
//                 backgroundColor: Colors.red,
//               ),
//               builder: (context, isOnline) => Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     // Text("${isOnline ? 'Online' : 'Offline'}", style: TextStyle(fontSize: 30, color: isOnline ? Colors.green : Colors.red),),

//                   ],
//                 ),
//               )
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                   children: <Widget>[
//                     ProfilePage(),
//                   ]
//               ),
//             ),
//           ),
//         ],
//       ),

//         Column(
//           children: [
//             ConnectivityWidget(
//                 showOfflineBanner: true,
//                 offlineBanner: Flushbar(
//                   message: "No Internet Connection",
//                   backgroundColor: Colors.red,
//                 ),
//                 builder: (context, isOnline) => Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       // Text("${isOnline ? 'Online' : 'Offline'}", style: TextStyle(fontSize: 30, color: isOnline ? Colors.green : Colors.red),),

//                     ],
//                   ),
//                 )
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       width:MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height*0.55,
//                       color: Color(0xFFFC608C),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height*0.075,
//                           ),
//                           Text('Share & Care',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold)),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height*0.070,
//                           ),
//                           Image.asset("assets/ic-share.png"),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height*0.035,
//                           ),
//                           Text('Care for loved ones !',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
//                           Text('Share Famile Care to arrange',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
//                           Text('medical records',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height*0.075,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left:30.0),
//                       child: Align(alignment:Alignment.centerLeft,child: Text('Share your link',style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top:10.0,right: 30.0,left: 30.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Color(0xFFFC608C),
//                             ),
//                             borderRadius: BorderRadius.all(Radius.circular(5))
//                         ),
//                         child: TextField(
//                           enabled: true,
//                           readOnly: true,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.all(15.0),
//                             hintText: 'Semiqolon',
//                             hintStyle: TextStyle(color: Colors.black54,fontSize: 18),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             suffixIcon: Container(
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFFFEEF3),
//                                 border: Border.all(
//                                   width: 4,
//                                   color: Color(0xFFFFEEF3),
//                                 ),
//                                   borderRadius: BorderRadius.all(Radius.circular(5))
//                               ),
//                               child: IconButton(
//                                           icon: Image.asset("assets/ic-copy.png"),
//                                           onPressed: () {Share.share('https://www.semiqolon.com/');},
//                                        ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//     ];

//     super.didChangeDependencies();
//   }


// //CALLING STATE API HERE
// // Get State information by API
//   image(String s,String q){
//     if(s == 'default')
//     {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(5.0),
//         child: Image.network('https://app.famile.care/default.png',width: 40,height: 40,fit: BoxFit.fill,),
//       );
//     }
//     else{
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(5.0),
//         child: Image.network('https://app.famile.care/prescriptions/'+q+'/avatar.jpg',width: 40,height: 40,fit: BoxFit.fill,),
//       );
//     }
//   }

//   membersList()
//   {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: image(_members[index].image,_members[index].memberid),
//           title: Text(_members[index].name,style: TextStyle(color: Color(0xFF000000),fontSize: 16),),
//           onTap: ()  {

//           myPrefs.setString('memberidselected', _members[index].memberid);
//             print(_members[index].memberid);
//           Navigator.of(context).pop();
//             showAlertDialog(context);
//           },
//         );
//       },
//       itemCount: _members.length,
//     );
//   }
//   createlist(List s, String b)
//   { List temp = [];
//     for(var item in s)
//       {
//         temp.add('https://app.famile.care/prescriptions/'+b+'/'+item);
//       }
//     print(temp);
//     return temp;
//   }

//   timelist()
//   {
//     if(temp == 1){
//       return Padding(
//         padding: const EdgeInsets.only(top: 250,bottom: 15),
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if(_times.isEmpty)
//     {
//        return Center(
//          child: Column(
//            children: [
//              SizedBox(
//                height: 180,
//              ),
//              Text('There is nothing to show',style: TextStyle(color: Colors.black,fontSize: 24)),
//              RichText(
//                text: TextSpan(
//                  children: [
//                    TextSpan(text: 'in ',style: TextStyle(color: Colors.black,fontSize: 24)),
//                    TextSpan(text: 'your timeline',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24)),
//                  ]
//                ),
//              ),
//              SizedBox(
//                height: 18,
//              ),
//              Text('You can start by uploading your first',style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14)),
//              Text('medical report or prescription slip',style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 14)),
//              SizedBox(
//                height: 22,
//              ),
//              Container(
//                height: 48.6,
//                width: 190,
//                child: FlatButton(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(25.0),
//                      side: BorderSide(color: Color(0xFFFC608C))),
//                  onPressed: onPressed,
//                  color: Color(0xFFFC608C),
//                  textColor: Colors.white,
//                  child: Row(
//                    children: [
//                      Icon(Icons.camera_alt),
//                      Text("  Upload a document",
//                          style: TextStyle(fontSize: 14)),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//        );
//     }
//     return ListView.builder(
//       physics: ClampingScrollPhysics(),
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => GalleryPage(createlist(_times[index].images, _times[index].id))),

//           ),
//           child: Container(
//             margin: const EdgeInsets.only(left: 30.0,right: 30.0),
//             child: TimelineTile(
//                 indicatorStyle: const IndicatorStyle(
//                   width: 20,
//                   color: Color(0xFF55F2CD),
//                 ),
//                 topLineStyle: const LineStyle(
//                   width: 6,
//                   color: Color(0xFFABFFEB),
//                 ),
//                 bottomLineStyle: const LineStyle(
//                   width: 6,
//                   color: Color(0xFFABFFEB),
//                 ),
//                 rightChild: Padding(
//                   padding: const EdgeInsets.only(left:25.0,top: 40.0,bottom: 40.0),
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(_times[index].date+' | '+_times[index].time ,style: TextStyle(color: Color(0xFF686868)),textAlign: TextAlign.left),
//                                   ),
//                                 ),
//                                 Container(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(_times[index].doc+' Documents Uploaded',style: TextStyle(color: Color(0xFFFC608C)),textAlign: TextAlign.left),
//                                     )
//                                 ),
//                                 Container(
//                                     child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: ButtonTheme(
//                                           padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), //adds padding inside the button
//                                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
//                                           minWidth: 0, //wraps child's width
//                                           height: 0, //wraps child's height
//                                           child: OutlineButton(onPressed: null, child: Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left)), //your original button
//                                         )
// //                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
//                                     )
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     ClipRRect(borderRadius: BorderRadius.circular(5.0),child: Image.network('https://app.famile.care/prescriptions/'+_times[index].id+'/'+_times[index].firstimage,width: 60,height: 110,fit: BoxFit.fill,)),
//                                     Text(_times[index].count)
//                                   ],
//                                 )

//                               ],
//                             )
//                           ],
//                         ), 
//                       )
                      
//                     ],
//                   ),
//                 )
//             ),
//           ),
//         );
//       },
//       itemCount: _times.length,
//     );
//   }

//   showAlertDialog(BuildContext context) {

//     Widget openCameraButton = FlatButton(
//       child: Text("Take Picture"),
//       onPressed: () {
// //        Navigator.of(context).pop();
//         openCamera();},
//     );

//     Widget openGalleryButton = FlatButton(
//       child: Text("Open Gallery"),
//       onPressed: () {
// //        Navigator.of(context).pop();
//         openGallery();},
//     );

//     // set up the button
// //    Widget cancelButton = FlatButton(
// //      child: Text("Cancel"),
// //      onPressed: () {Navigator.of(context).pop(); },
// //    );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Choose from where to pick image"),
//       content: Text("Either from camera or from gallery"),
//       actions: [
//         openCameraButton,openGalleryButton
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   String name;
//   @override
//   void initState(){

//     getinfo();
//     fetchTime().then((value) {
//       setState(() {
//         _times.addAll(value);
//       });
//     });
//     timelist();
//     fetchMembers().then((value) {
//       setState(() {
//         _members.addAll(value);
//       });
//     });
//     _getCurrentLocation();
//     _loadUserData();
//     super.initState();
//   }
//   _loadUserData() async{
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var user = jsonDecode(localStorage.getString('user'));

//     if(user != null) {
//       setState(() {
//         name = user['fname'];
//       });
//     }
//   }

//   addMember()
//   { Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => MyCustomForm()),
//   );
//   }

//   void onPressed()
//   {
//     showModalBottomSheet(context: context, builder: (context){
//       return Container(
//         color: Color(0xFF737373),
//         height: 1250,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(10),
//                   topRight: const Radius.circular(10)
//               )
//           ),
//           child: Column(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.add,color: Color(0xFFFC608C),),
//                 title: Text('Add New Member',style: TextStyle(color: Color(0xFFFC608C),fontSize: 16),),
//                 onTap: addMember,
//               ),
//               Container(
//                   height:1.0,
//                   width:double.infinity,
//                   color:Color(0xFFE8E8E8)),
//               Expanded(
//                 child: membersList(),
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> openCamera() async {
//     // ignore: deprecated_member_use
//     var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 85);
//     if(image != null){
//       Navigator.pushNamed(context, '/view-image', arguments: ImageArgs(image));
//     }
//   }

//   Future<void> openGallery()
//   async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Upload()),
//     );
//     // ignore: deprecated_member_use
// //    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
// //    if(image != null){
// //      Navigator.pushNamed(context, '/view-image', arguments: ImageArgs(image));
// //    }
//   }

//   @override
//   Widget build(BuildContext context) {
//     FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFEEF3));
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         title: titleText[_currentIndex],
//         backgroundColor: Color(0xFFFFEEF3),
//         actions: <Widget>[
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert,color: Color(0xFFFC608C)),
//             onSelected: choiceAction,
//             itemBuilder: (BuildContext context){
//               if(_currentIndex == 2 && _members.isNotEmpty){
//                 return Constants.choices.map((String choice){
//                   return PopupMenuItem<String>(
//                     value: choice,
//                     child: Text(choice),
//                   );
//                 }).toList();
//               }

//             },
//           ),
//         ],
//       ),
//       body: tabs[_currentIndex],
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom:15.0),
//         child: Visibility(
//           child: FloatingActionButton(
//             child: Icon(Icons.camera_alt),
//             backgroundColor: Color(0xFFFC608C),
//             onPressed: () {
// //          showAlertDialog(context);
//             onPressed();
//             },
//           ),
//           visible: isFloatVisible,
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         type: BottomNavigationBarType.fixed,
//         iconSize: 30,
//         selectedItemColor: Color(0xFFFC608C),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(bottomicon.BottomNavigation.timeline,size: 25,),
//             title: Text('Timeline'),
//             backgroundColor: Colors.white
//           ),

//           BottomNavigationBarItem(
//               icon: Icon(bottomicon.BottomNavigation.dashboard,size: 25,),
//               title: Text('Dashboard'),
//               backgroundColor: Colors.white
//           ),

//           BottomNavigationBarItem(
//               icon: Icon(bottomicon.BottomNavigation.profile,size: 25,),
//               title: Text('Profile'),
//               backgroundColor: Colors.white
//           ),

//           BottomNavigationBarItem(
//               icon: Icon(Icons.share_outlined,size: 25,),
//               title: Text('Share'),
//               backgroundColor: Colors.white
//           )
//         ],
//         onTap: (index) {
//           if(index == 3)
//             {
//               setState(() {
//                 isFloatVisible = false;
//               });
//             }
//           else{
//             setState(() {
//               isFloatVisible = true;
//             });
//           }
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   void choiceAction(String choice)
//   {
//     if(choice == Constants.EditProfile){
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => EditProfile()),
//       );
//     }
//   }


//   void logout() async{
//     var res = await Network().getData('/logout');
//     var body = json.decode(res.body);
//     if(body['success']){
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.remove('user');
//       localStorage.remove('token');
//       Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context)=>Login()));
//     }
//   }
// }

// class ProfilePage extends StatefulWidget{
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
// class _ProfilePageState extends State<ProfilePage>{

//   void initState() {
//     getinfo();
//     _getProfileList();
//     super.initState();
//   }

//   var tempp = 1;
//   //profile data start
//   String age = ".....";
//   String blood = ".....";
//   String height = ".....";
//   String weight = "......";
//   String occupation = ".....";
//   String email = ".....";
//   String mobile = ".....";
//   String state = ".....";
//   String city = ".....";
//   String address = ".....";

//   void changedata(String s){
//     print(s);
//     setState(() {
//       String url = "https://app.famile.care/api/v1/profiledetail";
//       http.post(url,body: {
//         "memberid" : s,
//       }).then((response) {
//         var data = json.decode(response.body);
//         var user = UserDetail.fromJson(data[0]);
//         setState(() {
//           age = '${user.age}';
//           blood = '${user.blood}';
//           height = '${user.height}';
//           weight = '${user.weight}';
//           occupation = '${user.occupation}';
//           email = '${user.email}';
//           mobile = '${user.mobile}';
//           state = '${user.state}';
//           city = '${user.city}';
//           address = '${user.address}';
//           tempp = 0;

//         });
// //      print(statesList);
//       });
//     });
//   }

//   //profile data end

//   List statesList;
//   String _myState;
//   String profileid;
//   editProfileUpdate(String s) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('editProfileId', s);
//   }
//   getinfo() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     profileid = prefs.getString('profileId');
//   }

//   String stateInfoUrl = 'https://app.famile.care/api/v1/profile';
//   Future<String> _getProfileList() async {
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     profileid = myPrefs.getString('profileId');
//     await http.post(stateInfoUrl,body: {
//       "profileid" : profileid.toString()
//     }).then((response) {
//       var data = json.decode(response.body);
//       var temp = data[0];
//       var user = User.fromJson(temp);
//       editProfileUpdate('${user.id}'.toString());
//       changedata('${user.id}'.toString());
//       setState(() {
//         _myState = '${user.id}'.toString();
//         statesList = data;
//       });
// //      print(statesList);
//     });
//   }

//   image(String s,String q){
//     if(s == 'default')
//       {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(5.0),
//           child: Image.network('https://app.famile.care/default.png',width: 40,height: 40,fit: BoxFit.fill,),
//         );
//       }
//     else{
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(5.0),
//           child: Image.network('https://app.famile.care/prescriptions/'+q+'/avatar.jpg',width: 40,height: 40,fit: BoxFit.fill,),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if(tempp == 1){
//     //   return Padding(
//     //     padding: const EdgeInsets.only(top: 250),
//     //     child: Center(
//     //       child: CircularProgressIndicator(),
//     //     ),
//     //   );
//     // }
//     // TODO: implement build
//     return Column(
//         children: <Widget>[
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: DropdownButtonHideUnderline(
//                       child: ButtonTheme(
//                         alignedDropdown: true,
//                         child: DropdownButton<String>(
//                           value: _myState,
//                           iconSize: 30,
//                           icon: Icon(                // Add this
//                             Icons.keyboard_arrow_down,  // Add this
//                             color: Color(0xFFFC608C),   // Add this
//                           ),
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 16,
//                           ),
//                           hint: Text('Select Profile'),
//                           onChanged: (String newValue) {
//                             setState(() {
//                               _myState = newValue;
// //                      print(_myState);
//                             });
//                             changedata(_myState);
//                             editProfileUpdate(_myState);
//                           },
//                           items: statesList?.map((item) {
//                             return new DropdownMenuItem(
//                               child: Row(
//                                 children: <Widget>[
// //                                  i,
//                                 image(item["image"].toString(),item['id'].toString()),
//                                   Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: Text(item["name"],style: TextStyle(color: Colors.black))
//                                   )
//                                 ],
//                               ),
//                               value: item['id'].toString(),
//                             );
//                           })?.toList() ??
//                               [],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(40.0),
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Age',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$age',style: TextStyle(color: Colors.black,fontSize: 16)),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Blood',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$blood',style: TextStyle(color: Colors.black,fontSize: 16)),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Height',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$height',style: TextStyle(color: Colors.black,fontSize: 16)),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Weight',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$weight',style: TextStyle(color: Colors.black,fontSize: 16)),
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Occupation',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$occupation',style: TextStyle(color: Colors.black,fontSize: 16))
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Email',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$email',style: TextStyle(color: Colors.black,fontSize: 16))
//                         ],
//                       ),

//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Mobile',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$mobile',style: TextStyle(color: Colors.black,fontSize: 16))
//                         ],
//                       )

//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('State',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$state',style: TextStyle(color: Colors.black,fontSize: 16))
//                         ],
//                       )

//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('City',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('$city',style: TextStyle(color: Colors.black,fontSize: 16))
//                         ],
//                       )

//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Address',style: TextStyle(color: Color(0xFFFC608C),fontSize: 12)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: 300,
//                             child: Text('$address',style: TextStyle(color: Colors.black,fontSize: 16),maxLines: 6),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//     );



//     throw UnimplementedError();
//   }

// }

// class DashboardPage extends StatefulWidget{
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }
// class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin{
//   _onTap(BuildContext context, Widget widget) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           appBar: AppBar(),
//           body: widget,
//         ),
//       ),
//     );
//   }
//   AsyncMemoizer _memoizer;
//   String profileId;
//   SharedPreferences myPrefs;
//   CarouselController buttonCarouselController = CarouselController();
//   void getinfo() async{
//     myPrefs = await SharedPreferences.getInstance();
//     profileId = myPrefs.getString('profileId');
//   }
//   List<Time> _times = List<Time>();
//   var temp =1;
//   List imageList = [];
//   Future<List<Time>> fetchTime() async {
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     profileId = myPrefs.getString('profileId');
//     var url = 'https://app.famile.care/api/v1/gettimelineinfo';
//     var response = await http.post(url,body: {
//       "profileid" : profileId.toString(),
//     });

//     var members = List<Time>();

//     if (response.statusCode == 200) {
//       print(response.body);
//       var notesJson = json.decode(response.body);
//       for (var noteJson in notesJson) {
//         members.add(Time.fromJson(noteJson));
//       }
//     }
//     temp =0;
//     return members;
//   }
//   timelist(){
//     if(timelinemode == 'default')
//       { return SizedBox.shrink();
//         return Container(
//           height: 100,
//           child: ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 150,
//                 height: 90,
//                 child: Column(
//                   children: [
//                     Text(
//                       _times[index].date,
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Expanded(
//                           child: Divider(
//                             thickness: 3,
//                             color: Colors.blue,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: Theme(
//                             data: ThemeData(
//                               unselectedWidgetColor: Colors.blue,
//                             ),
//                             child: Radio(
//                               activeColor: Color(0xFF9F4576),
//                               value: _times[index].groupid,
//                               groupValue: _radioValue1,
//                               onChanged: _handleRadioValueChange1,
//                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             thickness: 3,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       'Prescription',
//                       style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               );

//             },
//             itemCount: _times.length,
//           ),
//         );
//       }
//     if(timelinemode == 'prescription')
//       {
//         return Container(
//           height: 400,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CarouselSlider(
//                     carouselController: buttonCarouselController,
//                     items: imageList.map((imgUrl) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return Container(
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).canvasColor,
//                             ),
//                             child: PhotoView(
//                               backgroundDecoration: BoxDecoration(
//                                 color: Theme.of(context).canvasColor,
//                               ),
//                               imageProvider: NetworkImage(imgUrl),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                     options: CarouselOptions(
//                       height: MediaQuery.of(context).size.height*0.6,
//                       viewportFraction: 1,
//                       initialPage: 0,
//                       enableInfiniteScroll: false,
//                       reverse: false,
//                       autoPlay: false,
//                       autoPlayInterval: Duration(seconds: 3),
//                       autoPlayAnimationDuration: Duration(milliseconds: 800),
//                       autoPlayCurve: Curves.fastOutSlowIn,
//                       enlargeCenterPage: true,
//                       scrollDirection: Axis.horizontal,
//                     ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     if(timelinemode == 'report')
//       {
//         return Center(
//           child: Text('No Reports Available Yet',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFFFC608C)),),
//         );
//       }
//   }
//   var sharecode = '0000';
//   var sharecodeprofileid;
//   Future fetchsharecode() async{
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     profileId = myPrefs.getString('profileId');
//     sharecodeprofileid = myPrefs.getString('profileId');
//     var url = 'https://app.famile.care/api/v1/sharecode';
//     var response = await http.post(url,body: {
//       "id" : profileId.toString(),
//     });
//     if (response.statusCode == 200) {
//       var notesJson = json.decode(response.body);
//       print(notesJson['sharecode']);
//       setState(() {
//         sharecode = notesJson['sharecode'];
//       });
//     }
//   }
//   TabController _controller;
//   void initState() {
//     _controller = TabController(length: 2, vsync: this);
//     fetchsharecode();
//     fetchTime().then((value) {
//       setState(() {
//         _times.addAll(value);
//       });
//       for(var i = 0; i < _times.length; i++){
//         if(i==0){
//           setState(() {
//             _radioValue1 = _times[i].groupid;
//           });
//         }
//       }
//     });

//     timelist();
//     _getProfileList();
//     super.initState();
//   }
//   List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];

//   bool showAvg = false;
//   var tempp = 1;
//   var touch = 0;
//   bool button1 = true;
//   bool button2 = false;
//   bool button3 = false;
//   //profile data start
//   String timelinemode = 'default';
//   String age = ".....";
//   String blood = ".....";
//   String height = ".....";
//   String weight = "......";
//   String occupation = ".....";
//   String email = ".....";
//   String mobile = ".....";
//   String state = ".....";
//   String city = ".....";
//   String address = ".....";

//   createlist(List s, String b)
//   { List temp = [];
//   for(var item in s)
//   {
//     temp.add('https://app.famile.care/prescriptions/'+b+'/'+item);
//   }
//   print(temp);
//   setState(() {
//     imageList = temp;
//   });
//   }

//   void changedata(String s){
//     print('pleasedont');
//     print(s);
//     setState(() {
//       String url = "https://app.famile.care/api/v1/profiledetail";
//       http.post(url,body: {
//         "memberid" : s,
//       }).then((response) {
//         var data = json.decode(response.body);
//         String reencode = json.encode(data[0]);
//         var tagsJson = jsonDecode(reencode)['image_links'];
//         List<String> tags = tagsJson != null ? List.from(tagsJson) : null;
//         createlist(tags, s);
//         var user = UserDetail.fromJson(data[0]);
//         setState(() {
//           age = '${user.age}';
//           blood = '${user.blood}';
//           height = '${user.height}';
//           weight = '${user.weight}';
//           occupation = '${user.occupation}';
//           email = '${user.email}';
//           mobile = '${user.mobile}';
//           state = '${user.state}';
//           city = '${user.city}';
//           address = '${user.address}';
//         });
// //      print(statesList);
//       });
//     });
//   }

//   //profile data end

//   List statesList;
//   String _myState;
//   editProfileUpdate(String s) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('editProfileId', s);
//   }

//   String stateInfoUrl = 'https://app.famile.care/api/v1/profile';
//   Future<String> _getProfileList() async {
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     profileId = myPrefs.getString('profileId');
//     await http.post(stateInfoUrl,body: {
//       "profileid" : profileId.toString()
//     }).then((response) {
//       var data = json.decode(response.body);
//       var temp = data[0];
//       var user = User.fromJson(temp);
//       editProfileUpdate('${user.id}'.toString());
//       changedata('${user.id}'.toString());
//       setState(() {
//         _myState = '${user.id}'.toString();
//         statesList = data;
//         tempp = 0;
//       });

// //      print(statesList);
//     });
//   }

//   image(String s,String q){
//     if(s == 'default')
//     {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(4.0),
//         child: Image.network('https://app.famile.care/default.png',width: 36,height: 36,fit: BoxFit.fill,),
//       );
//     }
//     else{
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(4.0),
//         child: Image.network('https://app.famile.care/prescriptions/'+q+'/avatar.jpg',width: 36,height: 36,fit: BoxFit.fill,),
//       );
//     }
//   }
//   int _radioValue1 = -1;
//   void _handleRadioValueChange1(int value) {
//     setState(() {
//       _radioValue1 = value;
//       print(_radioValue1);
//     });
//   }
//   update(String value)
//   {
//     setState(() {
//       timelinemode = value;
//       _radioValue1 = -1;
//       print(value);
//     });
//   }

//   lastbutton()
//   {
//     if(_radioValue1 == -1)
//     {
//       return SizedBox.shrink();
//     }
//     else
//     {
//       return SizedBox.shrink();
//       return SizedBox(
//         height: 50,
//         width: MediaQuery.of(context).size.width*0.7,
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => GraphDetail()),
//             );
//           },
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(7.0),),
//           color: Color(0xFF33CAFF),
//           child: Text("Prescription History".toUpperCase(),
//               style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
//         ),
//       );
//     }
//   }

//   belowtimeline()
//   {
//     if(_radioValue1 == -1)
//     {
//       return SizedBox.shrink();
//     }
//     else
//     {
//       return Padding(
//         padding: const EdgeInsets.only(bottom:20.0,left: 20.0,right: 20.0,top: 0.0),
//         child: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 265,
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(width: 1.0, color: Color(0xFF707070)),
//                           ),
//                           color: Colors.white,
//                         ),
//                         child: DefaultTabController(
//                           length:_times.length,
//                           initialIndex: 0,
//                           child: TabBar(
//                             labelStyle: TextStyle( //up to your taste
//                                 fontWeight: FontWeight.w700
//                             ),
//                             indicatorSize: TabBarIndicatorSize.label, //makes it better
//                             labelColor: Color(0xff000000), //Google's sweet blue
//                             unselectedLabelColor: Color(0xff707070), //niceish grey
//                             isScrollable: true, //up to your taste
//                             indicator: MD2Indicator( //it begins here
//                                 indicatorHeight: 3,
//                                 indicatorColor: Color(0xffFC608C),
//                                 indicatorSize: MD2IndicatorSize.normal //3 different modes tiny-normal-full
//                             ),
//                             tabs: <Widget>[
//                               for(var item in _times ) Container(width:(MediaQuery.of(context).size.width-50)/3 ,child: Tab(text: item.date))
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(0.0),
//                         child: Table(
//                           border: TableBorder(horizontalInside: BorderSide(width: 0.5, color: Color(0xFF707070))),
//                           columnWidths: {
//                             0: FlexColumnWidth(2),
//                             1: FlexColumnWidth(5)
//                           },
//                           children: [
//                             TableRow(
//                                 children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Doctor Name',style: TextStyle(fontSize: 14,color: Colors.black26)),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Dr.Abhishek Goyal',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
//                               )
//                             ]),
//                             TableRow(children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Hospital',style: TextStyle(fontSize: 14,color: Colors.black26)),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Hinduja',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
//                               )
//                             ]),
//                             TableRow(children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Location',style: TextStyle(fontSize: 14,color: Colors.black26)),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Mumbai',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
//                               )
//                             ]),
//                             TableRow(children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Speciality',style: TextStyle(fontSize: 14,color: Colors.black26)),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 8.0,right: 8.0),
//                                 child: Text('Pediatrician',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
//                               )
//                             ])
//                           ],
//                         ),
//                       ),
//                       // RichText(
//                       //   text: TextSpan(
//                       //       children: [
//                       //         TextSpan(text: 'Doctor Name  ',style: TextStyle(fontSize: 18,color: Colors.black54)),
//                       //         TextSpan(text: 'Dr. Abhishek Goyal',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black45))
//                       //       ]
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 20,
//                       // ),
//                       // RichText(
//                       //   text: TextSpan(
//                       //       children: [
//                       //         TextSpan(text: 'Hospital           ',style: TextStyle(fontSize: 18,color: Colors.black54) ),
//                       //         TextSpan(text: 'Hinduja',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black45))
//                       //       ]
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 20,
//                       // ),
//                       // RichText(
//                       //   text: TextSpan(
//                       //       children: [
//                       //         TextSpan(text: 'Location          ',style: TextStyle(fontSize: 18,color: Colors.black54)),
//                       //         TextSpan(text: 'Mumbai',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black45))
//                       //       ]
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 20,
//                       // ),
//                       // RichText(
//                       //   text: TextSpan(
//                       //       children: [
//                       //         TextSpan(text: 'Speciality        ',style: TextStyle(fontSize: 18,color: Colors.black54)),
//                       //         TextSpan(text: 'Pediatrician',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black45))
//                       //       ]
//                       //   ),
//                       // ),
//                       Spacer(),
//                       SizedBox(
//                         height: 51,
//                         width: MediaQuery.of(context).size.width,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => GraphDetail()),
//                             );
//                           },
//                           child: new Container(
//                             decoration: new BoxDecoration(
//                               color: Color(0xFF33CAFF),
//                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7.0),bottomRight: Radius.circular(7.0)),
//                             ),
//                             child: new Center(child: Text("Prescription History".toUpperCase(),
//                                 style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               // Center(
//               //   child: QrImage(
//               //     data: "https://app.famile.care/docview/"+sharecodeprofileid+'/'+_myState+'/'+sharecode,
//               //     version: QrVersions.auto,
//               //     size: 200.0,
//               //   ),
//               // ),
//               SizedBox(
//                 height: 30,
//               ),
//               Text('Share with Doctor',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
//               SizedBox(
//                 height: 5,
//               ),
//               Divider(
//                 color: Colors.black,
//               ),
//               new Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(width: 1.0, color: Color(0xFF707070)),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: new TabBar(
//                   controller: _controller,
//                     labelStyle: TextStyle( //up to your taste
//                         fontWeight: FontWeight.w700
//                     ),
//                     indicatorSize: TabBarIndicatorSize.label, //makes it better
//                     labelColor: Color(0xFF33CAFF), //Google's sweet blue
//                     unselectedLabelColor: Color(0xff707070), //niceish grey
//                     isScrollable: true, //up to your taste
//                     indicator: MD2Indicator( //it begins here
//                         indicatorHeight: 3,
//                         indicatorColor: Color(0xFF33CAFF),
//                         indicatorSize: MD2IndicatorSize.normal //3 different modes tiny-normal-full
//                     ),
//                     tabs: [
//                     Container(
//                       width: (MediaQuery.of(context).size.width*0.7)/2,
//                       child: new Tab(
//                         text: 'Share Link',
//                       ),
//                     ),
//                     Container(
//                       width: (MediaQuery.of(context).size.width*0.7)/2,
//                       child: new Tab(
//                         text: 'Scan QR',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               new Container(
//                 height: 250.0,
//                 child: new TabBarView(
//                   controller: _controller,
//                   children: <Widget>[
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Center(
//                           child: Text('Your prescription and reports sharing URL',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF858585)),),
//                         ),
//                         Center(
//                           child: Text('with Doctor',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF858585)),),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top:10.0,right: 30.0,left: 30.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.black12,
//                                 ),
//                                 borderRadius: BorderRadius.all(Radius.circular(5))
//                             ),
//                             child: TextField(
//                               enabled: true,
//                               readOnly: true,
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.all(15.0),
//                                 hintText: "https://app.famile.care/docview/"+sharecodeprofileid+'/'+_myState+'/'+sharecode,
//                                 hintStyle: TextStyle(color: Colors.black54,fontSize: 18),
//                                 border: InputBorder.none,
//                                 focusedBorder: InputBorder.none,
//                                 prefixIcon: Container(
//                                   decoration: BoxDecoration(
//                                       // color: Color(0xFFFFEEF3),
//                                       // border: Border.all(
//                                       //   width: 4,
//                                       //   color: Color(0xFFFFEEF3),
//                                       // ),
//                                       borderRadius: BorderRadius.all(Radius.circular(5))
//                                   ),
//                                   child: IconButton(
//                                     icon: Image.asset("assets/ic-copy.png"),
//                                     onPressed: () {Clipboard.setData(ClipboardData(text: "https://app.famile.care/docview/"+sharecodeprofileid+'/'+_myState+'/'+sharecode));},
//                                   ),
//                                 ),
//                                 suffixIcon: Container(
//                                   decoration: BoxDecoration(
//                                       color: Color(0xFF33CAFF),
//                                       border: Border.all(
//                                         width: 4,
//                                         color: Color(0xFF33CAFF),
//                                       ),
//                                       borderRadius: BorderRadius.all(Radius.circular(5))
//                                   ),
//                                   child: IconButton(
//                                     icon: Icon(Icons.share_outlined,size: 25,color: Colors.white,),
//                                     onPressed: () {Share.share("https://app.famile.care/docview/"+sharecodeprofileid+'/'+_myState+'/'+sharecode);},
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Center(
//                           child: Text('Your prescription and reports scan QR code',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF858585)),),
//                         ),
//                         Center(
//                           child: Text('with Doctor',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF858585)),),
//                         ),
//                         Center(
//                           child: QrImage(
//                             data: "https://app.famile.care/docview/"+sharecodeprofileid+'/'+_myState+'/'+sharecode,
//                             version: QrVersions.auto,
//                             size: 170.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     // if(tempp == 1){
//     //   return Padding(
//     //     padding: const EdgeInsets.only(top: 250,bottom: 15),
//     //     child: Center(
//     //       child: CircularProgressIndicator(),
//     //     ),
//     //   );
//     // }
//     return Column(
//       children: <Widget>[
//         Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               SizedBox(
//                 width: MediaQuery.of(context).size.width*0.4,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: DropdownButtonHideUnderline(
//                     child: ButtonTheme(
//                       alignedDropdown: true,
//                       child: DropdownButton<String>(
//                         value: _myState,
//                         iconSize: 15,
//                         icon: Icon(                // Add this
//                           Icons.keyboard_arrow_down,  // Add this
//                           color: Color(0xFFFC608C),   // Add this
//                         ),
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 16,
//                         ),
//                         hint: Text('Select Profile'),
//                         onChanged: (String newValue) {
//                           setState(() {
//                             _myState = newValue;
// //                      print(_myState);
//                           });
//                           changedata(_myState);
//                           editProfileUpdate(_myState);
//                         },
//                         items: statesList?.map((item) {
//                           return new DropdownMenuItem(
//                             child: Row(
//                               children: <Widget>[
// //                                  i,

//                                   image(item["image"].toString(),item['id'].toString()),
//                                 SizedBox(width: 10,),
//                                 Container(
//                                     // margin: EdgeInsets.only(left: 10),
//                                     child: Text(item["name"].split(' ').first,style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,)
//                                 )
//                               ],
//                             ),
//                             value: item['id'].toString(),
//                           );
//                         })?.toList() ??
//                             [],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width*0.6,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ButtonTheme(
//                               padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), //adds padding inside the button
//                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
//                               minWidth: 0, //wraps child's width
//                               height: 0, //wraps child's height
//                               child: OutlineButton(borderSide: BorderSide(color: button1?Color(0xFFFC608C):Color(0xFFB5B3B4)),onPressed: () {setState(() {
//                                 button1 = true;
//                                 button2 = false;
//                                 button3 = false;
//                               });update('default');}, child: Text('Quick View',style: TextStyle(color: button1?Color(0xFFFC608C):Color(0xFFB5B3B4),fontSize: 10),textAlign: TextAlign.left)), //your original button
//                             )
// //                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
//                         )
//                     ),
//                     Container(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ButtonTheme(
//                               padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), //adds padding inside the button
//                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
//                               minWidth: 0, //wraps child's width
//                               height: 0, //wraps child's height
//                               child: OutlineButton(borderSide: BorderSide(color: button2?Color(0xFFFC608C):Color(0xFFB5B3B4)),onPressed: () {setState(() {
//                                 button1 = false;
//                                 button2 = true;
//                                 button3 = false;
//                               });update('prescription');}, child: Text('Prescription',style: TextStyle(color: button2?Color(0xFFFC608C):Color(0xFFB5B3B4),fontSize: 10),textAlign: TextAlign.left)), //your original button
//                             )
// //                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
//                         )
//                     ),
//                     Container(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ButtonTheme(
//                               padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), //adds padding inside the button
//                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
//                               minWidth: 0, //wraps child's width
//                               height: 0, //wraps child's height
//                               child: OutlineButton(borderSide: BorderSide(color: button3?Color(0xFFFC608C):Color(0xFFB5B3B4)),onPressed: () {setState(() {
//                                 button1 = false;
//                                 button2 = false;
//                                 button3 = true;
//                               });update('report');}, child: Text('Reports',style: TextStyle(color: button3?Color(0xFFFC608C):Color(0xFFB5B3B4),fontSize: 10),textAlign: TextAlign.left)), //your original button
//                             )
// //                          Text(_times[index].username,style: TextStyle(color: Color(0xFFB5B3B4),fontSize: 12),textAlign: TextAlign.left),
//                         )
//                     ),


//                   ],
//                 ),
//               )

//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         SizedBox(
//           height: 81,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                       ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                             child: const Icon(bottomicon.BottomNavigation.bloodgroup,size: 30,color: Color(0xFF858585))),
//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(text: 'Blood Group\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                 TextSpan(text: 'O+',style: TextStyle(color: Colors.black,fontSize: 16))
//                               ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                             child: const Icon(bottomicon.BottomNavigation.bloodpressure,size: 30,color: Color(0xFF858585))),
//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                                 children: [
//                                   TextSpan(text: 'Blood Pressure\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                   TextSpan(text: '120/80',style: TextStyle(color: Colors.black,fontSize: 16))
//                                 ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                             child: const Icon(bottomicon.BottomNavigation.bloodglucose,size: 30,color: Color(0xFF858585))),
//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                                 children: [
//                                   TextSpan(text: 'Blood Glucose\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                   TextSpan(text: '140 mg/dL',style: TextStyle(color: Colors.black,fontSize: 16))
//                                 ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                             child: const Icon(bottomicon.BottomNavigation.temperature,size: 30,color: Color(0xFF858585))),
//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                                 children: [
//                                   TextSpan(text: 'Temperature\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                   TextSpan(text: '98.6°F',style: TextStyle(color: Colors.black,fontSize: 16))
//                                 ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: const Icon(bottomicon.BottomNavigation.pulserate,size: 30,color: Color(0xFF858585)),
//                         ),

//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                                 children: [
//                                   TextSpan(text: 'Pulse Rate\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                   TextSpan(text: '80/min',style: TextStyle(color: Colors.black,fontSize: 16))
//                                 ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Card(
//                 color: Theme.of(context).canvasColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 2,
//                 child: SizedBox(
//                   height: 80,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                             child: const Icon(bottomicon.BottomNavigation.hemoglobin,size: 27,color: Color(0xFF858585),)),
//                         SizedBox(
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                                 children: [
//                                   TextSpan(text: 'Hemoglobin\n\n',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
//                                   TextSpan(text: '15 g/dL',style: TextStyle(color: Colors.black,fontSize: 16))
//                                 ]
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//         ),
//     SizedBox(
//       height: 12,
//     ),
//       // sample3(context),
//         Padding(
//           padding: const EdgeInsets.only(top:20.0,bottom: 10.0,left: 20.0,right: 20.0),
//           child: FutureBuilder(
//               future: fetchTime(),
//               builder: ( context,  snapshot) {
//                 return timelist();
//               }),
//         ),
//         belowtimeline(),
//         lastbutton()
//         // SingleChildScrollView(
//         //   scrollDirection: Axis.horizontal,
//         //   child: Padding(
//         //     padding: const EdgeInsets.only(top:8.0,bottom: 20,left: 20,right: 20),
//         //     child: Row(
//         //       children: [
//         //         Column(
//         //           children: [
//         //             new Text(
//         //               'Date',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //             new Radio(
//         //               value: 0,
//         //               groupValue: _radioValue1,
//         //               onChanged: _handleRadioValueChange1,
//         //             ),
//         //             new Text(
//         //               'Prescription',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //           ],
//         //         ),
//         //         Container(
//         //           height: 2,
//         //           width: 20,
//         //           color: Colors.blue,
//         //         ),
//         //         Column(
//         //           children: [
//         //             new Text(
//         //               'Date',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //             new Radio(
//         //               value: 1,
//         //               groupValue: _radioValue1,
//         //               onChanged: _handleRadioValueChange1,
//         //             ),
//         //             new Text(
//         //               'Prescription',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //           ],
//         //         ),
//         //         Container(
//         //           height: 2,
//         //           width: 20,
//         //           color: Colors.blue,
//         //         ),
//         //         Column(
//         //           children: [
//         //             new Text(
//         //               'Date',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //             new Radio(
//         //               value: 2,
//         //               groupValue: _radioValue1,
//         //               onChanged: _handleRadioValueChange1,
//         //             ),
//         //             new Text(
//         //               'Prescription',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //           ],
//         //         ),
//         //         Container(
//         //           height: 2,
//         //           width: 20,
//         //           color: Colors.blue,
//         //         ),
//         //         Column(
//         //           children: [
//         //             new Text(
//         //               'Date',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //             new Radio(
//         //               value: 3,
//         //               groupValue: _radioValue1,
//         //               onChanged: _handleRadioValueChange1,
//         //             ),
//         //             new Text(
//         //               'Prescription',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //           ],
//         //         ),
//         //         Container(
//         //           height: 2,
//         //           width: 20,
//         //           color: Colors.blue,
//         //         ),
//         //         Column(
//         //           children: [
//         //             new Text(
//         //               'Date',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //             new Radio(
//         //               value: 4,
//         //               groupValue: _radioValue1,
//         //               onChanged: _handleRadioValueChange1,
//         //             ),
//         //             new Text(
//         //               'Prescription',
//         //               style: new TextStyle(fontSize: 16.0),
//         //             ),
//         //           ],
//         //         ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//     //     SizedBox(
//     //       child: ListView(
//     //         shrinkWrap: true,
//     //         children: [
//     //           ListTile(
//     //             title: Text("29 Aug 2020 | 21:19:35",),
//     //             subtitle: Text('AIMS',style: TextStyle(fontWeight: FontWeight.bold),),
//     //             trailing: Icon(Icons.arrow_forward_ios),
//     //             onTap: () {
//     //               Navigator.push(
//     //                 context,
//     //                 MaterialPageRoute(builder: (context) => PrescriptionDetail()),
//     //               );
//     //             },
//     //           ),
//     //           Divider(),
//     //           ListTile(
//     //             title: Text('29 Aug 2020 | 11:42:58'),
//     //             subtitle: Text('HINDUJA',style: TextStyle(fontWeight: FontWeight.bold),),
//     //             trailing: Icon(Icons.arrow_forward_ios),
//     //             onTap: () {
//     //               Navigator.push(
//     //                 context,
//     //                 MaterialPageRoute(builder: (context) => PrescriptionDetail()),
//     //               );
//     //             },
//     //           ),
//     //           Divider(),
//     //           ListTile(
//     //             title: Text('26 Aug 2020 | 16:31:51'),
//     //             subtitle: Text('MEDANTA',style: TextStyle(fontWeight: FontWeight.bold),),
//     //             trailing: Icon(Icons.arrow_forward_ios),
//     //             onTap: () {
//     //               Navigator.push(
//     //                 context,
//     //                 MaterialPageRoute(builder: (context) => PrescriptionDetail()),
//     //               );
//     //             },
//     //           )
//     //         ],
//     //       ),
//     //     ),
//     //     SizedBox(
//     //       width: MediaQuery.of(context).size.width*0.6,
//     //       child: RaisedButton(
//     //         onPressed: () {
//     // Navigator.push(
//     // context,
//     // MaterialPageRoute(builder: (context) => GraphDetail()),
//     // );
//     // },
//     //         shape: RoundedRectangleBorder(
//     //           borderRadius: BorderRadius.circular(7.0),),
//     //         color: Color(0xFF33CAFF),
//     //         child: Text("Prescription History".toUpperCase(),
//     //             style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
//     //       ),
//     //     )
//       ],
//     );



//     throw UnimplementedError();
//   }

// }

// class GalleryPage extends StatefulWidget {
//   GalleryPage(this.data);
//   final List data;

//   @override
//   _GalleryPageState createState() => _GalleryPageState();
// }

// class _GalleryPageState extends State<GalleryPage> {
//   CarouselController buttonCarouselController = CarouselController();
//   AsyncMemoizer _memoizer;
//   @override
//   void initState(){
//     fetchTime();
//     super.initState();
//     _memoizer = AsyncMemoizer();
//   }
//   List temp = [];
//   int index;
//   fetchTime() async {
//     return this._memoizer.runOnce(() async {
//     SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     var profileId = myPrefs.getString('profileId');
//     var url = 'https://app.famile.care/api/v1/getscrollableimages';
//     var response = await http.post(url,body: {
//       "profileid" : profileId.toString(),
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       // print(response.body);
//       final json = jsonDecode(response.body);
//       if (json != null) {
//         json.forEach((element) {
//           temp.add('https://app.famile.care/prescriptions/'+element['id'].toString()+'/'+element['name']);
//         });
//         print(temp);
//         var tempIndex;
//         temp.asMap().forEach((index, value) => {
//           if(value == widget.data[0]){
//             tempIndex = index
//           }
//         });
//         setState(() {
//           index = tempIndex;
//         });
//       }
//     }
//     });
//   }
//   timelist(){
//     if(temp.isEmpty){
//       return Padding(
//         padding: const EdgeInsets.only(top: 250,bottom: 15),
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     else{
//       return CarouselSlider(
//         carouselController: buttonCarouselController,
//         items: temp.map((imgUrl) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                 ),
//                 child: PhotoView(
//                   backgroundDecoration: BoxDecoration(
//                     color: Theme.of(context).canvasColor,
//                   ),
//                   imageProvider: NetworkImage(imgUrl),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//         options: CarouselOptions(
//           height: MediaQuery.of(context).size.height*0.6,
//           viewportFraction: 1,
//           initialPage: index,
//           enableInfiniteScroll: false,
//           reverse: false,
//           autoPlay: false,
//           autoPlayInterval: Duration(seconds: 3),
//           autoPlayAnimationDuration: Duration(milliseconds: 800),
//           autoPlayCurve: Curves.fastOutSlowIn,
//           enlargeCenterPage: true,
//           scrollDirection: Axis.horizontal,
//         ),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         iconTheme: IconThemeData(
//           color: Color(0xFFFC608C),
//         ),
//         title: Text('Gallery',style: TextStyle(color: Colors.black),),
//         backgroundColor: Color(0xFFFFEEF3),
//       ),
//       // Implemented with a PageView, simpler than setting it up yourself
//       // You can either specify images directly or by using a builder as in this tutorial
//       body: Column(
//         children: [
//           SizedBox(
//             height: 45,
//           ),
//           Container(
//             height: 400,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   FutureBuilder(
//                       future: fetchTime(),
//                       builder: ( context,  snapshot) {
//                         return timelist();
//                       }),
//                   // CarouselSlider(
//                   //   carouselController: buttonCarouselController,
//                   //   items: temp.map((imgUrl) {
//                   //     return Builder(
//                   //       builder: (BuildContext context) {
//                   //         return Container(
//                   //           width: MediaQuery.of(context).size.width,
//                   //           decoration: BoxDecoration(
//                   //             color: Theme.of(context).canvasColor,
//                   //           ),
//                   //           child: PhotoView(
//                   //             backgroundDecoration: BoxDecoration(
//                   //               color: Theme.of(context).canvasColor,
//                   //             ),
//                   //             imageProvider: NetworkImage(imgUrl),
//                   //           ),
//                   //         );
//                   //       },
//                   //     );
//                   //   }).toList(),
//                   //   options: CarouselOptions(
//                   //     height: MediaQuery.of(context).size.height*0.6,
//                   //     viewportFraction: 1,
//                   //     initialPage: index,
//                   //     enableInfiniteScroll: false,
//                   //     reverse: false,
//                   //     autoPlay: false,
//                   //     autoPlayInterval: Duration(seconds: 3),
//                   //     autoPlayAnimationDuration: Duration(milliseconds: 800),
//                   //     autoPlayCurve: Curves.fastOutSlowIn,
//                   //     enlargeCenterPage: true,
//                   //     scrollDirection: Axis.horizontal,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FlatButton(
//                       onPressed: () => buttonCarouselController.previousPage(
//                           duration: Duration(milliseconds: 300), curve: Curves.linear),
//                       child: Icon(Icons.arrow_back,color: Colors.grey,),
//                     ),
//                     FlatButton(
//                       onPressed: () => buttonCarouselController.nextPage(
//                           duration: Duration(milliseconds: 300), curve: Curves.linear),
//                       child: Icon(Icons.arrow_forward,color: Colors.grey,),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class GraphDetail extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _GraphDetailState();
//   }
// }

// class _GraphDetailState extends State<GraphDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         iconTheme: IconThemeData(
//           color: Color(0xFFFC608C),
//         ),
//         title: Text('Prescription History',style: TextStyle(color: Colors.black),),
//         backgroundColor: Color(0xFFFFEEF3),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: ExpansionPanelList.radio(
//             children: [
//               ExpansionPanelRadio(
//                 value: 1,
//                 headerBuilder: (BuildContext context, bool isExpanded) {
//                   return ListTile(
//                     title: Text("29 Aug 2020 | 21:19:35",),
//                     subtitle: Text('AIMS',style: TextStyle(fontWeight: FontWeight.bold),),
//                   );
//                 },
//                 body: ListTile(
//                   title: Text('Doctor : Akash Gupta'),
//                   subtitle: Text('Speciality : Neurologist'),
//                 ),
//               ),
//               ExpansionPanelRadio(
//                 value: 2,
//                 headerBuilder: (BuildContext context, bool isExpanded) {
//                   return ListTile(
//                     title: Text('29 Aug 2020 | 11:42:58'),
//                     subtitle: Text('HINDUJA',style: TextStyle(fontWeight: FontWeight.bold),),
//                   );
//                 },
//                 body: ListTile(
//                   title: Text('Doctor : Manish Rawat'),
//                   subtitle: Text('Speciality : General Physician'),
//                 ),
//               ),
//               ExpansionPanelRadio(
//                 value: 3,
//                 headerBuilder: (BuildContext context, bool isExpanded) {
//                   return ListTile(
//                     title: Text('26 Aug 2020 | 16:31:51'),
//                     subtitle: Text('MEDANTA',style: TextStyle(fontWeight: FontWeight.bold),),
//                   );
//                 },
//                 body: ListTile(
//                   title: Text('Doctor : Priyanka Rai'),
//                   subtitle: Text('Speciality : Endocrinologist'),
//                 ),
//               ),
//               ExpansionPanelRadio(
//                 value: 4,
//                 headerBuilder: (BuildContext context, bool isExpanded) {
//                   return ListTile(
//                     title: Text('26 Aug 2020 | 16:01:00'),
//                     subtitle: Text('MEDICAL COLLEGE',style: TextStyle(fontWeight: FontWeight.bold),),
//                   );
//                 },
//                 body: ListTile(
//                   title: Text('Doctor : Abdul Tyagi'),
//                   subtitle: Text('Speciality : Dermatologist'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PrescriptionDetail extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _PrescriptionDetailState();
//   }
// }

// class _PrescriptionDetailState extends State<PrescriptionDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         iconTheme: IconThemeData(
//           color: Color(0xFFFC608C),
//         ),
//         title: Text('Prescription Detail',style: TextStyle(color: Colors.black),),
//         backgroundColor: Color(0xFFFFEEF3),
//       ),
//       body: Container(),
//     );
//   }
// }

    


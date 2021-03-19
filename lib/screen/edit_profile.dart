import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/profiledetail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  File _image;
  SharedPreferences prefs;
  String editId;
  final _formKey = GlobalKey<FormState>();
  var stateInfoUrl = "https://app.famile.care/api/v1/editprofile";
  var _currentSelectedValue;
  var _currentGender;
  var image;
  var _gender = [
    "Male",
    "Female",
    "null",
  ];
  var _currencies = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];
  TextEditingController _NameController ;
  TextEditingController _ageController;
  TextEditingController _heightController;
  TextEditingController _weightController;
  TextEditingController _occupationController;
  TextEditingController _emailController;
  TextEditingController _mobileController;
  TextEditingController _stateController;
  TextEditingController _cityController;
  TextEditingController _addressController;

  void changedata(String s){
    print(s);
    setState(() {
      String url = "https://app.famile.care/api/v1/profiledetail";
      http.post(url,body: {
        "memberid" : s,
      }).then((response) {
        var data = json.decode(response.body);
        var user = UserDetail.fromJson(data[0]);
        setState(() {
          _ageController = TextEditingController(text: '${user.age}');
          _currentSelectedValue = '${user.blood}';
          _currentGender = '${user.gender}';
          _heightController = TextEditingController(text: '${user.height}');
          _weightController = TextEditingController(text: '${user.weight}');
          _occupationController = TextEditingController(text: '${user.occupation}');
          _emailController = TextEditingController(text: '${user.email}');
          _mobileController = TextEditingController(text: '${user.mobile}');
          _stateController = TextEditingController(text: '${user.state}');
          _cityController = TextEditingController(text: '${user.city}');
          _addressController = TextEditingController(text: '${user.address}');
          _NameController = TextEditingController(text: '${user.name}');
          image = '${user.image}';
        });
//      print(statesList);
      });
    });
  }

  getIdtoEdit() async{
    prefs = await SharedPreferences.getInstance();
    editId = prefs.getString('editProfileId');
    changedata(editId);
  }


  @override
  void initState() {
    getIdtoEdit();
    // TODO: implement initState
    super.initState();
  }



  Future<void> openCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200,maxHeight: 200);
    setState(() {
      _image =image;
    });
  }

  Future<void> openGallery()
  async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 200,maxHeight: 200);
    setState(() {
      _image = image;
    });

  }

  checkimg(){
    if(image=='avatar')
      {
        return Image.network('https://app.famile.care/prescriptions/'+editId+'/avatar.jpg',width: 40,height: 40,);
      }
    else
      {

        return Image.network('https://app.famile.care/default.png',width: 80,height: 80,);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text('Edit Member',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24)),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        height: 80,
                            width: 80,
                            child: _image == null ? checkimg() : Image.file(_image),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FlatButton(
                            child: Text("Open Gallery",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                            onPressed: openGallery,
                          ),
                          FlatButton(
                            child: Text('Open Camera',style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                            onPressed: openCamera,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Name",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  textAlign: TextAlign.left,
                  controller: _NameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'First Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Gender",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
                          InputDecorator(
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Gender',
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4)))),
                            isEmpty: _currentGender == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration.collapsed(hintText: 'Gender'),
                                validator: (value) => value == null ? 'Please select Gender' : null,
                                value: _currentGender,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentGender = newValue;
//                      state.didChange(newValue);
                                  });
                                },
                                items: _gender.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Age",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                          TextFormField(
                            textAlign: TextAlign.left,
                            controller: _ageController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              hintText: 'Age',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Age';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Blood Group",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                InputDecorator(
                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Blood Group',
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4)))),
                  isEmpty: _currentSelectedValue == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration.collapsed(hintText: 'Blood Group'),
                      validator: (value) => value == null ? 'Please select Blood Group' : null,
                      value: _currentSelectedValue,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _currentSelectedValue = newValue;
//                      state.didChange(newValue);
                        });
                      },
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Height",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
                          TextFormField(
                            controller: _heightController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              hintText: 'Height',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Height';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weight",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14)),
                          TextFormField(
                            controller: _weightController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                              hintText: 'Weight',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Weight';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Occupation",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _occupationController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'Occupation',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Occupation';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Email",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Mobile",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _mobileController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'Mobile',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Mobile';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("State",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _stateController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'State',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your State';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("City",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _cityController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'City',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your City';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Address",style: TextStyle(color: Color(0xFFFC608C),fontSize: 14),),
                TextFormField(
                  controller: _addressController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                    hintText: 'Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)
                  ),
                  minWidth: double.infinity,
                  height: 40,
                  buttonColor: Color(0xFF33CAFF),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
//                            Scaffold.of(context)
//                                .showSnackBar(SnackBar(content: Text('Processing Data')));
                        print('sccsdf');
                        http.post(stateInfoUrl, body: {
                          "name" : _NameController.text,
                          "age" : _ageController.text,
                          "blood" : _currentSelectedValue,
                          "height" : _heightController.text,
                          "weight" : _weightController.text,
                          "gender" : _currentGender,
                          "occupation" : _occupationController.text,
                          "email" : _emailController.text,
                          "mobile" : _mobileController.text,
                          "city" : _cityController.text,
                          "state" : _stateController.text,
                          "address" : _addressController.text,
                          "editid" : editId,
                          'photo': _image != null ?
                              base64Encode(_image.readAsBytesSync()) : '',
                        }).then((response) {
                          print(response.body);
                          print(response.statusCode);
                          if(response.statusCode == 200)
                          {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Home()),
                                  (Route<dynamic> route) => false,
                            );
                          }
                        });
                      }
                    },
                    child: Text('UPDATE PROFILE',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
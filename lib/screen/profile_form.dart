import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String profileId;
  void getinfo() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('profileId');
  }
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
  var _currentSelectedValue;
  var stateInfoUrl = "https://app.famile.care/api/v1/addprofile";
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _occupationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getinfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Text('Add Member',style: TextStyle(color: Color(0xFFFC608C),fontSize: 24)),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _firstNameController,
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
                    TextFormField(
                      textAlign: TextAlign.left,
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                        hintText: 'Last Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),gapPadding: 4.0,borderSide: BorderSide(color: Color(0xFFFFC4D4))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Last Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 20,
                    ),
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
                          child: TextFormField(
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
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
                        ),


                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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

                            http.post(stateInfoUrl, body: {
                              "firstname" : _firstNameController.text,
                              "lastname" : _lastNameController.text,
                              "age" : _ageController.text,
                              "blood" : _currentSelectedValue,
                              "height" : _heightController.text,
                              "weight" : _weightController.text,
                              "occupation" : _occupationController.text,
                              "profileid" : profileId.toString(),
                            }).then((response) {
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
                        child: Text('SAVE MEMBER',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
    );



  }
}
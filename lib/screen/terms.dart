import 'package:flutter/material.dart';
import 'home.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Terms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TermsState();
  }
}

class _TermsState extends State<Terms> {
  bool rememberMe = false;
  // this bool will check rememberMe is checked
  bool showErrorMessage = false;

  //for form Validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: WebView(
                      initialUrl: 'https://famile.semiqolon.com/privacy-policy/',
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            focusColor: Colors.lightBlue,
                            activeColor: Color(0xFFFC608C),
                            value: rememberMe,
                            onChanged: (newValue) {
                              setState(() => rememberMe = newValue);
                            }
                        ),
                        SizedBox(width: 10.0),
                        Text('Accept Terms & Conditions'),
                      ]
                  ),
                  // based up on this bool value
                  showErrorMessage ?
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Please accept the terms and conditions to proceed')
                      )
                  )
                      : Container(),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 50,
                    child: FlatButton(
                      color: rememberMe ? Color(0xFF33CAFF) : Colors.grey,
                        child: Text(
                          "Agree & Accept".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: (){
                          // for your form validation
                          if(_formKey.currentState.validate()){
                            // do your success operation here!
                            // checking for the rememberValue
                            // and setting the message bool data
                            if(rememberMe != true)
                              setState(() => showErrorMessage = true);
                            else
                              {
                                setState(() => showErrorMessage = false);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => Home()),
                                      (Route<dynamic> route) => false,
                                );
                              }


                          }
                        }
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )

                ]
            )
        )
    );
  }
}
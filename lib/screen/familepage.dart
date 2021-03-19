import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class familePage extends StatefulWidget {
  @override
  _familePageState createState() => _familePageState();
}

class _familePageState extends State<familePage> {
  links() async{
    WebView(
      initialUrl: 'https://www.famile.care',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(
      //   backgroundColor: Colors.pink[100],
      //   title: Text("Famile About" ,style: TextStyle(color: Colors.black),),
      // ),
      body: SafeArea(
              child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("24*7 Support",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Email : ',
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    TextSpan(
                        text: 'info@famile.care',
                        style: TextStyle(color: Color(0xFFFC608C), fontSize: 15)),
                  ]),
                ),
                Text("Phone : +91 966 755 5094"),
                SizedBox(height: 10),
                Text("Address:"),
                Text("Semiqolon Solutions Pvt. Ltd."),
                Text("7th Floor A-14, Eco Tower Near Amity University,"),
                Text("Sector 125, Noida – Uttar Pradesh"),
                Text("201301"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Privacy and Policy",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        links();
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Our Vission",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Center(
                    child: Text(
                        '''Our mission is to help people keep a digital record of their complete health history that stays with them forever. By clicking a picture of your prescriptions and uploading them on our platform, you can maintain your health records in a chronological manner that can be shared with your doctors or pharmacists within a single click. Our team of professionals converts your hand-written prescriptions into easy to understand digital documents with 99.99% accuracy that will serve as crucial data in the years to come in the form of your health analytics. ''',
                        style: TextStyle(height: 1.2, letterSpacing: 0.5))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset(
                      "assets/Famile-logo-app.png",
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      " Famile",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'A ',
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    TextSpan(
                        text: 'Semiqolon ',
                        style: TextStyle(color: Color(0xFFFC608C), fontSize: 15)),
                    TextSpan(
                        text: 'Product !',
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                  ]),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

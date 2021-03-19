import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:path_provider/path_provider.dart';

class Upload extends StatefulWidget{
  @override
  UploadState createState() => UploadState();
}
class UploadState extends State<Upload>{
   final Map params = new Map();
  // ProgressDialog progressDialog;
  // variable section
  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();
  SharedPreferences myPrefs;
  String profileId;
  String userId;
  String tempPath;
  String isBig;
  String isTotal;
  String isempty;
  
  void getid() async{
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    myPrefs = await SharedPreferences.getInstance();
    profileId = myPrefs.getString('memberidselected');
    userId = myPrefs.getString('profileId');
    print(profileId);
    // pickFiles();
  }

  
  Future pickFiles() async{
    List<Widget> thumbs = new List<Widget>();
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

    await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx'],
    ).then((files){
//      files.forEach((element){
//        CompressObject compressObject = CompressObject(
//          imageFile:element, //image
//          path:tempPath, //compress to path
//          quality: 85,//first compress quality, default 80
//          step: 4,//compress quality step, The bigger the fast, Smaller is more accurate, default 6
//          mode: CompressMode.LARGE2SMALL,//default AUTO
//        );
//        Luban.compressImage(compressObject).then((_path) {
//          print(_path);
//        });
//      });
      files.forEach((element) {
        int sizeInBytes = element.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 7){
          setState(() {
            isBig = 'true';
          });
          // Navigator.pushAndRemoveUntil(
          //   this.context,
          //   MaterialPageRoute(builder: (context) => Home()),
          //       (Route<dynamic> route) => false,
          // );
          // return;
        }
      });
      if(files.length>5)
        {
          setState(() {
            isTotal = 'true';
          });
          // Navigator.pushAndRemoveUntil(
          //   this.context,
          //   MaterialPageRoute(builder: (context) => Home()),
          //       (Route<dynamic> route) => false,
          // );
          // return;
        }
      if(files.length == 0)
        {
          setState(() {
            isempty ='true';
          });
          // Navigator.pushAndRemoveUntil(
          //   this.context,
          //   MaterialPageRoute(builder: (context) => Home()),
          //       (Route<dynamic> route) => false,
          // );
          // return;
        }
         List<Map> attch = toBase64(fileList);
        params["attachment"] = jsonEncode(attch);
        params['id'] = jsonEncode(profileId);
        params['userid'] = jsonEncode(userId);
        print(params);
      if(files != null && files.length>0){
        files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

          if(picExt.contains(extension(element.path))){
            thumbs.add(Padding(
                padding: EdgeInsets.all(1),
                child:new Image.file(element)
            )
            );
          }
          else
            thumbs.add( Container(
                child : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Icon(Icons.insert_drive_file),
                      Text(extension(element.path))
                    ]
                )
            ));
          fileList.add(element);
        });
        setState(() {
          fileListThumb = thumbs;
        });
       
       
        // progressDialog.show();
      }
    });
  }
  List<Map> toBase64(List<File> fileList){
    List<Map> s = new List<Map>();
    if(fileList.length>0)
      fileList.forEach((element){
        Map a = {
          'fileName': basename(element.path),
          'encoded' : base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    return s;
  }

  Future<bool> httpSend(Map params) async
  { print(params);
    String endpoint = 'https://app.famile.care/api/v1/multiupload';
    return await http.post(endpoint, body: params)
        .then((response){
      print(response.body);
      if(response.statusCode==200)
      {
        Map<String, dynamic> body = jsonDecode(response.body);
        // Navigator.push(
        //   this.context,
        //   MaterialPageRoute(builder: (context) => Home()),
        // );
        Navigator.pushAndRemoveUntil(
          this.context,
          MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
        );
        if(body['status']=='OK')
          return true;

      }
      else
        return false;
    });
  }
  @override
  void initState() {
    getid();
    // TODO: implement initState
    super.initState();
  }

Flushbar dismiss;

  @override
  Widget build(BuildContext context)
  {
    // progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true);
    if(fileListThumb == null){
   fileListThumb = [
        InkWell(
          onTap: pickFiles,
          child: Container(
            color: Colors.grey[200],
              child : Icon(Icons.add)
          ),
        )
      ];
    }
     
    final Map params = new Map();
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFC608C),
        title: Text("File Uploader"),
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: GridView.count(
              crossAxisCount: 4,
              children: fileListThumb,
            ),
          )
      ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        
        child: FloatingActionButton(
          
          shape: RoundedRectangleBorder(),
          backgroundColor:Color(0xFFFC608C) ,
          onPressed: () async{
if(isempty == 'true'){
  setState(() {
        isempty='false';
            fileList=[];
            // fileListThumb =[];
            print(fileListThumb);
            fileListThumb = [
          InkWell(
            onTap: pickFiles,
            child: Container(
                child : Icon(Icons.add)
            ),
          )
        ];
          });
 Flushbar(
          isDismissible: true,
         backgroundColor: Color(0xff00B8FF) ,
          message: "empty",
              mainButton: FlatButton(
        child: Text(
          'Try Again',
          style: TextStyle(color: Colors.white),
        ),
        
        onPressed: () { 
         
          Navigator.pop(context);
        },
    ),
    
        ).show(context);
} else if(isBig=='true'){
   setState(() {
        isBig='false';
            fileList=[];
            // fileListThumb =[];
            print(fileListThumb);
            fileListThumb = [
          InkWell(
            onTap: pickFiles,
            child: Container(
                child : Icon(Icons.add)
            ),
          )
        ];
          });
   Flushbar(
          isDismissible: true,
         backgroundColor: Color(0xff00B8FF) ,
          message: "File Size Should be Less than 7 MB!",
              mainButton: FlatButton(
        child: Text(
          'Try Again',
          style: TextStyle(color: Colors.white),
        ),
        
        onPressed: () { 
         
          Navigator.pop(context);
          },
    ),
          // duration: Duration(seconds: 10),
        ).show(context);
} else if(isTotal=='true'){
   setState(() {
        isTotal='false';
            fileList=[];
            // fileListThumb =[];
            print(fileListThumb);
            fileListThumb = [
          InkWell(
            onTap: pickFiles,
            child: Container(
                child : Icon(Icons.add)
            ),
          )
        ];
          });
   Flushbar(
          isDismissible: true,
         backgroundColor: Color(0xff00B8FF) ,
          message: "File Size Should be Less than 5!",
              mainButton: FlatButton(
        child: Text(
          'Try Again',
          style: TextStyle(color: Colors.white),
        ),
        
        onPressed: () { 
         
          Navigator.pop(context);
          },
    ),
          // duration: Duration(seconds: 10),
        ).show(context);
}
else{

              
            List<Map> attch = toBase64(fileList);
            params["attachment"] = jsonEncode(attch);
            params['id'] = jsonEncode(profileId);
            params['userid'] = jsonEncode(userId);

            httpSend(params).then((sukses){
              if(sukses==true){
                Flushbar(
                  message: "success :)",
                  icon: Icon(
                    Icons.check,
                    size: 28.0,
                    color: Colors.blue[300],
                  ),
                  duration: Duration(seconds: 35),
                  leftBarIndicatorColor: Colors.blue[300],
                ).show(context);
              }
              else
                Flushbar(
                  message: "fail :(",
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.blue[300],
                  ),
                  duration: Duration(seconds: 35),
                  leftBarIndicatorColor: Colors.red[300],
                ).show(context);
            });
          }
},

          tooltip: 'Upload File',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("File Upload"),
              Icon(Icons.upload_file),
            ],
          )
        ),
      ),
    );
  }
}
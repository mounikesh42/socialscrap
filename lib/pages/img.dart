


import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Img extends StatefulWidget {
  @override
  _ImgState createState() => _ImgState();
}
final storage = new FlutterSecureStorage();

class _ImgState extends State<Img> {
  Dio dio = new Dio();
   File img;
   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
    var imgPicker;
    showSnackBar(int stauscode) {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: stauscode == 201 ? new Text("Succesful") : new Text("There is some error"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: stauscode == 201 ? 'Ok' : "Try Again",textColor: Colors.white, onPressed: (){
          
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
   showSnackBara() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: new Text("Image Selected.Press submit to continue"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: 'OK',textColor: Colors.white, onPressed: (){
          
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    // AssetImage assetImage =AssetImage("assets/images/scrap_withoutbg.png");
    // Image image=Image(image:assetImage,width: 150,height: 220,);
    // return Container(child :image);
    return Scaffold(
      key: _scaffoldKey,
// body :<Widget>[]
      body: ListView(
      
      
      
        children: <Widget>[
           Container(
                height: 220,
                width: 150,
                 decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/scrap_withoutbg.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
      ),
               
              ),
    Container(
      alignment: Alignment.center,
      height: 100,
      width: 100,
      child: RaisedButton(
  
              
  
              color: Colors.red,
  
           
  
  
                      
  
                  child: Text("SELECT IMAGE",style: TextStyle(color: Colors.white)),
  
                
  
              onPressed: ()async
  
              {
  
                 
  
                 imgPicker = await ImagePicker.pickImage(source: ImageSource.gallery);
  
               if(imgPicker!= null)
  
               {
  
                 setState(() {
  
                   img = imgPicker;
  
                 });
                 showSnackBara();
  
               }
  
            
              },
  
            ),
    ),
    Container(
      alignment: Alignment.center,
      height: 100,
      width: 100,
      child: RaisedButton(
  
              
  
              color: Colors.blue,
  
           
  
  
                      
  
                  child: Text("SUBMIT",style: TextStyle(color: Colors.white)),
  
                
  
              onPressed: ()async
  
              {
  
               
              try
  
              {
  
                  String filename =img.path.split("/").last;
  
  
  
              final mimeTypeData =
  
                lookupMimeType(img.path, headerBytes: [0xFF, 0xD8]).split('/');
  
                  FormData formData = new FormData.fromMap({
  
                      "picture" :
  
                      await MultipartFile.fromFile(img.path,filename: filename,contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
  
                  });
  
                  String url = "https://backend.scrapshut.com/api/img/";
                      String bvalue = await storage.read(key: 'btoken');

                  Dio dio = new Dio();
dio.options.headers['content-Type'] = 'application/json';
dio.options.headers["Authorization"] = "JWT ${bvalue}";
Response response = await dio.post(url, data: formData);
  
                  //  Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMywidXNlcm5hbWUiOiJteGlvbmhhY2tpbmciLCJleHAiOjE1ODgyMDEyOTksImVtYWlsIjoibXhpb25oYWNraW5nQGdtYWlsLmNvbSJ9.PfdjRrn2who64Es02d7flVLSF4Hp31u9Sw2NigVtlH8",
  
              // "Content-Type":"application/json"};
  
              // Response response = await dio.post(url,data: formData,options: Options(headers: headers));
  
          
  
              print(response.statusCode);
              showSnackBar(response.statusCode);

  
              }
  
              catch(e)
  
              {
  
                print(e);
  
              }
  
                
  
              },
  
            ),
    ),
],
      ),
      
    );
  }
}
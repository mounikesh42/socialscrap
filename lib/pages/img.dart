


import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Img extends StatefulWidget {
  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> {
  Dio dio = new Dio();
  @override
  Widget build(BuildContext context) {
    // AssetImage assetImage =AssetImage("assets/images/scrap_withoutbg.png");
    // Image image=Image(image:assetImage,width: 150,height: 220,);
    // return Container(child :image);
    return Scaffold(
// body :<Widget>[]
      body: Center(
        // child:Container(
    // children: <Widget>[
        // Image.asset(
        //   'assets/profile.png', width: 100.0, height: 100.0,
        // ),
        // ),
      
        child: RaisedButton(
          
          color: Colors.red,
          child: Container(
           
                
            child: Text("SELECT IMAGE",style: TextStyle(color: Colors.white)),
          ),
          onPressed: ()async
          {
            File img;
            var imgPicker = await ImagePicker.pickImage(source: ImageSource.gallery);
           if(imgPicker!= null)
           {
             setState(() {
               img = imgPicker;
             });
           }
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
               Map<String, String> headers = {"Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMywidXNlcm5hbWUiOiJteGlvbmhhY2tpbmciLCJleHAiOjE1ODgyMDEyOTksImVtYWlsIjoibXhpb25oYWNraW5nQGdtYWlsLmNvbSJ9.PfdjRrn2who64Es02d7flVLSF4Hp31u9Sw2NigVtlH8",
          "Content-Type":"application/json"};
          Response response = await dio.post(url,data: formData,options: Options(headers: headers));
      
          print(response.statusCode);
          }
          catch(e)
          {
            print(e);
          }
            
          },
        ),
      ),
      
    );
  }
}
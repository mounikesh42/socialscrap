import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sssocial/pages/home.dart';
import 'package:flutter/cupertino.dart';
// import fit_image;

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sssocial/pages/img.dart';
import 'package:sssocial/pages/url.dart';

import 'msg.dart';

final storage = new FlutterSecureStorage();
String auth="https://backend.scrapshut.com/a/google/";



final googlesignin= GoogleSignIn();
class Home extends StatefulWidget{
@override
_HomeState createState() =>  _HomeState();
}

// class _HomeState {
// }

class _HomeState extends State<Home>{
bool isAuth =false;
String token ='';
String value='';
String gtoken='';
@override
void initState(){
super.initState();
googlesignin.onCurrentUserChanged.listen((account){
if (account != null){
  print("user signed in ");
  setState(() {
    
    isAuth=true;
  });
}
else{
  setState(() {
    
    isAuth=false;
  });
}
},onError:(err){
  print("eror signing in $err");
});
googlesignin.signInSilently(suppressErrors:false)
.then((account){
  if (account != null){
  print("user signed in with mounikesh");
  setState(() {
    
    isAuth=true;
  });
}
else{
  setState(() {
    
    isAuth=false;
  });
}
});
}
 login()  {
  googlesignin.signIn().then((result){
        result.authentication.then((googleKey) async {
          var gtoken = googleKey.accessToken;
          // print(gtoken);
          await storage.write(key: 'token', value: gtoken);
          String value = await storage.read(key: 'token');
          print(value);
          print("sucess post");
     
          Map<String,String> headers = {'Content-Type':'application/json'};
          final msg = jsonEncode({"token":"$value"});
          print(msg);

          var response = await http.post(auth ,body:msg,

          headers: headers

          );
 if(response.statusCode == 200) {
      String responseBody = response.body;
      print(responseBody);
     Map<String, dynamic> responseJson = jsonDecode(response.body);
     String btoken=responseJson['access_token'];
      await storage.write(key: 'btoken', value: btoken);
      String bvalue = await storage.read(key: 'btoken');
      print(bvalue);
      print("sucess");
    }
   else{
     print("not success");
   } 
          });
  });
}
logout(){
    googlesignin.signOut();

   storage.delete(key: 'btoken');
   storage.delete(key: 'token');


    
}
Scaffold buildAuthScreen(){
return Scaffold(
  body: Container(
    height: MediaQuery.of(context).size.height,
    width: double.infinity,
    child: DefaultTabController(
      child: Scaffold(
         appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.blue[100],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(25),
                    child: Container(
                      color: Colors.transparent,
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Colors.red
                                        , width: 6.0),
                                    insets: EdgeInsets.fromLTRB(
                                        40.0, 20.0, 40.0, 0)),
                                indicatorWeight: 15,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 12,
                                   
                                    fontWeight: FontWeight.bold),
                                unselectedLabelColor: Colors.white,
                                tabs: [
                                  Tab(
                                    text: "URL",
                                    
                                  ),
                                  Tab(
                                    text: "MESSAGE",
                                   
                                  ),
                                  Tab(
                                    text: "IMAGE",
                                  
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ),
                drawer: Drawer(
                 child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Scrashut For Deeptech'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Logout'),
        onTap: () {
          logout();
          // Update the state of the app.
          // ...
        },
      ),
      // ListTile(
      //   title: Text('Item 2'),
      //   onTap: () {
      //     // Update the state of the app.
      //     // ...
      //   },
      // ),
    ],
  ),
                ),
                  body: TabBarView(
                  children: <Widget>[
                    URL(),
                    Msg(),  
                    Img(),
                    
                  ],
                )
                ), 
                length: 3,
                )
                )
                
      );
      
      
  
  

}
 Scaffold buildUnAuthScreen(){
 return Scaffold(
body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin:Alignment.topRight,
      end:Alignment.bottomLeft, colors: <Color>[
        Colors.blue,
        Colors.white,
      ],
        ),
  ),
alignment: Alignment.center,
  child:Column(
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

    children: <Widget>[
            Container(
                height:300,
                width: 800,
                 decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/scrap_withoutbg.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.rectangle,
      ),
               
              ),
    // Text("Scrapshut",style:TextStyle(
    //   fontFamily:"Signatra",
    //    fontSize:40.0,
    //    color:Colors.lightBlue,
    //    ),
    //    ),
       GestureDetector(
         onTap: login(),
         child: Container(
           width:350.0,
           height:60.0,
           decoration:BoxDecoration(
             image:DecorationImage(image: AssetImage('assets/images/download.png'),
             fit : BoxFit.cover,
              ),
           ),   
         ),
       ),


  ],),
),
 );
}
@override

  Widget  build(BuildContext context){
    // return Text("home");
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
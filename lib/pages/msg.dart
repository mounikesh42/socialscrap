import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Msg extends StatefulWidget {
  @override
  _MsgState createState() => _MsgState();
}
final storage = new FlutterSecureStorage();

class _MsgState extends State<Msg> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _message;
  TextEditingController _review;
  TextEditingController _tags;
  int ratings;
  @override
void initState() {
    _message = TextEditingController();
    _review = TextEditingController();
    _tags = TextEditingController();
  
    // TODO: implement initState
    super.initState();
  }  
  
_showSnackBar(int stauscode) {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: stauscode == 201 ? new Text("Succesful") : new Text("There is some error"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.black,
        action: new SnackBarAction(label: stauscode == 201 ? 'Ok' : "Try Again",textColor: Colors.white, onPressed: (){
         _review.clear();_tags.clear();;ratings=0;
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  _makePostReq(String content,List<String> tags,int rating,String review) async
  {
        String bvalue = await storage.read(key: 'btoken');

  String url = 'https://backend.scrapshut.com/api/msg/';
  Map<String, String> headers = {"Authorization":"JWT ${bvalue}",
"Content-Type":"application/json"};
  String json = jsonEncode({
			"rate": rating,
            "content": content,
            "review": review,
            // "url": urlC,
            // "tags":tags
});
  print(json);

  // make POST request

  Response response = await post(url,headers: headers, body: json);
  print(response.body);
   int statusCode = response.statusCode;
   print(statusCode);
   _showSnackBar(statusCode);
  }
  // Widget build(BuildContext context) {
    Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
      padding: EdgeInsets.all(8),
          
      
           
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
              // Text("The More data you give = the more data you get",style: TextStyle(color: Colors.red),),
              // Text("developers.scrapshut.com",style: TextStyle(color: Colors.red)),
              // SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Message:*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        
                        controller: _message,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                            
                                hintText: 'Message',

                                hintStyle: TextStyle(color: Colors.grey,),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   Text("Rating*",style: TextStyle(color: Colors.grey)),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: RatingBar(
   initialRating: 0,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating:false,
   itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: ( rating) {
    ratings = rating.toInt();
   },
),
                   )

                ],
              ),
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Review*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 250,
                      child: TextField(
                        controller: _review,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: "Review helps others identify false comments",

                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],
              ),
               SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Tags*",style: TextStyle(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      width: 250,
                      child: TextField(
                        controller: _tags,
                        textAlign: TextAlign.center,
                              decoration: InputDecoration(
                              
                                hintText: 'Use , to seperate tags ',

                                hintStyle: TextStyle(color: Colors.grey,),
                                focusedBorder: OutlineInputBorder(
                
                    borderSide: BorderSide(color: Colors.blue),

                ),
                 enabledBorder: OutlineInputBorder(
                 
                    borderSide: BorderSide(color: Colors.blue),
                 ),
  ),
),
                    ),
                  )
                  
                ],
              ),
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: RaisedButton(
                  
                  color: Colors.blue,
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                  onPressed: ()  {
                    _makePostReq(_message.text, _tags.text.toString().split(",").toList(),ratings, _review.text);
                  },
                ),
              )
            ],
            
          ),
      
      
    );
  }
}

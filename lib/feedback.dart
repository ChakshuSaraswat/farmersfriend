
import 'package:flutter/material.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Feedback From: ',style: TextStyle(color: Colors.white,fontSize: 24),),
          centerTitle: true,
          backgroundColor: Colors.green[300],
        ),
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(color: Colors.black), 
                decoration: InputDecoration(
                  hintText: 'Enter your name:' ,
                  hintStyle: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 20,
                style: TextStyle(color: Colors.black), 
                decoration: InputDecoration(
                  hintText: 'Enter feedback:' ,
                  hintStyle: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: FlatButton(
                color: Colors.green[500],
                child: Text('Submit',style: TextStyle(fontSize: 24,color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
      )
    );
  }
}
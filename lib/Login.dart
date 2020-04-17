import 'package:flutter/material.dart';
import 'financialportal.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

bool loggedin=false;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController sghid=new TextEditingController();
  TextEditingController memberid=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green[500],
        body:(!loggedin)? Center(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('Login for Financial Portal:',style: TextStyle(fontSize: 24,color: Colors.white),),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: sghid,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'SGH ID: ',
                      hintStyle: TextStyle(fontSize: 16,color: Colors.grey[500]),
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: memberid,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Member ID: ',
                    hintStyle: TextStyle(fontSize: 16,color: Colors.grey[500]),
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Login',style: TextStyle(color: Colors.green),),
                    onPressed: (){
                      if(sghid.text=='admin'&&memberid.text=='admin') {
                        loggedin = true;
                        setState(() {

                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ):FinancialPortal(),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class FinancialPortal extends StatefulWidget {
  @override
  _FinancialPortalState createState() => _FinancialPortalState();
}

class _FinancialPortalState extends State<FinancialPortal> {
  bool loggedin = false;

  _launchURL(var x) async {
    var url = 'tel:$x';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          accentColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.green[500],
          body: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset('moneybag.png',height: 120,),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Text('Welcome to Financial Portal',style: TextStyle(fontSize: 20),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text('Personal Details: ',style: TextStyle(fontSize: 18),),
                        padding: EdgeInsets.all(5),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'Name: Shyam Kumar \nRegion: Manipala\nSize of field: 2.0 acre',style: TextStyle(fontSize: 18)),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child:
                        Text('You are eligible for Govt. Incentives',style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('icicilogo.png',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'ICICI Bank \nLoan Details: \nInterest Rate: 12.25%\nFor every 100 of loan \nyou will have to pay 112.25'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(18601207777);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('centralbankofindia.png',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'Central Bank of India \nLoan Details: \nInterest Rate: 11.25%\nFor every 100 of loan \nyou will have to pay 111.25'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(1800221911);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('hdfclogo.png',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'HDFC Bank \nLoan Details: \nInterest Rate: 11.14%\nFor every 100 of loan \nyou will have to pay 111.14'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(08061606161);
                    },
                ),
              ),
              Container(
                child: Center(
                        child: Text('Government Benefits:',style: TextStyle(color: Colors.white,fontSize: 24),),)
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('govt_of_ind_logo.png',height: 50,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            'Pradhan Mantri Kisan Samman Nidhi: \n6000 for minimum income support in three \ninstallments by the government.'),
                      ),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('govt_of_ind_logo.png',height: 50,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            'Pradhan Mantri Fasal Bima Yojana: \nCrop insurance against crop disease/damage. \nAdopt innovative pratices for better yield'),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 15,bottom: 15),
                  child: Center(
                    child: Text('Crop Insurance:',style: TextStyle(color: Colors.white,fontSize: 24),),)
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('icicilogo.png',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'ICICI Bank \nInsurance Details: \n 2% of sum insured or actuarial rate\nwhichever is less.'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(18601207777);
                    },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('generali.jpg',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'Future Generali \nInsurance Details: \n2% of sum insured or actuarial rate\nwhichever is less.'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(18605003333);
                    },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('allianz.png',height: 40,),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'Bajaj Allianz \nInsurance Details: \n2% of sum insured or actuarial rate\nwhichever is less.'),
                      ),
                    ],
                  )),
              Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Call for more information',style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                  onPressed: (){
                    _launchURL(18002095858);
                    },
                ),
              ),
            ],
          ),
        )
    );
  }
}

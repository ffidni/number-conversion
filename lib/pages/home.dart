import 'package:flutter/material.dart';
import '../utils/keyboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _firstController = TextEditingController();
  TextEditingController _secondController = TextEditingController();
  String firstNumber = "Decimal";
  String secondNumber = "Hexadecimal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff22333B),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Color(0xff2A3C44),
        title: Center(
          child: Text(
            "Number Conversion",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 15),
                              Text(
                                firstNumber,
                                style: TextStyle(
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Color(0xffC4C4C4),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 15),
                              Text(
                                secondNumber,
                                style: TextStyle(
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Color(0xffC4C4C4),
                    ),
                    Text(".", style: TextStyle(color: Color(0xff22333B))),
                  ],
                ),
              ),
            ),
            Keyboard(this),
          ],
        ),
      ),
    );
  }
}

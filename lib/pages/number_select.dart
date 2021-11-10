import 'package:flutter/material.dart';

class NumberSystems extends StatefulWidget {
  @override
  _NumberSystemsState createState() => _NumberSystemsState();
}

class _NumberSystemsState extends State<NumberSystems> {
  Map<String, dynamic> strBaseMap = {
    "Decimal": "₍₁₀₎",
    "Binary": "₍₂₎",
    "Hexadecimal": "₍₁₆₎",
    "Octal": "₍₈₎"
  };

  Widget createButton(String name) {
    return InkWell(
      onTap: () => Navigator.pop(context, name),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Color(0xff2A3C44),
            border: Border.all(color: Color(0xff242424))),
        child: Text(
          "$name ${strBaseMap[name]}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      backgroundColor: Color(0xff22333B),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Color(0xff2A3C44),
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Select Number System",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          createButton("Decimal"),
          SizedBox(height: 20),
          createButton("Binary"),
          SizedBox(height: 20),
          createButton("Hexadecimal"),
          SizedBox(height: 20),
          createButton("Octal"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Key extends StatelessWidget {
  String value;
  var parent;
  Key(this.value, this.parent);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: value != "undo"
          ? Text(
              value,
              style: TextStyle(color: Colors.white),
            )
          : Icon(Icons.arrow_back),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Color(0xff636363)),
      ),
    );
  }
}

class Keyboard extends StatefulWidget {
  var parent;

  Keyboard(this.parent);

  @override
  _KeyboardState createState() => _KeyboardState(parent);
}

class _KeyboardState extends State<Keyboard> {
  var parent;
  List<Widget> keys = [];
  _KeyboardState(this.parent);

  @override
  void initState() {
    super.initState();
    keys = [
      Expanded(child: Key("7", parent)),
      Expanded(child: Key("8", parent)),
      Expanded(child: Key("9", parent)),
      Expanded(child: Key("AC", parent)),
      Expanded(child: Key("4", parent)),
      Expanded(child: Key("5", parent)),
      Expanded(child: Key("6", parent)),
      Expanded(child: Key("1", parent)),
      Expanded(child: Key("2", parent)),
      Expanded(child: Key("3", parent)),
      Expanded(child: Key("undo", parent)),
      Expanded(child: Key("0", parent)),
      Expanded(child: Key(".", parent))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff454748),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    keys[0],
                    keys[1],
                    keys[2],
                  ],
                ),
                Column(
                  children: [
                    Text("A"),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                keys[4],
                keys[5],
                keys[6],
              ],
            ),
            Row(
              children: [
                keys[7],
                keys[8],
                keys[9],
              ],
            ),
            Row(
              children: [
                keys[11],
                keys[12],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Key extends StatelessWidget {
  String value;
  var parent;
  Key(this.value, this.parent);

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(100)), // Circular
        color: Color(0xff636363),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return InkWell(
              // Ripple Effect
              borderRadius: BorderRadius.all(Radius.circular(100)),
              onTap: () {},
              child: Container(
                // For ripple area
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget longButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
      decoration: BoxDecoration(
        color: Color(0xff636363),
        borderRadius: value == "undo" || value == "AC" || value == "0"
            ? value == "undo"
                ? BorderRadius.horizontal(
                    left: Radius.circular(100),
                    right: Radius.circular(100),
                  )
                : BorderRadius.vertical(
                    top: Radius.circular(100), bottom: Radius.circular(100))
            : null,
      ),
      child: TextButton(
        onPressed: () {},
        child: value == "undo"
            ? Icon(
                Icons.arrow_back,
                color: Colors.white,
              )
            : Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ["undo", "ac", "0"].contains(value) ? longButton() : _button();
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
      Key("7", parent),
      Key("8", parent),
      Key("9", parent),
      Key("AC", parent),
      Key("4", parent),
      Key("5", parent),
      Key("6", parent),
      Key("1", parent),
      Key("2", parent),
      Key("3", parent),
      Key("undo", parent),
      Key("0", parent),
      Key(".", parent)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xff454748),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(8),
          itemCount: keys.length,
          crossAxisCount: 4,
          itemBuilder: (context, index) => keys[index],
          staggeredTileBuilder: (index) => StaggeredTile.count(
              index == 11 ? 2 : 1, index == 3 || index == 10 ? 2 : 1),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      _button("7"),
      _button("8"),
      _button("9"),
      _button("AC"),
      _button("4"),
      _button("5"),
      _button("6"),
      _button("1"),
      _button("2"),
      _button("3"),
      _button("⌫"),
      _button("0"),
      _button(".")
    ];
  }

  List<String> setController() {
    List<String> result = [];
    switch (parent.currFocus) {
      case "first":
        result = parent.firstValue;
        break;
      case "second":
        result = parent.secondValue;
        break;
    }
    return result;
  }

  void onPressed(String value) {
    var targetField = setController();
    var newValues;
    switch (value) {
      case "AC":
        targetField = [];
        break;
      case "⌫":
        targetField.removeLast();
        break;
      default:
        targetField.add(value);
        break;
    }
    setState(() {
      if (parent.currFocus == "first") {
        parent.firstValue = targetField;
        parent.secondValue = parent.convert();
      } else {
        parent.secondValue = targetField;
        parent.firstValue = parent.convert();
      }
    });
  }

  Widget _button(String value) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0, 4),
            ),
          ],
        ),
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
                onTap: () => onPressed(value),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff454748),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Center(
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
      ),
    );
  }
}

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
  Map<String, dynamic> keyValidators = {
    "Hexadecimal": r"^[A-Fa-f0-9]*\.?[A-Fa-f0-9]*$",
    "Decimal": r"^[0-9]*\.?[0-9]*$",
    "Binary": r"^[0-1]*\.?[0-1]*$",
    "Octal": r"^[0-7]*\.?[0-7]*$",
  };
  _KeyboardState(this.parent);

  void generateKeys() {
    keys = parent.numberKeyboard
        ? [
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
          ]
        : [
            _button("A"),
            _button("B"),
            _button("C"),
            _button("D"),
            _button("E"),
            _button("F"),
            _button("."),
            _button("⌫"),
            _button("AC")
          ];
  }

  @override
  void initState() {
    super.initState();
    generateKeys();
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

  void updateCalculation([var target]) {
    if (parent.currFocus == "first") {
      parent.firstValue = target;
      parent.secondValue = parent.convert();
    } else {
      parent.secondValue = target;
      parent.firstValue = parent.convert();
    }
  }

  void onPressed(String value) {
    var targetField = setController();
    if (["AC", "⌫"].contains(value)) {
      if (value == "AC") {
        targetField = ["0"];
      } else {
        if (parent.firstValue.length == 1 || parent.secondValue.length == 1) {
          targetField = ["0"];
        } else {
          targetField.removeLast();
        }
      }
    } else {
      RegExp currRegex = RegExp(parent.currFocus == "first"
          ? keyValidators[parent.firstNumber]
          : keyValidators[parent.secondNumber]);
      if (currRegex.hasMatch(value)) {
        if ((parent.currFocus == "first" &&
                parent.firstValue.length == 1 &&
                parent.firstValue[0] == "0") ||
            (parent.currFocus == "second" &&
                parent.secondValue.length == 1 &&
                parent.secondValue[0] == "0")) {
          targetField[0] = value;
        } else {
          /*int max = 0;
          bool isHexa = false;
          print(
              "${parent.currFocus}, ${parent.firstNumber}, ${parent.secondNumber}");
          if ((parent.firstNumber == "Hexadecimal") ||
              (parent.secondNumber == "Hexadecimal")) {
            max = 9;
            isHexa = true;
          } else if (parent.firstNumber == "Octal" ||
              parent.secondNumber == "Octal") {
            max = 7;
          }
          num lastElement =
              num.parse(targetField[targetField.length - 1] + value);
          if (lastElement > max && isHexa && lastElement <= 15) {
            targetField[targetField.length - 1] = lastElement.toString();
          } else {*/
          targetField.add(value);
          //print("$targetField, $lastElement, $max, $value");
        }
      }
    }
    updateCalculation(targetField);
    parent.setState(() {
      parent.firstValue = parent.firstValue;
      parent.secondValue = parent.secondValue;
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
    generateKeys();
    return Expanded(
      flex: 5,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff454748),
        ),
        child: Center(
          child: !parent.numberKeyboard
              ? GridView.count(
                  padding: EdgeInsets.only(left: 14, right: 14),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: keys,
                )
              : StaggeredGridView.countBuilder(
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

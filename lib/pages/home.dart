import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/keyboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String firstNumber = "Decimal";
  String secondNumber = "Hexadecimal";
  List<String> firstValue = [];
  List<String> secondValue = [];
  var currFocus = "first";

  Widget numberSelector(String numberSystem) {
    return Row(
      children: [
        Text(
          numberSystem,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xffE5E5E5),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_drop_down,
            color: Color(0xffE5E5E5),
          ),
        ),
      ],
    );
  }

  Widget textValue(List<String> value, String num) {
    String textValue = joinValue(value);
    return RichText(
      text: TextSpan(
        text: textValue == "" ? "0" : textValue,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            setState(() {
              currFocus = num;
            });
          },
        style: TextStyle(
          fontSize: 36,
          color: currFocus == num ? Color(0xff9AD5FF) : Colors.white,
        ),
      ),
    );
  }

  String joinValue(List<String> value) {
    String result = "";
    for (int i = 0; i < value.length; i++) {
      result += value[i];
    }
    return result;
  }

  List<String> wrapValue(String value) {
    List<String> result = [];
    for (int i = 0; i < value.length; i++) {
      result.add(value[i]);
    }
    return result;
  }

  List<String> decimalToBinary(dynamic value) {
    value = int.parse(joinValue(value));
    List<String> result = [];
    num remainder = 0;
    while (value >= 2) {
      remainder = value % 2;
      value = (value / 2).toInt();
      result.add(remainder.toString());
    }
    result.add("1");
    return List.from(result.reversed);
  }

  List<String> decimalToHexa(dynamic value) {
    value = int.parse(joinValue(value));
    List<String> result = [];
    num remainder = 0;
    Map<int, dynamic> hexaValues = {
      10: "A",
      11: "B",
      12: "C",
      13: "D",
      14: "E",
      15: "F"
    };
    while (value >= 16) {
      remainder = value % 16;
      value = (value / 16).toInt();
      if (hexaValues.containsKey(remainder)) {
        result.add(hexaValues[remainder]);
      } else {
        result.add(remainder.toString());
      }
    }
    result.add(value.toString());
    return List.from(result.reversed);
  }

  List<String> decimalToOctal(dynamic value) {
    value = int.parse(joinValue(value));
    List<String> result = [];
    num remainder = 0;
    while (value >= 8) {
      remainder = value % 8;
      value = (value / 8).toInt();
      result.add(remainder.toString());
    }
    result.add(value.toString());
    return List.from(result.reversed);
  }

  List<String> hexaToNormal(List<String> value, [reverse = false]) {
    List<String> alphabetVal = ["A", "B", "C", "D", "E", "F"];
    List<String> numVal = ["10", "11", "12", "13", "14", "15"];
    List<String> newValue = [];
    for (String val in value) {
      if (reverse) {
        if (numVal.contains(val)) {
          newValue.add(alphabetVal[numVal.indexOf(val)]);
        } else {
          newValue.add(val);
        }
      } else {
        if (alphabetVal.contains(val)) {
          newValue.add(numVal[alphabetVal.indexOf(val)]);
        } else {
          newValue.add(val);
        }
      }
    }
    return newValue;
  }

  List<List<String>> groupBy(List<String> values, int n) {
    List<List<String>> result = [];
    values = List.from(values.reversed);
    for (int i = 0; i < values.length; i += n) {
      List<String> newValues =
          values.sublist(i, i + n > values.length ? values.length : i + n);
      result.add(newValues);
    }
    return List.from(result.reversed);
  }

  List<String> toDecimal(List<String> value, int base,
      [bool binaryToOther = false, dynamic baseTarget = false]) {
    num result = 0;
    value = binaryToOther ? value : List.from(value.reversed);
    if (base == 16) {
      value = hexaToNormal(value);
    }
    for (int i = 0; i < value.length; i++) {
      result += double.parse(value[i]) * pow(base, i);
    }
    return binaryToOther && baseTarget == 16
        ? hexaToNormal([result.toString()], true)
        : wrapValue(result.toString());
  }

  List<String> binaryToOther(List<String> value, int base) {
    List groupedValue = [];
    List<String> result = [];
    switch (base) {
      case 16:
        groupedValue = groupBy(value, 4);
        break;
      case 8:
        groupedValue = groupBy(value, 3);
    }
    for (var value in groupedValue) {
      List<String> newValue = toDecimal(value, 2, true, 16);
      for (String val in newValue) {
        result.add(val);
      }
    }
    return result;
  }

  List<int> subsetSum(List<int> arr, num num) {
    if (num == 0 || num < 1) {
      return [];
    } else if (arr.isEmpty) {
      return [];
    } else {
      if (arr[0] == num) {
        return [arr[0]];
      } else {
        var withV = subsetSum(arr.sublist(1, arr.length), (num - arr[0]));
        if (withV.isNotEmpty) {
          var result = [arr[0]];
          result.addAll(withV);
          return result;
        } else {
          return subsetSum(arr.sublist(1, arr.length), num);
        }
      }
    }
  }

  List<String> findSubset(
      String value, List<String> zeroGroups, List<int> nums) {
    List<int> subset = subsetSum(nums, double.parse(value));
    List<String> result = List.from(zeroGroups);
    if (subset.isEmpty) {
      return zeroGroups;
    } else {
      for (int i in subset) {
        result[nums.indexOf(i)] = "1";
      }
      return result;
    }
  }

  List<String> toBinary(List<String> values, int base) {
    List<String> result = [];
    List<String> zeroGroups = [];
    List<int> nums = [];

    switch (base) {
      case 2:
        break;
      case 16:
        values = hexaToNormal(values);
        zeroGroups = ["0", "0", "0", "0"];
        nums = [8, 4, 2, 1];
        break;
      case 8:
        zeroGroups = ["0", "0", "0"];
        nums = [4, 2, 1];
        break;
    }
    for (String value in values) {
      List<String> binaryVal = findSubset(value, zeroGroups, nums);
      for (String binVal in binaryVal) {
        result.add(binVal);
      }
    }
    int indexOf = result.indexOf("1");
    return result.sublist(
        indexOf == -1 ? 0 : indexOf, indexOf == -1 ? 1 : result.length);
  }

  List<String> hexaToOctal(var value) {
    List<String> binValue = toBinary(value, 16);
    return binaryToOther(binValue, 8);
  }

  List<String> octalToHexa(var value) {
    List<String> binValue = toBinary(value, 8);
    return binaryToOther(binValue, 16);
  }

  List<String> calculate(
      List<String> valueTarget, String numSystem, String numSystemTarget) {
    List<String> result = [];
    switch (numSystem) {
      case "Decimal":
        switch (numSystemTarget) {
          case "Binary":
            result = decimalToBinary(valueTarget);
            break;
          case "Hexadecimal":
            result = decimalToHexa(valueTarget);
            break;
          case "Octal":
            result = decimalToOctal(valueTarget);
            break;
        }
        break;
      case "Binary":
        switch (numSystemTarget) {
          case "Decimal":
            result = toDecimal(valueTarget, 2);
            break;
          case "Hexadecimal":
            result = binaryToOther(valueTarget, 16);
            break;
          case "Octal":
            result = binaryToOther(valueTarget, 8);
            break;
        }
        break;
      case "Hexadecimal":
        switch (numSystemTarget) {
          case "Decimal":
            result = toDecimal(valueTarget, 16);
            break;
          case "Binary":
            result = toBinary(valueTarget, 16);
            break;
          case "Octal":
            result = hexaToOctal(valueTarget);
            break;
        }
        break;
      case "Octal":
        switch (numSystemTarget) {
          case "Decimal":
            result = toDecimal(valueTarget, 8);
            break;
          case "Binary":
            result = toBinary(valueTarget, 8);
            break;
          case "Hexadecimal":
            result = octalToHexa(valueTarget);
            break;
        }
        break;
    }
    return result;
  }

  List<String> convert() {
    var valueTarget;
    var numSystem;
    var numSystemTarget;
    if (currFocus == "first") {
      valueTarget = secondValue;
      numSystem = secondNumber;
      numSystemTarget = firstNumber;
    } else {
      valueTarget = firstValue;
      numSystem = firstNumber;
      numSystemTarget = secondNumber;
    }

    return calculate(valueTarget, numSystem, numSystemTarget);
  }

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
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                numberSelector(firstNumber),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                textValue(firstValue, "first"),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Color(0xffC4C4C4),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                numberSelector(secondNumber),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                textValue(firstValue, "second"),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

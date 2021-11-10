import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import '../utils/keyboard.dart';
import 'number_select.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHexa = false;
  bool numberKeyboard = true;
  String firstNumber = "Decimal";
  String secondNumber = "Hexadecimal";
  List<String> firstValue = ["0"];
  List<String> secondValue = ["0"];
  Map<String, dynamic> strBaseMap = {
    "Decimal": "₍₁₀₎",
    "Binary": "₍₂₎",
    "Hexadecimal": "₍₁₆₎",
    "Octal": "₍₈₎"
  };
  var currFocus = "first";
  Map<String, dynamic> numHexaMap = {
    "10": "A",
    "11": "B",
    "12": "C",
    "13": "D",
    "14": "E",
    "15": "F"
  };

  Map<String, dynamic> charHexaMap = {
    "A": "10",
    "B": "11",
    "C": "12",
    "D": "13",
    "E": "14",
    "F": "15"
  };

  void changeNumSystem(String newSystem, String numIndex) {
    setState(() {
      switch (numIndex) {
        case "first":
          firstNumber = newSystem;
          firstValue = calculate(secondValue, secondNumber, firstNumber);
          break;
        case "second":
          secondNumber = newSystem;
          secondValue = calculate(firstValue, firstNumber, secondNumber);
          break;
      }
    });
  }

  void goToSelection(String numIndex) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NumberSystems(),
      ),
    );
    if (result != null) {
      changeNumSystem(result, numIndex);
    }
  }

  Widget numberSelector(String numberSystem, String numIndex) {
    return Row(
      children: [
        Text(
          "$numberSystem ${strBaseMap[numberSystem]}",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xffE5E5E5),
          ),
        ),
        IconButton(
          onPressed: () => goToSelection(numIndex),
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
    return SelectableText(
      textValue,
      onTap: () {
        setState(() {
          currFocus = num;
          if ((currFocus == "first" && firstNumber == "Hexadecimal") ||
              (currFocus == "second" && secondNumber == "Hexadecimal")) {
            isHexa = true;
          } else {
            isHexa = false;
          }
        });
      },
      style: TextStyle(
        fontSize: 28,
        color: currFocus == num ? Color(0xff9AD5FF) : Colors.white,
      ),
    );
  }

  String joinValue(dynamic value) {
    String result = "";
    for (int i = 0; i < value.length; i++) {
      result += value[i];
    }
    return result;
  }

  List<String> wrapValue(dynamic value) {
    List<String> result = [];
    for (int i = 0; i < value.length; i++) {
      result.add(value[i]);
    }
    return result;
  }

  List<String> countInteger(num value, int base) {
    List<String> result = [];
    num remainder = 0;
    while (value >= base) {
      remainder = value % base;
      value = value ~/ base;
      result.add(remainder.toString());
    }
    result.add(value.toString());
    if (base == 16) {
      result = hexaToNormal(result, true);
    }
    return result;
  }

  List<String> roundDecimal(List<String> value, int base, String nextVal) {
    switch (base) {
      case 2:
        if (nextVal == "1") {
          if (value[19] == "0") {
            value[19] = "1";
          } else {
            List<String> copyResult = List.from(value);
            for (int i = value.length - 2; i >= 0; i--) {
              if (copyResult[i] == "1") {
                value[i] = "0";
              } else {
                value[i] = "1";
                break;
              }
            }
          }
        }
        break;
      case 16:
        String lastVal = value[value.length - 1];
        String newVal = lastVal;
        if (lastVal == "9") {
          newVal = "A";
        } else if (numHexaMap.containsKey(lastVal)) {
          String nextHex = lastVal == "F" ? "F" : numHexaMap[lastVal];
          newVal = lastVal == "F"
              ? "F"
              : charHexaMap[(int.parse(nextHex) + 1).toString()];
        }

        value[value.length - 1] = newVal;
        break;
      case 8:
        int lastVal = int.parse(value[value.length - 1]);
        int intVal = int.parse(nextVal);
        if (intVal > 4) {
          String newVal = (value == 8 ? 8 : lastVal + 1).toString();
          value[value.length - 1] = newVal;
        }
        break;
    }
    return value;
  }

  List<String> countDecimal(dynamic value, int base) {
    value = double.parse("0.$value");
    List<String> result = [];
    num remainder = 0;
    String strRemainder = "";
    String nextVal = "";
    while (value != 0 && result.length <= 21) {
      value = (value * base).toDouble();
      remainder = value.toInt();
      strRemainder = remainder.toString();
      if (value % remainder == 0) {
        result.add(value.toString());
        break;
      } else {
        if (remainder != 0) {
          value = double.parse("0.${value.toString().split(".")[1]}");
        }
      }

      if (result.length == 20) {
        nextVal = strRemainder;
        result = roundDecimal(result, base, nextVal);
        break;
      } else {
        if (numHexaMap.containsKey(strRemainder)) {
          result.add(numHexaMap[strRemainder]);
        } else {
          result.add(strRemainder);
        }
      }
    }

    return result.isEmpty ? ["0"] : result;
  }

  List<String> decimalToOther(dynamic value, int base) {
    dynamic integer;
    dynamic decimal;
    if (value.contains(".")) {
      value = joinValue(value).split(".");
      integer = int.parse(value[0]);
      decimal = value[1];
    }
    value = int.parse(joinValue(value));
    List<String> result = countInteger(integer != null ? integer : value, base);
    if (decimal != null) {
      result = List.from(result.reversed);
      result.add(".");
      result.addAll(countDecimal(decimal, base));
    }
    return decimal != null ? result : List.from(result.reversed);
  }

  List<String> hexaToNormal(List<String> value, [reverse = false]) {
    List<String> newValue = [];
    for (String val in value) {
      if (reverse) {
        if (numHexaMap.containsKey(val)) {
          newValue.add(numHexaMap[val]);
        } else {
          newValue.add(val);
        }
      } else {
        if (charHexaMap.containsKey(val)) {
          newValue.add(charHexaMap[val]);
        } else {
          newValue.add(val);
        }
      }
    }
    return newValue;
  }

  List<dynamic> groupBy(dynamic values, int n,
      [isDecimal = false, reversed = true]) {
    List<dynamic> result = [];
    if (isDecimal) {
      values = joinValue(values).split(".");
      dynamic integers = wrapValue(values[0]);
      dynamic decimals = wrapValue(values[1]);

      integers = groupBy(integers, n, false);
      decimals = groupBy(decimals, n, false, false);
      result.addAll(integers);
      result.add(["."]);
      for (int i = 0; i < decimals.length; i++) {
        var value = decimals[i];
        if (value.length < n) {
          for (int _ = 0; _ < n - value.length + 1; _++) {
            value.add("0");
          }
        }
      }
      result.addAll(decimals);
      return result;
    } else {
      values = reversed ? List.from(values.reversed) : values;
      for (int i = 0; i < values.length; i += n) {
        dynamic newValues =
            values.sublist(i, i + n > values.length ? values.length : i + n);
        result.add(newValues);
      }
      return reversed ? List.from(result.reversed) : result;
    }
  }

  dynamic calculateDecimal(dynamic value, int base, bool isDecimal,
      [bool reversed = false]) {
    num result = 0;
    if (isDecimal) {
      for (int i = 0; i < value.length; i++) {
        result += double.parse(value[i]) * pow(base, -(i + 1));
      }
      return result;
    } else {
      value = reversed ? List.from(value.reversed) : value;
      for (int i = 0; i < value.length; i++) {
        if (charHexaMap.containsKey(value[i])) {
          value[i] = charHexaMap[value[i]];
        }
        result += int.parse(value[i]) * pow(base, i);
      }
      return result.toInt();
    }
  }

  List<String> toDecimal(dynamic value, int base,
      [bool binaryToOther = false,
      dynamic baseTarget = false,
      reversed = false]) {
    dynamic result = 0;
    if (value.contains(".")) {
      value = joinValue(value).split(".");
      List<String> integers = wrapValue(value[0]);
      List<String> decimals = wrapValue(value[1]);
      if (base == 16) {
        integers = hexaToNormal(integers);
        decimals = hexaToNormal(decimals);
      }
      result += calculateDecimal(
          binaryToOther ? integers : List.from(integers.reversed), base, false);
      result += calculateDecimal(decimals, base, true);
    } else {
      value = binaryToOther ? value : List.from(value.reversed);
      result += calculateDecimal(value, base, false, reversed);
    }
    String resultStr = result.toString();
    return binaryToOther && baseTarget == 16
        ? hexaToNormal([resultStr], true)
        : wrapValue(resultStr);
  }

  List<String> binaryToOther(List<String> value, int base) {
    List groupedValue = [];
    List<String> result = [];
    bool isDecimal = value.contains(".");
    bool pastDot = false;
    switch (base) {
      case 16:
        groupedValue = groupBy(value, 4, isDecimal);
        break;
      case 8:
        groupedValue = groupBy(value, 3, isDecimal);
        break;
    }
    for (var value in groupedValue) {
      if (value.contains(".")) {
        result.add(".");
        pastDot = true;
      } else {
        List<String> newValue = toDecimal(value, 2, true, base, pastDot);

        for (String val in newValue) {
          result.add(val);
        }
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
      if (value == ".") {
        result.add(value);
      } else {
        List<String> binaryVal = findSubset(value, zeroGroups, nums);
        for (String binVal in binaryVal) {
          result.add(binVal);
        }
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
            result = decimalToOther(valueTarget, 2);
            break;
          case "Hexadecimal":
            result = decimalToOther(valueTarget, 16);
            break;
          case "Octal":
            result = decimalToOther(valueTarget, 8);
            break;
          default:
            result = valueTarget;
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
          default:
            result = valueTarget;
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
          default:
            result = valueTarget;
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
          default:
            result = valueTarget;
            break;
        }
    }
    return result;
  }

  List<String> convert() {
    var valueTarget;
    var numSystem;
    var numSystemTarget;
    if (currFocus == "first") {
      valueTarget = firstValue;
      numSystem = firstNumber;
      numSystemTarget = secondNumber;
    } else {
      valueTarget = secondValue;
      numSystem = secondNumber;
      numSystemTarget = firstNumber;
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
              flex: 3,
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
                                numberSelector(firstNumber, "first"),
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
                                numberSelector(secondNumber, "second"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                textValue(secondValue, "second"),
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
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff454748),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                  )),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  numberKeyboard = true;
                                });
                              },
                              child: Text(
                                "123",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(
                                      numberKeyboard ? 0xffD9D9D9 : 0xffA4A4A4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Color(0xff242525).withOpacity(0.3),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                  )),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  numberKeyboard = false;
                                });
                              },
                              child: Text(
                                "abc",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(
                                      numberKeyboard ? 0xffA4A4A4 : 0xffD9D9D9),
                                ),
                              ),
                            ),
                          ),
                        ],
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

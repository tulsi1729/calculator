import 'package:calculator/red_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:function_tree/function_tree.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 25, vertical: 13);
    final equationController = TextEditingController();
    final seekAnswerController = TextEditingController(text: "");

    const digitList = [
      "C",
      "()",
      "%",
      "/",
      "7",
      "8",
      "9",
      "X",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "+/-",
      "0",
      ".",
      "=",
    ];

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: padding,
          child: Expanded(
            child: Column(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      TextField(
                        controller: equationController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        showCursor: true,
                        readOnly: true,
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      TextField(
                        controller: seekAnswerController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w300),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                      ),
                      // const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            child: IconButton(
                              onPressed: () {
                                if (equationController.text.isEmpty) {
                                  return;
                                }
                                equationController.text =
                                    equationController.text.substring(
                                        0, equationController.text.length - 1);
                                try {
                                  seekAnswerController.text = equationController
                                      .text
                                      .interpret()
                                      .toString();
                                } catch (error) {
                                  seekAnswerController.text = "";
                                }
                              },
                              icon: const Icon(Icons.backspace),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      const Divider(color: Colors.black),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
                gridView(digitList, equationController, seekAnswerController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Flexible gridView(
      List<String> digitList,
      TextEditingController equationController,
      TextEditingController seekAnswerController) {
    return Flexible(
      flex: 2,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        //TODO: remove child aspectRatio
        mainAxisSpacing: 10,
        crossAxisSpacing: 40,
        children: digitList.map(
          (digitLabel) {
            return DigitButton(
              digitLabel: digitLabel,
              equationController: equationController,
              seekAnswerController: seekAnswerController,
            );
          },
        ).toList(),
      ),
    );
  }
}

class DigitButton extends StatefulWidget {
  const DigitButton({
    super.key,
    required this.digitLabel,
    required this.equationController,
    required this.seekAnswerController,
  });

  final String digitLabel;
  final TextEditingController equationController;
  final TextEditingController seekAnswerController;

  @override
  State<DigitButton> createState() => _DigitButtonState();
}

class _DigitButtonState extends State<DigitButton> {
  // double _fontSize = 24.0;
  final _fontMaxSize = 24.0;
  final _fontMinSize = 35.0;
  bool _pressed = false;

  void _handleTapDown(_) {
    setState(() {
      _pressed = true;
    });
  }

  void _handleTapUp(_) {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void evaluateEquation() {
      String text = widget.equationController.text;
      widget.equationController.text = text.interpret().toString();
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        child: RedContainer(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                // shape: RoundedRectangleBorder(
                //   // borderRadius:
                //   //     BorderRadius., // Adjust as per your requirement
                // ),
                // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                ),
            child: RedContainer(
              child: Text(
                widget.digitLabel,
                style: TextStyle(
                  fontSize: _pressed ? _fontMaxSize : _fontMinSize,
                ),
              ),
            ),
            onPressed: () {
              switch (widget.digitLabel) {
                case "C":
                  widget.equationController.clear();
                  break;
                case "()":
                  //
                  break;
                case "X":
                  widget.equationController.text += "*";
                  break;
                case "+/-":
                  //
                  break;
                case "=":
                  evaluateEquation();
                  break;
                default:
                  widget.equationController.text += widget.digitLabel;
              }
              try {
                String text = widget.equationController.text;
                String answer = text.interpret().toString();
                widget.seekAnswerController.text = answer;
              } catch (error) {
                widget.seekAnswerController.text = "";
              }
            },
          ),
        ),
      ),
    );
  }
}

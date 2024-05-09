import 'dart:async';

import 'package:calculator/red_container.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class Calculator extends StatelessWidget {
  const Calculator({super.key});

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
        body: RedContainer(
          child: Container(
            padding: padding,
            child: Expanded(
              child: RedContainer(
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
                    const SizedBox(
                      height: 10,
                    ),
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
                    const Spacer(),
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
                              equationController.text = equationController.text
                                  .substring(
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      childAspectRatio: 3 / 2.5,
                      //TODO: remove child aspectRatio
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: digitList.map(
                        (digitLabel) {
                          return DigitButton(
                            digitLabel: digitLabel,
                            equationController: equationController,
                            seekAnswerController: seekAnswerController,
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigitButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    void evaluateEquation() {
      String text = equationController.text;
      equationController.text = text.interpret().toString();
    }

    return ElevatedButton(
      child: Text(digitLabel,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w400)),
      onPressed: () {
        switch (digitLabel) {
          case "C":
            equationController.clear();
            break;
          case "()":
            //
            break;
          case "X":
            equationController.text += "*";
            break;
          case "+/-":
            //
            break;
          case "=":
            evaluateEquation();
            break;
          default:
            equationController.text += digitLabel;
        }
        try {
          String text = equationController.text;
          String answer = text.interpret().toString();
          seekAnswerController.text = answer;
        } catch (error) {
          seekAnswerController.text = "";
        }
      },
    );
  }
}

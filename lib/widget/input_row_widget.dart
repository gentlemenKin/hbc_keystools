import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputRowWidget extends StatelessWidget {
  const InputRowWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.hint,
    required this.showParse,
    this.formatter,
    required this.showError,
    required this.errorMsg,
  }) : super(key: key);
  final String title;
  final TextEditingController controller;
  final String hint;
  final bool showParse;
  final TextInputFormatter? formatter;
  final bool showError;
  final String errorMsg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 150,
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xffE5E7Eb)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: controller,
                  inputFormatters: formatter != null ? [formatter!] : [],
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    suffix: showParse
                        ? GestureDetector(
                            onTap: () async {
                              var str = await Clipboard.getData(Clipboard.kTextPlain);
                              controller.text = str?.text ?? '';
                            },
                            child: Text(
                              'Paste',
                              style: TextStyle(
                                color: Color(0xff9700E9),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : SizedBox(),
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                  ),
                ),
              ),
              if (showError)
                Text(
                  errorMsg,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffE32349),
                    fontWeight: FontWeight.w500,
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}

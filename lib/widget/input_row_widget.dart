import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputRowWidget extends StatelessWidget {
  const InputRowWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.hint,
  }) : super(key: key);
  final String title;
  final TextEditingController controller;
  final String hint;

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
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xffE5E7Eb)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
              ),
            ),
          ),
        )
      ],
    );
  }
}

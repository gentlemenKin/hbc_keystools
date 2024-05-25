import 'package:flutter/material.dart';

class SingleInputWidget extends StatelessWidget {
  const SingleInputWidget({Key? key, required this.hint, required this.controller}) : super(key: key);
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 150,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffE5E7Eb)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
        ),
      ),
    );

    //   Container(
    //   padding: EdgeInsets.symmetric( horizontal: 16),
    //   decoration: BoxDecoration(
    //     border: Border.all(width: 1, color: Color(0xffE5E7Eb)),
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: TextField(
    //     controller: controller,
    //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
    //     decoration: InputDecoration(
    //       border: InputBorder.none,
    //       hintText: hint,
    //       hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
    //     ),
    //   ),
    // ));
  }
}

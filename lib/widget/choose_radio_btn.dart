import 'package:flutter/material.dart';
class ChooseRadioBtn extends StatelessWidget {
  const ChooseRadioBtn({Key? key,required this.choose}) : super(key: key);
  final bool choose;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: choose?4:1,color: choose?Color(0xff9700E9):Color(0xffE5E7EB)),
          color: Colors.white
      ),
    );
  }
}

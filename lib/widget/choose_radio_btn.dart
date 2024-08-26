import 'package:flutter/material.dart';
import 'package:hbc_keystools/local/color_constant.dart';
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
        border: Border.all(width: choose?4:1,color: choose?ColorConstant.themeColor:ColorConstant.color_0xffE5E7Eb),
          color: ColorConstant.color_0xffffff
      ),
    );
  }
}

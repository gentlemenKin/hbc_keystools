import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';

class CommonButtonWidget extends StatelessWidget {
  const CommonButtonWidget({Key? key, required this.callback,required this.string}) : super(key: key);
  final GestureTapCallback callback;
  final String string;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConstant.themeColor,
        ),
        child: Center(
          child: Text(
            string,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: ColorConstant.color_0x000000),
          ),
        ),
      ),
    );
  }
}

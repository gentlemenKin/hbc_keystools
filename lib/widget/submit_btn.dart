import 'package:flutter/material.dart';
import 'package:hbc_keystools/local/color_constant.dart';

class SubmitBtnWidget extends StatelessWidget {
  const SubmitBtnWidget({
    Key? key,
    required this.content,
    required this.bgColor,
    required this.hasBorder,
    required this.callback,
    this.padding,
    this.radius,
  }) : super(key: key);
  final String content;
  final Color bgColor;
  final bool hasBorder;
  final GestureTapCallback callback;
  final EdgeInsetsGeometry ? padding;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: padding?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius??4),
            border: hasBorder
                ? Border.all(
              color: ColorConstant.color_0xffE5E7Eb,
            )
                : null,
            color: bgColor),
        child: Center(
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: hasBorder ? ColorConstant.color_0x000000 : ColorConstant.color_0xffffff,
            ),
          ),
        ),
      ),
    );
  }
}
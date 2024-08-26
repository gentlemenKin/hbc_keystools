import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../local/color_constant.dart';
import '../local/constant.dart';
class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.alignment = Alignment.center,
    this.width = 600,
    this.height = 400,
  });

  final Widget child;
  final EdgeInsets padding;
  final Alignment alignment;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: Alignment.center,
      alignment: alignment,
      child: Material(
        color: ColorConstant.color_0xffffff,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              // width: 400,
              height: height,
              width: width,
              // padding: const EdgeInsets.symmetric(horizontal: 24),
              padding: padding,
              child: child,
              // child: SingleChildScrollView(
              //   child: child,
              // ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    child: Image.asset(
                      AssetsConstant.commonDialgoClose,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).marginOnly(top: 10, bottom: 10);
  }
}
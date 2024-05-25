import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButtonWidget extends StatelessWidget {
  const CommonButtonWidget({Key? key, required this.callback}) : super(key: key);
  final GestureTapCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff9700E9),
        ),
        child: Center(
          child: Text(
            'Generate'.tr,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

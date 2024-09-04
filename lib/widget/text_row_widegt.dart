import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../local/color_constant.dart';

class TextRowWidget extends StatelessWidget {
  const TextRowWidget({
    Key? key,
    required this.title,
    required this.hint,
    required this.showCopy,
  }) : super(key: key);
  final String title;
  final String hint;
  final bool showCopy;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 150,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorConstant.color_0x000000),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: Colors.transparent,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffF3F4F6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hint,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorConstant.color_0xff6B7280),
                ),
                if(showCopy)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                      Clipboard.setData(ClipboardData(text: hint ?? ''));
                      EasyLoading.showToast('copy'.tr);
                    },
                    child: Text('Copy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.color_0xff6B7280,
                        )),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

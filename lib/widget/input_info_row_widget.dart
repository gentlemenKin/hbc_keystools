import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';
import 'package:hbc_keystools/widget/poup_window.dart';

import '../local/constant.dart';
import 'buble_widget.dart';
import 'new_popup_window.dart';

class InputInfoRowWidget extends StatelessWidget {
  const InputInfoRowWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.hint,
    required this.showParse,
    this.formatter,
    required this.showError,
    required this.errorMsg,
    required this.globalKey,
    required this.content,
  }) : super(key: key);
  final String title;
  final TextEditingController controller;
  final String hint;
  final bool showParse;
  final TextInputFormatter? formatter;
  final bool showError;
  final String errorMsg;
  final GlobalKey globalKey;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 150,
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: ColorConstant.color_0x000000),
              ),
              SizedBox(width: 4,),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {},
                onExit: (_) {
                  // PopupWindow.hint();
                },
                child: GestureDetector(
                    onTap: () {
                      PopupWindow.create(
                          globalKey,
                          BubbleWidget(
                            key,
                            240.0,
                            80.0,
                            ColorConstant.color_0x000000,
                            BubbleArrowDirection.top,
                            innerPadding: 0.0,
                            radius: 4.0,
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                child: Text(
                                  content,
                                  style: const TextStyle(
                                    color: Color(0xffD1D5DB),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ),
                          margin: 10.0,
                          offLeft: 0);
                    },
                    child: Image.asset(
                      key: globalKey,
                      AssetsConstant.infoBlack,
                      width: 20,
                      height: 20,
                    )),
              ),
            ],
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
                  border: Border.all(width: 1, color: ColorConstant.color_0xffE5E7Eb),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: controller,
                  inputFormatters: formatter != null ? [formatter!] : [],
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorConstant.color_0x000000),
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
                              'paste'.tr,
                              style: TextStyle(
                                color: ColorConstant.color_0x000000,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : SizedBox(),
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorConstant.color_0xff6B7280),
                  ),
                ),
              ),
              if (showError)
                Text(
                  errorMsg,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConstant.color_0xffE32349,
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

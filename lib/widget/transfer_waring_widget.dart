import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/widget/common_btn.dart';
import 'package:hbc_keystools/widget/submit_btn.dart';

import '../local/color_constant.dart';

class TransferWaringWidget extends StatelessWidget {
  const TransferWaringWidget({Key? key, required this.sure}) : super(key: key);
  final GestureTapCallback sure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '转出提示',
            style: TextStyle(
              color: ColorConstant.color_0xff333333,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text('transferConfirmWaring'.tr,
              style: TextStyle(
                color: ColorConstant.color_0x000000,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              )),
          Text('transferConfirmWaring1'.tr,
              style: TextStyle(
                color: ColorConstant.color_0x000000,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              )),
          Text('transferConfirmWaring2'.tr,
              style: TextStyle(
                color: ColorConstant.color_0x000000,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              )),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: SubmitBtnWidget(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    radius: 6,
                    content: 'Cancel'.tr,
                    bgColor: ColorConstant.color_0xffffff,
                    hasBorder: true,
                    callback: () {
                      Get.back();
                    }),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: SubmitBtnWidget(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  radius: 6,
                  content: 'Confirm'.tr,
                  bgColor: ColorConstant.themeColor,
                  hasBorder: true,
                  callback: () {
                    sure.call();
                    Get.back();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

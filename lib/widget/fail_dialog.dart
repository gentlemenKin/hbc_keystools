import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/constant.dart';
import 'package:hbc_keystools/widget/common_btn.dart';

import '../local/color_constant.dart';

class FailDialog extends StatelessWidget {
  const FailDialog({Key? key, required this.msg}) : super(key: key);
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EnsureTransfer'.tr,
            style: TextStyle(
              color: ColorConstant.color_0xff333333,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Image.asset(
                AssetsConstant.fail,
                height: 60,
                width: 60,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Failed'.tr,
                style: TextStyle(
                  color: ColorConstant.color_0xff333333,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 50),
                child: SingleChildScrollView(
                    child: Text(
                  msg,
                  style: TextStyle(
                    color: ColorConstant.color_0xff999999,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                )),
              ),
              SizedBox(
                height: 32,
              ),
              CommonButtonWidget(
                  callback: () {
                    Get.back();
                  },
                  string: 'knew'.tr),
            ],
          )
        ],
      ),
    );
  }
}

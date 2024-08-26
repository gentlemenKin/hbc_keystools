import 'package:flutter/material.dart';
import 'package:hbc_keystools/local/constant.dart';
import 'package:hbc_keystools/widget/common_btn.dart';

import '../local/color_constant.dart';

class FailDialog extends StatelessWidget {
  const FailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('确认转出', style: TextStyle(color: ColorConstant.color_0xff333333, fontSize: 18, fontWeight: FontWeight.w500,),),
          Column(
            children: [
              SizedBox(height: 32,),
              Image.asset(AssetsConstant.fail,height: 60,width: 60,),
              SizedBox(height: 12,),
              Text('失败', style: TextStyle(color: ColorConstant.color_0xff333333, fontSize: 18, fontWeight: FontWeight.w400,),),
              SizedBox(height: 8,),
              Text('可前往区块浏览器查看到账详情', style: TextStyle(color: ColorConstant.color_0xff999999, fontSize: 14, fontWeight: FontWeight.w300,),),
              SizedBox(height: 32,),
              CommonButtonWidget(callback: (){}, string: '前往'),
            ],
          )
        ],
      ),
    );
  }
}

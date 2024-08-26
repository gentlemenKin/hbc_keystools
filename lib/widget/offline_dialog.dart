import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';
import 'package:hbc_keystools/local/constant.dart';
import 'package:hbc_keystools/widget/common_btn.dart';

class OfflineDialog extends StatelessWidget {
  const OfflineDialog({Key? key,required this.content}) : super(key: key);
  final String content;
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
              SizedBox(height: 24,),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.color_0xffE5E7Eb),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Text(
                  'bc1psq9jl3q8q7ca64lr0mt5yf4q5ad3mer3449ln2m7dyx67vsslrxqzccmz5bc1psq9jl3q8q7ca64lr0mt5yf4q5ad3mer3449ln2m7dyx67'
                      'vsslrxqzccmz5bc1psq9jl3q8q7ca64lr0mt5yf4q5ad3mer3449ln2m7dyx67vsslrxqzccmz5bc'
                      '1psq9jl3q8q7ca64lr0mt5yf4q5ad3mer3449ln2m7dyx67vsslrxqzccmz5',
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: ColorConstant.color_0xff333333),
                ),
              ),
              SizedBox(height: 32,),
              CommonButtonWidget(callback: (){
                Clipboard.setData(ClipboardData(text: content));
                EasyLoading.showToast('复制成功');
              }, string: '复制'),
            ],
          )
        ],
      ),
    );
  }
}

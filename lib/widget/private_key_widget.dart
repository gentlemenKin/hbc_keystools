import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/widget/text_row_widegt.dart';

import '../result_bean.dart';

class privateKeyWidget extends StatelessWidget {
  const privateKeyWidget({Key? key, required this.bean}) : super(key: key);
  final ItemBean bean;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        TextRowWidget(title: 'ChildExtended'.tr, hint: bean.PrivKey),
        SizedBox(
          height: 10,
        ),
        TextRowWidget(title: 'Address'.tr, hint: bean.Address),
      ],
    );
  }
}

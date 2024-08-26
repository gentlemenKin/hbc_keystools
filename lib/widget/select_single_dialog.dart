import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/widget/select_coin_dialog.dart';
import 'package:hbc_keystools/widget/submit_btn.dart';

import '../local/color_constant.dart';
import 'item_widget.dart';

typedef SelectSponsorCallBack = Function(int index);

class SelectSingleDialog extends StatefulWidget {
  const SelectSingleDialog({Key? key, required this.chains, required this.callback}) : super(key: key);
  final List<SponsorBean> chains;
  final SelectSponsorCallBack callback;

  @override
  State<SelectSingleDialog> createState() => _SelectSingleDialogState();
}

class _SelectSingleDialogState extends State<SelectSingleDialog> {
  String chainName = '';
  List<SponsorBean> iniData = [];

  @override
  void initState() {
    super.initState();
    iniData = widget.chains;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 200,
      padding: const EdgeInsets.only(top: 28),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: ColorConstant.color_0xffffff),
      child: ListView.builder(
          itemCount: iniData.length,
          shrinkWrap: true,
          itemBuilder: (context, i) => ItemWidget(
                title: iniData[i],
                callback: (int index) {
                  widget.callback(index);
                  Get.back();
                },
                index: i,
              )),
    );
  }
}

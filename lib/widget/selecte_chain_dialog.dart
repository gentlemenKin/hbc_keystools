import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/widget/submit_btn.dart';

import 'item_widget.dart';

typedef SelectSponsorCallBack = Function(String data);

class SelectChainDialog extends StatefulWidget {
  const SelectChainDialog({Key? key, required this.chains, required this.callback}) : super(key: key);
  final List<String> chains;
  final SelectSponsorCallBack callback;

  @override
  State<SelectChainDialog> createState() => _SelectChainDialogState();
}

class _SelectChainDialogState extends State<SelectChainDialog> {
  String chainName = '';
  List<String> iniData = [];

  @override
  void initState() {
    super.initState();
    iniData = widget.chains;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 120,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 7),
          //   child: SearchTextField(
          //     width: 240,
          //     hintText: 'strategy.搜索币种名称'.tr,
          //     onSearch: (searchText) {
          //       data = iniData.where((element) => element.userName.toUpperCase().contains(searchText.toString().toUpperCase())).toList();
          //       if (ids.isNotEmpty && data.isNotEmpty) {
          //         for (var i in ids) {
          //           for (var e in data) {
          //             if (e.id == i) {
          //               e.isSlected = true;
          //             }
          //           }
          //         }
          //       }
          //       setState(() {});
          //     },
          //   ),
          // ),
          Flexible(
              child: ListView.builder(
                  itemCount: iniData.length,
                  itemBuilder: (context, i) => ItemWidget(
                        title: iniData[i],
                        callback: (String name) {
                          chainName = name;
                        },
                      ))),
          Container(
            height: 58,
            child: Column(
              children: [
                Container(
                  color: Color(0xffE5E7EB),
                  height: 1,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    SubmitBtnWidget(
                        content: 'Cancel'.tr,
                        bgColor: Colors.white,
                        hasBorder: true,
                        callback: () {
                          Get.back();
                        }),
                    SizedBox(
                      width: 8,
                    ),
                    SubmitBtnWidget(
                        content: 'Confirm'.tr,
                        bgColor: Color(0xff7618E8),
                        hasBorder: false,
                        callback: () {
                          widget.callback(chainName);
                          Get.back();
                        }),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

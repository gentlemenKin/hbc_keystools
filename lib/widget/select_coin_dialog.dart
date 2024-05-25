import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/widget/search_textfield.dart';
import 'package:hbc_keystools/widget/submit_btn.dart';

typedef SelectSponsorCallBack = Function(List<SponsorBean> data);
typedef IsItemSelect = Function(String id, bool selected);

class SelectCoinDialog extends StatefulWidget {
  const SelectCoinDialog({Key? key, required this.beans, required this.callback}) : super(key: key);
  final List<SponsorBean> beans;
  final SelectSponsorCallBack callback;

  @override
  State<SelectCoinDialog> createState() => _SelectCoinDialogState();
}

class _SelectCoinDialogState extends State<SelectCoinDialog> {
  final List<SponsorBean> ids = [];
  List<SponsorBean> data = [];
  List<SponsorBean> iniData = [];

  @override
  void initState() {
    super.initState();
    iniData = widget.beans;

    // for (var e in widget.beans) {
    //   if (e.isSlected) {
    //     ids.add(e.id);
    //   }
    // }
    if (widget.beans.isNotEmpty) {
      data.clear();
      data.addAll(widget.beans);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      width: 288,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: SearchTextField(
              width: 100,
              hintText: '搜索名称',
              onSearch: (searchText) {
                data = iniData.where((element) => element.userName.toUpperCase().contains(searchText.toString().toUpperCase())).toList();
                // if (ids.isNotEmpty && data.isNotEmpty) {
                //   for (var i in ids) {
                //     for (var e in data) {
                //       if (e.id == i) {
                //         e.isSlected = true;
                //       }
                //     }
                //   }
                // }
                setState(() {});
              },
            ),
          ),
          Flexible(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) => SponsorItemWidget(
                        bean: data[i],
                        callback: (String id, bool selected) {
                          if (selected) {
                            ids.add(data[i]);
                          } else {
                            ids.remove(data[i]);
                          }
                        },
                        showDetail: false,
                        showIcon: true,
                      ))),
          Container(
            height: 58,
            child: Column(
              children: [
                Container(
                  color: Color(0xffE5E7Eb),
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
                          widget.callback(ids);
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

class SponsorItemWidget extends StatefulWidget {
  const SponsorItemWidget({
    Key? key,
    required this.bean,
    required this.callback,
    required this.showDetail,
    required this.showIcon,
  }) : super(key: key);
  final SponsorBean bean;
  final IsItemSelect callback;
  final bool showDetail;
  final bool showIcon;

  @override
  State<SponsorItemWidget> createState() => _SponsorItemWidgetState();
}

class _SponsorItemWidgetState extends State<SponsorItemWidget> with AutomaticKeepAliveClientMixin {
  // final List<String> ids = [];
  bool select = false;

  @override
  void initState() {
    super.initState();
    select = widget.bean.isSlected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4,
        right: 7,
        left: 7,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          Checkbox(
              value: select,
              onChanged: (value) {
                setState(() {
                  select = value ?? false;
                });

                widget.callback(widget.bean.id, value ?? false);
                // if (value ?? false) {
                //   ids.add(widget.bean.id);
                // } else {
                //   ids.remove(widget.bean.id);
                // }
              }),
          const SizedBox(
            width: 16,
          ),
          Row(children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bean.userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),

              ],
            )
          ])
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class SponsorBean {
  String userName;
  bool isSlected;
  String id;

  SponsorBean(
    this.isSlected,
    this.userName,
    this.id,
  );
}

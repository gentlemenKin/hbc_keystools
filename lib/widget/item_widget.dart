import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/constant.dart';
import 'package:hbc_keystools/widget/select_coin_dialog.dart';

import '../local/color_constant.dart';

typedef IsItemSelect = Function(int index);

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    Key? key,
    required this.title,
    required this.callback,
    required this.index,
  }) : super(key: key);
  final SponsorBean title;
  final IsItemSelect callback;
  final int index;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with AutomaticKeepAliveClientMixin {
  // final List<String> ids = [];
  bool select = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.callback(widget.index);
        },
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 4,
            right: 7,
            left: 7,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title.userName,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstant.color_0x000000,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.title.isSlected)
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    AssetsConstant.select,
                    width: 20,
                    height: 20,
                    color: ColorConstant.themeColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

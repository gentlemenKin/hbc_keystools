import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';
import 'package:hbc_keystools/local/constant.dart';
import 'package:hbc_keystools/widget/buble_widget.dart';
import 'package:hbc_keystools/widget/new_popup_window.dart';
import 'package:hbc_keystools/widget/poup_window.dart';

class TabWidget extends StatefulWidget {
  const TabWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.showMore,
  }) : super(key: key);
  final String title;
  final bool isSelected;
  final bool showMore;

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: ColorConstant.color_0xff1F2937,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.showMore)
              SizedBox(
                width: 4,
              ),
            if (widget.showMore)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {},
                onExit: (_) {
                  // NewPopupWindow.hint();
                },
                child: GestureDetector(
                    onTap: () {
                      PopupWindow.create(
                          key,
                          BubbleWidget(
                            widget.key,
                            360.0,
                            120.0,
                            ColorConstant.color_0x000000,
                            BubbleArrowDirection.top,
                            innerPadding: 0.0,
                            radius: 4.0,
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                child: Text(
                                  'TransferWaring'.tr,
                                  style: const TextStyle(
                                    color: ColorConstant.color_0xffD1D5DB,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ),
                          margin: 10.0,
                          offLeft: 0);
                    },
                    child: Image.asset(
                      key: key,
                      AssetsConstant.info,
                      width: 20,
                      height: 20,
                      color: ColorConstant.color_0x000000,
                    )),
              ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          color: widget.isSelected ? ColorConstant.color_0x000000 : ColorConstant.color_0xffE5E7Eb,
          height: 2,
          width: 225,
        )
      ],
    );
  }
}

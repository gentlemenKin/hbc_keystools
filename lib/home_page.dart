import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';
import 'package:hbc_keystools/manager/lan_manager.dart';
import 'package:hbc_keystools/recorvery_page.dart';
import 'package:hbc_keystools/tab_widget.dart';
import 'package:hbc_keystools/tranfer_page.dart';
import 'package:hbc_keystools/widget/poup_window.dart';

import 'local/constant.dart';
import 'package:flutter/src/painting/box_border.dart' as Border;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey userPopKey = GlobalKey();
  final List<String> lan = ['en', 'zh'];
  String currentLan = 'en';
  PageController _controller = PageController();
  bool recoverySelected = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100,vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'title'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.color_0x000000,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    PopupWindow.create(
                        userPopKey,
                        Container(
                          height: 140,
                          width: 250,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorConstant.color_0xffffff),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: currentLan == 'zh'
                                      ? BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorConstant.color_0xffF3F4F6)
                                      : BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '简体中文',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: ColorConstant.color_0x000000,
                                        ),
                                      ),
                                      if (currentLan == 'zh')
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: ColorConstant.themeColor,
                                          ),
                                          width: 10,
                                          height: 10,
                                        )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                onTap: () {
                                  currentLan = 'zh';
                                  Get.updateLocale(Locale('zh', 'CN'));
                                  LanStream().addData(currentLan);
                                  PopupWindow.hint();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                child: Container(
                                  decoration: currentLan == 'en'
                                      ? BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorConstant.color_0xffF3F4F6)
                                      : BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'English',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: ColorConstant.color_0x000000,
                                        ),
                                      ),
                                      if (currentLan == 'en')
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: ColorConstant.themeColor,
                                          ),
                                          width: 10,
                                          height: 10,
                                        )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                onTap: () {
                                  currentLan = 'en';
                                  Get.updateLocale(Locale('en', 'US'));
                                  LanStream().addData(currentLan);
                                  PopupWindow.hint();
                                },
                              )
                            ],
                          ),
                        ));
                  },
                  child: Container(
                    key: userPopKey,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        border: Border.Border.all(width: 1, color: ColorConstant.color_0xffEAEAEA)),
                    child: Row(
                      children: [
                        Image.asset(
                          AssetsConstant.lanIcon,
                          height: 22,
                          width: 22,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          currentLan,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: ColorConstant.color_0xff6B7280),
                        ),
                        Image.asset(
                          AssetsConstant.moreIcon,
                          height: 14,
                          width: 14,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 21,
            ),
            Container(
              height: 1,
              color: ColorConstant.color_0xffEAEAEA,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      if (!recoverySelected) {
                        _controller.jumpToPage(0);
                      }
                      recoverySelected = true;

                      setState(() {});
                    },
                    child: TabWidget(
                      title: '恢复私钥',
                      isSelected: recoverySelected,
                      showMore: true,
                    )),
                GestureDetector(
                  onTap: () {
                    if (recoverySelected) {
                      _controller.jumpToPage(2);
                    }
                    recoverySelected = false;
                    setState(() {});
                  },
                  child: TabWidget(
                    title: 'EDDSA转账',
                    isSelected: !recoverySelected,
                    showMore: false,
                  ),
                )
              ],
            ),
            Expanded(
                child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                RecoveryPage(),
                TransferPage(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

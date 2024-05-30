import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:excel/excel.dart';
import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/native_add.dart';
import 'package:hbc_keystools/result_bean.dart';
import 'package:hbc_keystools/translation_service.dart';
import 'package:hbc_keystools/widget/common_btn.dart';
import 'package:hbc_keystools/widget/dialog_widget.dart';
import 'package:hbc_keystools/widget/input_row_select_widget.dart';
import 'package:hbc_keystools/widget/input_row_widget.dart';
import 'package:hbc_keystools/widget/poup_window.dart';
import 'package:hbc_keystools/widget/private_key_widget.dart';
import 'package:hbc_keystools/widget/select_coin_dialog.dart';
import 'package:hbc_keystools/widget/selecte_chain_dialog.dart';
import 'package:hbc_keystools/widget/text_row_widegt.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:cross_file/cross_file.dart';
import 'chain_result_bean.dart';
import 'local/constant.dart';
import 'package:path/path.dart' as path;
import 'package:excel/excel.dart' as excel;
import 'package:flutter/src/painting/box_border.dart' as Border;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await trayManager.setIcon(
    Platform.isWindows ? AssetsConstant.trayIco : AssetsConstant.trayPng,
  );
  await trayManager.setContextMenu(
    Menu(
      items: [
        MenuItem(key: 'open', label: '打开'),
        MenuItem.separator(),
        MenuItem(key: 'hide', label: '隐藏'),
        MenuItem.separator(),
        MenuItem(key: 'quit', label: '退出'),
      ],
    ),
  );

  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(1280, 800),
        minimumSize: Size(1280, 800),

        center: true,
        title: 'HBC桌面端应用',
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        // windowButtonVisibility: true,
      ), () async {
    await windowManager.show();
    await windowManager.focus();
    // await windowManager.setAsFrameless();

    print("windowManager 执行完成");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      locale: Locale('en', 'US'),
      translations: TranslationService(),
      fallbackLocale: TranslationService.fallbackLocale,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController metaController = TextEditingController(); //大于0的数字
  TextEditingController eciesController = TextEditingController();
  TextEditingController ricController = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller8 = TextEditingController();
  TextEditingController controller9 = TextEditingController();
  TextEditingController controller10 = TextEditingController();
  TextEditingController controller11 = TextEditingController();
  TextEditingController controller12 = TextEditingController();
  TextEditingController controller13 = TextEditingController();
  TextEditingController controller14 = TextEditingController();
  TextEditingController controller15 = TextEditingController();
  TextEditingController controller16 = TextEditingController();
  TextEditingController controller17 = TextEditingController();
  TextEditingController controller18 = TextEditingController();
  TextEditingController controller19 = TextEditingController();
  TextEditingController controller20 = TextEditingController();
  TextEditingController controller21 = TextEditingController();
  TextEditingController controller22 = TextEditingController();
  TextEditingController controller23 = TextEditingController();
  TextEditingController controller24 = TextEditingController();
  final List<SponsorBean> coins = [
    // SponsorBean(false, 'BTC', '0'),
    // SponsorBean(false, 'LTC', '2'),
    // SponsorBean(false, 'DOGE', '3'),
    // SponsorBean(false, 'ETH', '60'),
    // SponsorBean(false, 'BCH', '145'),
    // SponsorBean(false, 'TRX', '195'),
    // SponsorBean(false, 'POLYGON', '966'),
    // SponsorBean(false, 'ARBITRUM', '9001'),
    // SponsorBean(false, 'BSC', '714'),
    // SponsorBean(false, 'HECO', '553'),
    // SponsorBean(false, 'APT', '637'),
    // SponsorBean(false, 'SOL', '501'),
    // SponsorBean(false, 'DOT', '354'),
  ];
  final List<String> lan = ['en', 'zh'];
  String currentLan = 'en';
  final List<int> walletIndex = [0];
  int currentCoinIndex = -1;
  int currentWalletIndex = -1;
  String walletTypeName = 'Choose wallet type';
  String chooseChainName = 'ChooseChain'.tr;
  bool manualInput = false;
  final List<XFile> _list = [];
  List<ItemBean> resultList = [];
  String chain = '';
  String chainId = '';
  String helpWord = '';
  final List<XFile> _rsaList = [];
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  bool showError5 = false;
  bool showError6 = false;
  GlobalKey userPopKey = GlobalKey();

  void clickBtn(String zipPath, String userMnemonic, String eciesPrivKey, String rsaPrivKey, String vaultCount, String coinTypes) {
    if (Platform.isMacOS) {
      // var libraryPath = path.join(Directory.current.path, 'recovery_tool.dylib');
      // final dylib = ffi.DynamicLibrary.open(libraryPath);
      // final sumPointer = dylib.lookup<ffi.NativeFunction<SumFunc>>('GoRecovery');
      // // final sum = sumPointer.asFunction<Sum>();
      // sum(zipPath, userMnemonic, eciesPrivKey, rsaPrivKey, vaultCount, coinTypes);
    }
  }

  @override
  void initState() {
    super.initState();
    NativeLib().getChainList().then((value) {
      if (value != null) {
        debugPrint('当前的数据：${value.p.toDartString()}');
        List resJson = json.decode(value.p.toDartString());
        List<ChainItemBean> items = resJson.map((e) => ChainItemBean.fromJson(e)).toList();
        items.forEach((element) {
          coins.add(SponsorBean(false, element.name, element.valName));
        });
      }
    });
    metaController.addListener(() {
      if (metaController.text.isNotEmpty) {
        showError1 = false;
        setState(() {});
        if (metaController.text.length > 4) {
          metaController.text = metaController.text.toString().substring(0, 4);
        }
      }
    });
    eciesController.addListener(() {
      if (metaController.text.isNotEmpty) {
        showError5 = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'HyperBC Vault Key Derivation Tool',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: currentLan == 'zh'
                                        ? BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffF3F4F6))
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
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (currentLan == 'zh')
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: Color(0xff9700E9),
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
                                    PopupWindow.hint();
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: currentLan == 'en'
                                        ? BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffF3F4F6))
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
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (currentLan == 'en')
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Color(0xff9700E9),
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
                                    PopupWindow.hint();
                                  },
                                )
                              ],
                            ),
                          )

                          //     SelectChainDialog(
                          //   chains: lan,
                          //   callback: (String data) {
                          //     int inde = lan.indexOf(data);
                          //     currentLan = data;
                          //     switch (inde) {
                          //       case 0:
                          //         Get.updateLocale(Locale('en', 'US'));
                          //         break;
                          //       case 1:
                          //         Get.updateLocale(Locale('zh', 'CN'));
                          //         break;
                          //     }
                          //     // currentWalletIndex = walletIndex[inde];
                          //     // walletTypeName = data;
                          //     // setState(() {});
                          //     // debugPrint('当前的钱包index = $currentWalletIndex');
                          //   },
                          // )
                          );
                      // Get.dialog(DialogWidget(
                      //     padding: EdgeInsets.zero,
                      //     width: 600,
                      //     height: 400,
                      //     child:
                      //     SelectChainDialog(
                      //       chains: lan,
                      //       callback: (String data) {
                      //         int inde = lan.indexOf(data);
                      //         currentLan = data;
                      //         switch (inde) {
                      //           case 0:
                      //             Get.updateLocale(Locale('en', 'US'));
                      //             break;
                      //           case 1:
                      //             Get.updateLocale(Locale('zh', 'CN'));
                      //             break;
                      //         }
                      //         // currentWalletIndex = walletIndex[inde];
                      //         // walletTypeName = data;
                      //         // setState(() {});
                      //         // debugPrint('当前的钱包index = $currentWalletIndex');
                      //       },
                      //     )
                      // )
                      // );
                    },
                    child: Container(
                      key: userPopKey,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          border: Border.Border.all(width: 1, color: Color(0xffEAEAEA))),
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
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff6B7280)),
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
                color: Color(0xffEAEAEA),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'DerivationInputs'.tr,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              InputRowWidget(
                title: 'VaultIndex'.tr,
                controller: metaController,
                hint: 'input1'.tr,
                showParse: false,
                formatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                showError: showError1,
                errorMsg: 'EnterAmount'.tr,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              InputRowSelectWidget(
                title: 'Chain'.tr,
                hint: chooseChainName,
                callback: () {
                  Get.dialog(DialogWidget(
                      padding: EdgeInsets.zero,
                      width: 600,
                      height: 400,
                      child: SelectCoinDialog(
                        beans: coins,
                        callback: (List<SponsorBean> data) {
                          ///当前选中的所有链
                          chain = '';
                          chainId = '';
                          if (data.isNotEmpty) {
                            showError2 = false;
                            for (var i in data) {
                              chain = chain + i.userName + ',';
                              chainId = chainId + i.id + ',';
                            }
                          }
                          chain = chain.substring(0, chain.length - 1);
                          chainId = chainId.substring(0, chainId.length - 1);
                          chooseChainName = chain;
                          debugPrint('当前选中的所有chain：$chain');
                          debugPrint('当前选中的所有chainId：$chainId');
                          setState(() {});
                        },
                      )));
                },
                showError: showError2,
                errorMsg: 'EnterNet'.tr,
              ),
              SizedBox(
                height: 30,
              ),
              if (!manualInput)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        'ImportFile'.tr,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropTarget(
                          child: _list.isEmpty
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 130),
                                  decoration: BoxDecoration(
                                      border: Border.Border.all(
                                        width: 1,
                                        color: Color(0xffE5E7Eb),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F3FE)),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          AssetsConstant.fileUpload,
                                          width: 44,
                                          height: 44,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'DropFile'.tr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff1F2937),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'MaximumSize'.tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 130),
                                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      decoration: BoxDecoration(
                                          border: Border.Border.all(
                                            width: 1,
                                            color: Color(0xffE5E7EB),
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color(0xffF8FAFC)),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              AssetsConstant.fileUploaded,
                                              width: 44,
                                              height: 44,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'FileUploaded'.tr,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xffD1D5D8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                          onTap: () {
                                            _list.clear();
                                            setState(() {});
                                          },
                                          child: Image.asset(
                                            AssetsConstant.delete,
                                            width: 20,
                                            height: 20,
                                          )),
                                    ),
                                  ],
                                ),
                          onDragDone: (detail) async {
                            setState(() {
                              _list.addAll(detail.files);
                              if (_list.isNotEmpty) {
                                showError3 = false;
                              }
                              debugPrint('当前的路径：${_list[0].path}');
                            });
                          },
                        ),
                        if (showError3)
                          Text(
                            'PleaseImport'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffE32349),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ],
                    )
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      'MnemonicWord'.tr,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller1,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '1',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller2,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '2',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller3,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '3',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller4,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '4',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller5,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '5',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              controller: controller6,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '6',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller7,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '7',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller8,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '8',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller9,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '9',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller10,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '10',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller11,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '11',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller12,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '12',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller13,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '13',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller14,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '14',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller15,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '15',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller16,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '16',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller17,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '17',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller18,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '18',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller19,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '19',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller20,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '20',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller21,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '21',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller22,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '22',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller23,
                              // inputFormatters: [
                              //   WhitelistingRe(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '23',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 48,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.Border.all(width: 1, color: Color(0xffE5E7Eb)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controller24,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter(RegExp("[a-z]")),
                              // ],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.deepPurple),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '24',
                                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showError4)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'MnemonicFailed'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffE32349),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              InputRowWidget(
                title: 'EciesKEY'.tr,
                controller: eciesController,
                hint: 'Input'.tr,
                showParse: true,
                showError: showError5,
                errorMsg: 'InputEcies'.tr,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      'RSAKey'.tr,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropTarget(
                        child: _rsaList.isEmpty
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 48, horizontal: 130),
                                decoration: BoxDecoration(
                                    border: Border.Border.all(
                                      width: 1,
                                      color: Color(0xffE5E7Eb),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffF8F3FE)),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        AssetsConstant.fileUpload,
                                        width: 44,
                                        height: 44,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'DropFile'.tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff1F2937),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'MaximumSize'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 130),
                                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.Border.all(
                                          width: 1,
                                          color: Color(0xffE5E7EB),
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xffF8FAFC)),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            AssetsConstant.fileUploaded,
                                            width: 44,
                                            height: 44,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'FileUploaded'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffD1D5D8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                        onTap: () {
                                          _rsaList.clear();
                                          setState(() {});
                                        },
                                        child: Image.asset(
                                          AssetsConstant.delete,
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                ],
                              ),
                        onDragDone: (detail) async {
                          setState(() {
                            _rsaList.addAll(detail.files);
                            if (_rsaList.isNotEmpty) {
                              showError6 = false;
                            }
                            debugPrint('当前的路径：${_rsaList[0].path}');
                          });
                        },
                      ),
                      if (showError6)
                        Text(
                          'PleaseImport'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffE32349),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 162,
                  ),
                  Flexible(
                    child:
                        // CommonButtonWidget(callback: () async {
                        //   var excel = Excel.createExcel();
                        //   var sheet = excel['Sheet1'];
                        //   sheet.appendRow([TextCellValue('Chain Name'),TextCellValue('Address'),TextCellValue('Child Extended Private Key'),]);
                        //
                        //   if(resultList.isNotEmpty){
                        //     resultList.forEach((element) {
                        //       sheet.appendRow([TextCellValue(element.CoinType),TextCellValue(element.Address),TextCellValue(element.PrivKey),]);
                        //     });
                        //   }else{
                        //     sheet.appendRow([TextCellValue('element.CoinType'),TextCellValue('element.Address'),TextCellValue('element.PrivKey'),]);
                        //   }
                        //
                        //   // Saving the file
                        //   String? outputFile1 = await FilePicker.platform.saveFile(
                        //     dialogTitle: 'Please select an output file:',
                        //     fileName: 'output-file1.xlsx',
                        //   );
                        //
                        //   if (outputFile1 == null) {
                        //     debugPrint('当前的outputFile----$outputFile1');
                        //     // User canceled the picker
                        //   }else{
                        //     debugPrint('当前的outputFile----$outputFile1');
                        //     List<int>? fileBytes = excel.save();
                        //     //print('saving executed in ${stopwatch.elapsed}');
                        //     if (fileBytes != null) {
                        //       File(path.join(outputFile1))
                        //         ..createSync(recursive: true)
                        //         ..writeAsBytesSync(fileBytes);
                        //     }
                        //   }
                        //
                        //   //stopwatch.reset();
                        //
                        // })),
                        CommonButtonWidget(
                      callback: () async {
                        ///先check 参数是不是空的
                        if (metaController.text.isEmpty ||
                            _list.isEmpty ||
                            chainId.isEmpty ||
                            eciesController.text.isEmpty ||
                            _rsaList.isEmpty ||
                            controller1.text.isEmpty ||
                            controller2.text.isEmpty ||
                            controller3.text.isEmpty ||
                            controller4.text.isEmpty ||
                            controller5.text.isEmpty ||
                            controller6.text.isEmpty ||
                            controller7.text.isEmpty ||
                            controller8.text.isEmpty ||
                            controller9.text.isEmpty ||
                            controller10.text.isEmpty ||
                            controller11.text.isEmpty ||
                            controller12.text.isEmpty ||
                            controller13.text.isEmpty ||
                            controller14.text.isEmpty ||
                            controller15.text.isEmpty ||
                            controller16.text.isEmpty ||
                            controller17.text.isEmpty ||
                            controller18.text.isEmpty ||
                            controller19.text.isEmpty ||
                            controller20.text.isEmpty ||
                            controller21.text.isEmpty ||
                            controller22.text.isEmpty ||
                            controller23.text.isEmpty ||
                            controller24.text.isEmpty) {
                          if (metaController.text.isEmpty || int.tryParse(metaController.text.toString())! > 9999) {
                            showError1 = true;
                          }
                          if (_list.isEmpty) {
                            showError3 = true;
                          }
                          if (chainId.isEmpty) {
                            showError2 = true;
                          }
                          if (eciesController.text.isEmpty) {
                            showError5 = true;
                          }
                          if (_rsaList.isEmpty) {
                            showError6 = true;
                          }
                          if (controller1.text.isEmpty ||
                              controller2.text.isEmpty ||
                              controller3.text.isEmpty ||
                              controller4.text.isEmpty ||
                              controller5.text.isEmpty ||
                              controller6.text.isEmpty ||
                              controller7.text.isEmpty ||
                              controller8.text.isEmpty ||
                              controller9.text.isEmpty ||
                              controller10.text.isEmpty ||
                              controller11.text.isEmpty ||
                              controller12.text.isEmpty ||
                              controller13.text.isEmpty ||
                              controller14.text.isEmpty ||
                              controller15.text.isEmpty ||
                              controller16.text.isEmpty ||
                              controller17.text.isEmpty ||
                              controller18.text.isEmpty ||
                              controller19.text.isEmpty ||
                              controller20.text.isEmpty ||
                              controller21.text.isEmpty ||
                              controller22.text.isEmpty ||
                              controller23.text.isEmpty ||
                              controller24.text.isEmpty) {
                            showError4 = true;
                          }
                          setState(() {});
                        } else {
                          showError1 = false;
                          showError2 = false;
                          showError3 = false;
                          showError4 = false;
                          showError5 = false;
                          showError6 = false;
                          setState(() {});
                          helpWord = controller1.text.trim() +
                              " " +
                              controller2.text.trim() +
                              " " +
                              controller3.text.trim() +
                              " " +
                              controller4.text.trim() +
                              " " +
                              controller5.text.trim() +
                              " " +
                              controller6.text.trim() +
                              " " +
                              controller7.text.trim() +
                              " " +
                              controller8.text.trim() +
                              " " +
                              controller9.text.trim() +
                              " " +
                              controller10.text.trim() +
                              " " +
                              controller11.text.trim() +
                              " " +
                              controller12.text.trim() +
                              " " +
                              controller13.text.trim() +
                              " " +
                              controller14.text.trim() +
                              " " +
                              controller15.text.trim() +
                              " " +
                              controller16.text.trim() +
                              " " +
                              controller17.text.trim() +
                              " " +
                              controller18.text.trim() +
                              " " +
                              controller19.text.trim() +
                              " " +
                              controller20.text.trim() +
                              " " +
                              controller21.text.trim() +
                              " " +
                              controller22.text.trim() +
                              " " +
                              controller23.text.trim() +
                              " " +
                              controller24.text.trim();
                          // debugPrint('当前的第一个参数：${metaController.text.toString()}');
                          debugPrint('当前的第2个参数：${chainId}');
                          debugPrint('当前的第3个参数：${_list[0].path}');
                          debugPrint('当前的第4个参数：${helpWord}');
                          debugPrint('当前的第5个参数：${eciesController.text.toString()}');
                          debugPrint('当前的第6个参数：${_rsaList[0].path}');
                          String rsaStart = '-----BEGIN PRIVATE KEY-----';
                          String rsaEnd = '-----END PRIVATE KEY-----';
                          String rsaAdd = '-----BEGIN PRIVATE KEY-----\n';
                          String rsaAddEnd = '\n-----END PRIVATE KEY-----';
                          String rsa = ricController.text.toString();
                          String temp = rsa.replaceAll(rsaStart, '').replaceAll(rsaEnd, '');
                          String fStr = rsaAdd + temp;
                          String fstr2 = fStr + rsaAddEnd;
                          try {
                            final res =
                                await NativeLib().printHelloWrapper(_list[0].path, helpWord, eciesController.text, _rsaList[0].path, metaController.text.toString(), chainId);
                            if (res != null) {
                              EasyLoading.showToast(res.data.toDartString(), duration: const Duration(seconds: 5));
                              debugPrint('是否ok：${res.ok}');
                              debugPrint('是否ok：${res.data.toDartString()}');
                              if (res.ok == 1) {
                                EasyLoading.showToast('RestoredSuccess'.tr);
                                debugPrint('${res.data.toDartString()}');
                                List resJson = json.decode(res.data.toDartString());
                                List<ItemBean> items = resJson.map((e) => ItemBean.fromJson(e)).toList();
                                resultList.clear();
                                resultList.addAll(items);
                                setState(() {});
                                // final map = jsonDecode(res.data.toDartString());
                              } else {
                                EasyLoading.showToast(res.errMsg.toDartString());
                              }
                            } else {
                              EasyLoading.showToast('RestoredFailed'.tr);
                            }
                          } catch (e) {
                            EasyLoading.showToast("erro:$e");
                          }
                        }
                      },
                      string: 'Generate'.tr,
                    ),
                  )
                ],
              ),
              if (resultList.isNotEmpty)
                Container(
                  height: 310,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Color(0xffF8FAFC),
                  child: ListView.builder(
                      itemCount: resultList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (c, i) => privateKeyWidget(
                            bean: resultList[i],
                          )),
                ),
              if (resultList.isNotEmpty)
                SizedBox(
                  height: 30,
                ),
              if (resultList.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 162,
                    ),
                    Flexible(
                        child: CommonButtonWidget(
                      callback: () async {
                        if (resultList.isEmpty) {
                          EasyLoading.showToast('当前无可导出文件');
                        } else {
                          var excel = Excel.createExcel();
                          var sheet = excel['Sheet1'];
                          sheet.appendRow([
                            TextCellValue('Chain Name'),
                            TextCellValue('Address'),
                            TextCellValue('Child Extended Private Key'),
                          ]);

                          if (resultList.isNotEmpty) {
                            resultList.forEach((element) {
                              sheet.appendRow([
                                TextCellValue(element.CoinType),
                                TextCellValue(element.Address),
                                TextCellValue(element.PrivKey),
                              ]);
                            });
                          } else {
                            sheet.appendRow([
                              TextCellValue('element.CoinType'),
                              TextCellValue('element.Address'),
                              TextCellValue('element.PrivKey'),
                            ]);
                          }

                          // Saving the file
                          String? outputFile1 = await FilePicker.platform.saveFile(
                            dialogTitle: 'Please select an output file:',
                            fileName: 'PrivateKeyFile.xlsx',
                          );

                          if (outputFile1 == null) {
                            debugPrint('当前的outputFile----$outputFile1');
                            // User canceled the picker
                          } else {
                            debugPrint('当前的outputFile----$outputFile1');
                            List<int>? fileBytes = excel.save();
                            //print('saving executed in ${stopwatch.elapsed}');
                            if (fileBytes != null) {
                              File(path.join(outputFile1))
                                ..createSync(recursive: true)
                                ..writeAsBytesSync(fileBytes);
                            }
                          }
                        }
                        //stopwatch.reset();
                      },
                      string: 'Export'.tr,
                    )),
                  ],
                ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

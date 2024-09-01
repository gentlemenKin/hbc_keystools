import 'dart:async';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';
import 'package:hbc_keystools/native.dart';
import 'package:hbc_keystools/widget/common_btn.dart';
import 'package:hbc_keystools/widget/dialog_widget.dart';
import 'package:hbc_keystools/widget/ensure_dialog.dart';
import 'package:hbc_keystools/widget/fail_dialog.dart';
import 'package:hbc_keystools/widget/input_info_row_widget.dart';
import 'package:hbc_keystools/widget/input_row_select_widget.dart';
import 'package:hbc_keystools/widget/input_row_widget.dart';
import 'package:hbc_keystools/widget/select_coin_dialog.dart';
import 'package:hbc_keystools/widget/select_single_dialog.dart';
import 'package:hex/hex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manager/lan_manager.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String chooseChainName = 'Solana';

  final List<SponsorBean> chains = [
    SponsorBean(true, 'Solana', '1'),
    SponsorBean(false, 'Aptos', '2'),
    SponsorBean(false, 'Polkadot', '3'),
  ];
  final List<String> node = ['https://api.mainnet-beta.solana.com', 'https://fullnode.mainnet.aptoslabs.com', 'https://polkadot-public-sidecar.parity-chains.parity.io'];
  final List<String> scan = ['https://solscan.io', 'https://aptoscan.com', 'https://polkadot.subscan.io'];
  final List<String> coins = ['Sol', 'Apt', 'Dot'];

  List<SponsorBean> sloCoins = [
    SponsorBean(true, 'Sol', '1'),
    SponsorBean(false, 'USDT_Solana', '2'),
    SponsorBean(false, 'CustomCoin'.tr, '3'),
  ];
  List<SponsorBean> aptCoins = [
    SponsorBean(true, 'APT', '2'),
    SponsorBean(false, 'CustomCoin'.tr, '3'),
  ];
  List<SponsorBean> dotCoins = [
    SponsorBean(true, 'DOT', '2'),
    SponsorBean(false, 'CustomCoin'.tr, '3'),
  ];

  List<SponsorBean> defaultCoins = [];
  String defaultCoin = 'Sol';
  String defaultNode = 'https://api.mainnet-beta.solana.com';
  String defaultScan = 'https://solscan.io';

  TextEditingController _transferAmountController = TextEditingController();
  TextEditingController _transferFromController = TextEditingController();
  TextEditingController _transferToController = TextEditingController();
  TextEditingController _transferRpcController = TextEditingController();
  TextEditingController _transferAddressController = TextEditingController();
  bool showError4 = false;
  bool showError5 = false;
  bool showError6 = false;
  bool showError7 = false;
  bool showError8 = false;
  String path = '';
  GlobalKey amountKey = GlobalKey();
  GlobalKey rpcKey = GlobalKey();
  late StreamSubscription<String> lanStreamSubscription;
  bool customize = false;

  // String currentLan = 'en';
  @override
  void dispose() {
    _transferAmountController.dispose();
    _transferFromController.dispose();
    _transferToController.dispose();
    _transferRpcController.dispose();
    _transferAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // lanStreamSubscription = LanStream().stream.listen((event) {
    //   debugPrint('当前的语言：$event');
    //   currentLan = event;
    // });
    defaultCoins = sloCoins;
    _transferRpcController.text = defaultNode;
    _transferAmountController.addListener(() {
      if (_transferAmountController.text.trim().isEmpty) {
        showError5 = true;
      } else {
        showError5 = false;
      }
      setState(() {});
    });
    _transferFromController.addListener(() {
      if (_transferFromController.text.trim().isEmpty) {
        showError6 = true;
      } else {
        try {
          final res = HEX.decode(_transferFromController.text.toString());
          debugPrint('keyRight:$res');
          if (res.isNotEmpty) {
            showError6 = true;
          }
        } catch (e) {
          showError6 = false;
        }
      }
      setState(() {});
    });
    _transferToController.addListener(() {
      if (_transferToController.text.trim().isEmpty) {
        showError7 = true;
      } else {
        showError7 = false;
      }
      setState(() {});
    });
    _transferRpcController.addListener(() {
      if (_transferRpcController.text.trim().isEmpty) {
        showError8 = true;
      } else {
        showError8 = false;
      }
      setState(() {});
    });
    _transferAddressController.addListener(() {
      if (customize) {
        if (_transferAddressController.text.trim().isEmpty) {
          showError4 = true;
        } else {
          showError4 = false;
        }
      }
      setState(() {});
    });
  }

  Future<bool> _isConnected() async {
    var connectResult = await (Connectivity().checkConnectivity());
    debugPrint('当前的网络情况:${connectResult.toString()}');
    return connectResult.contains(ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          InputRowSelectWidget(
            title: 'Chain'.tr,
            hint: 'ChooseChain'.tr,
            content: chooseChainName,
            callback: () {
              Get.dialog(DialogWidget(
                  padding: EdgeInsets.zero,
                  width: 400,
                  height: 200,
                  child: SelectSingleDialog(
                    chains: chains,
                    callback: (int data) {
                      debugPrint('当前的data：$data');
                      if (chooseChainName != chains[data].userName) {
                        sloCoins = [
                          SponsorBean(true, 'Sol', '1'),
                          SponsorBean(false, 'USDT_Solana', '2'),
                          SponsorBean(false, 'CustomCoin'.tr, '3'),
                        ];
                        dotCoins = [
                          SponsorBean(true, 'DOT', '2'),
                          SponsorBean(false, 'CustomCoin'.tr, '3'),
                        ];
                        aptCoins = [
                          SponsorBean(true, 'APT', '2'),
                          SponsorBean(false, 'CustomCoin'.tr, '3'),
                        ];
                      }
                      chooseChainName = chains[data].userName;
                      defaultNode = node[data];
                      defaultScan = scan[data];
                      _transferRpcController.text = defaultNode;
                      switch (data) {
                        case 0: //sol
                          defaultCoins = sloCoins;
                          break;
                        case 1: //apt
                          defaultCoins = aptCoins;
                          break;
                        case 2: //dot
                          defaultCoins = dotCoins;
                          break;
                      }
                      defaultCoin = defaultCoins[0].userName;
                      chains.forEach((element) {
                        element.isSlected = false;
                      });
                      chains[data].isSlected = true;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  )));
            },
            showError: false,
            errorMsg: 'EnterNet'.tr,
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
                  'CheckBalance'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: ColorConstant.color_0x000000),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(defaultScan);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Text(
                    'BlockExplorer'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorConstant.themeColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          InputRowSelectWidget(
            title: 'TransferCurrency'.tr,
            hint: 'ChooseChain'.tr,
            content: defaultCoin,
            callback: () {
              Get.dialog(DialogWidget(
                  padding: EdgeInsets.zero,
                  width: 400,
                  height: 200,
                  child: SelectSingleDialog(
                    chains: defaultCoins,
                    callback: (int data) {
                      debugPrint('当前的data：$data');
                      //如果是最后一项要展示自定义。
                      if (data + 1 == defaultCoins.length) {
                        customize = true;
                      } else {
                        customize = false;
                      }
                      defaultCoin = defaultCoins[data].userName;
                      defaultCoins.forEach((element) {
                        element.isSlected = false;
                      });
                      defaultCoins[data].isSlected = true;

                      if (mounted) {
                        setState(() {});
                      }
                    },
                  )));
            },
            showError: false,
            errorMsg: 'EnterNet'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          if (customize)
            InputRowWidget(
              title: '',
              controller: _transferAddressController,
              hint: 'HintContract'.tr,
              showParse: true,
              showError: showError4,
              errorMsg: 'RightContract'.tr,
            ),
          if (customize)
            SizedBox(
              height: 30,
            ),
          InputInfoRowWidget(
            title: 'TransferAmount'.tr,
            controller: _transferAmountController,
            formatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            hint: 'HintAmount'.tr,
            showParse: true,
            showError: showError5,
            errorMsg: 'RightAmount'.tr,
            globalKey: amountKey,
            content: 'TransferWaring2'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          InputRowWidget(
            title: 'FromKey'.tr,
            controller: _transferFromController,
            hint: 'HintKey'.tr,
            showParse: true,
            showError: showError6,
            errorMsg: 'RightKey'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          InputRowWidget(
            title: 'ToAddress'.tr,
            controller: _transferToController,
            hint: 'HintAddress'.tr,
            showParse: true,
            showError: showError7,
            errorMsg: 'RightAddress'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          InputInfoRowWidget(
            title: 'RPC',
            controller: _transferRpcController,
            hint: 'HintRPC'.tr,
            showParse: true,
            showError: showError8,
            errorMsg: 'HintRPC'.tr,
            globalKey: rpcKey,
            content: 'CustomRPC'.tr,
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 162),
            child: Row(
              children: [
                Flexible(
                    child: CommonButtonWidget(
                  callback: () async {
                    bool keyRight = false;
                    try {
                      final res = HEX.decode(_transferFromController.text.toString());
                      debugPrint('keyRight:$res');
                      if (res.isNotEmpty) {
                        keyRight = true;
                      }
                    } catch (e) {
                      keyRight = false;
                    }
                    debugPrint('keyRight:$keyRight');
                    if (_transferRpcController.text.toString().isNotEmpty &&
                        _transferFromController.text.toString().isNotEmpty &&
                        _transferToController.text.toString().isNotEmpty &&
                        _transferAmountController.text.toString().isNotEmpty &&
                        keyRight) {
                      final res = await _isConnected();
                      if (!res) {
                        String coinAddress = '';
                        if (customize) {
                          coinAddress = _transferAddressController.text.toString();
                        } else {
                          if (defaultCoin == 'USDT_Solana') {
                            coinAddress = 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB';
                          }
                        }

                        debugPrint('第一个参数：${chooseChainName}');
                        debugPrint('第2个参数：${_transferRpcController.text.toString()}');
                        debugPrint('第3个参数：${_transferFromController.text.toString()}');
                        debugPrint('第4个参数：${_transferToController.text.toString()}');
                        debugPrint('第5个参数：${_transferAmountController.text.toString()}');
                        debugPrint('第6个参数：${coinAddress}');
                        debugPrint('第7个参数：${LanStream().currentLan}');

                        ///判断输入是否符合标准
                        EasyLoading.showInfo(
                          'loading'.tr,
                        );
                        final res = await compute(NativeLib().GoTransfer, {
                          'name': chooseChainName,
                          'str': _transferRpcController.text.trim().toString(),
                          'str1': _transferFromController.text.trim().toString(),
                          'str2': _transferToController.text.trim().toString(),
                          'str3': _transferAmountController.text.trim().toString(),
                          'string4': coinAddress,
                          'str5': LanStream().currentLan,
                        });
                        // final res = await NativeLib().GoTransfer(chooseChainName, _transferRpcController.text.toString(), _transferFromController.text.toString(),
                        //     _transferToController.text.toString(), _transferAmountController.text.toString(), coinAddress, LanStream().currentLan);
                        debugPrint('当前的结果：res:$res');
                        if (res != null) {
                          EasyLoading.dismiss();
                          if (res.ok == 1) {
                            debugPrint('${res.data.toDartString()}');
                            EasyLoading.dismiss();
                            Get.dialog(DialogWidget(
                              child: EnsureDialog(
                                myUrl: defaultScan,
                              ),
                              width: 440,
                              height: 300,
                            ));
                          } else {
                            Get.dialog(DialogWidget(
                              child: FailDialog(
                                msg: res.errMsg.toDartString(),
                              ),
                              width: 440,
                              height: 300,
                            ));
                            // EasyLoading.showToast(res.errMsg.toDartString());
                          }
                        } else {
                          EasyLoading.dismiss();
                        }
                      } else {
                        EasyLoading.showToast('noNet'.tr);
                      }
                    } else {
                      if (_transferRpcController.text.toString().isEmpty) {
                        showError8 = true;
                      }
                      if (_transferFromController.text.toString().isEmpty || !keyRight) {
                        showError6 = true;
                      } else {
                        showError6 = false;
                      }
                      if (_transferToController.text.toString().isEmpty) {
                        showError7 = true;
                      }
                      if (_transferAmountController.text.toString().isEmpty) {
                        showError5 = true;
                      }
                      if (_transferAddressController.text.toString().isEmpty) {
                        showError4 = true;
                      }
                      setState(() {});
                    }
                  },
                  string: 'EnsureTransfer'.tr,
                )),
                SizedBox(
                  width: 24,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'TransferDeclaration'.tr,
            style: TextStyle(
              color: ColorConstant.color_0x000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Declaration1'.tr,
            style: TextStyle(
              color: ColorConstant.color_0x000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Declaration2'.tr,
            style: TextStyle(
              color: ColorConstant.color_0x000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

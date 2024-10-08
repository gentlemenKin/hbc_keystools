import 'dart:async';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
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
    SponsorBean(false, '自定义', '3'),
  ];
  List<SponsorBean> aptCoins = [
    SponsorBean(true, 'APT', '2'),
    SponsorBean(false, '自定义', '3'),
  ];
  List<SponsorBean> dotCoins = [
    SponsorBean(true, 'DOT', '2'),
    SponsorBean(false, '自定义', '3'),
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
                          SponsorBean(false, '自定义', '3'),
                        ];
                        dotCoins = [
                          SponsorBean(true, 'DOT', '2'),
                          SponsorBean(false, '自定义', '3'),
                        ];
                        aptCoins = [
                          SponsorBean(true, 'APT', '2'),
                          SponsorBean(false, '自定义', '3'),
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
                  '查询余额',
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
                    '从CipherBC应用复制地址后前往区块浏览器查询》',
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
            title: '转出币种',
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
              hint: 'Input'.tr,
              showParse: true,
              showError: showError4,
              errorMsg: 'InputEcies'.tr,
            ),
          if (customize)
            SizedBox(
              height: 30,
            ),
          InputInfoRowWidget(
            title: '转出数量',
            controller: _transferAmountController,
            formatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            hint: 'Input'.tr,
            showParse: true,
            showError: showError5,
            errorMsg: 'InputEcies'.tr,
            globalKey: amountKey,
            content: '转出时请检查下余额，确保转出代币和GAS充足，避免因代币或GAS不足导致的失败',
          ),
          SizedBox(
            height: 30,
          ),
          InputRowWidget(
            title: 'From(私钥)',
            controller: _transferFromController,
            hint: 'Input'.tr,
            showParse: true,
            showError: showError6,
            errorMsg: 'InputEcies'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          InputRowWidget(
            title: 'To(地址)',
            controller: _transferToController,
            hint: 'Input'.tr,
            showParse: true,
            showError: showError7,
            errorMsg: 'InputEcies'.tr,
          ),
          SizedBox(
            height: 30,
          ),
          InputInfoRowWidget(
            title: 'RPC',
            controller: _transferRpcController,
            hint: 'Input'.tr,
            showParse: true,
            showError: showError8,
            errorMsg: 'InputEcies'.tr,
            globalKey: rpcKey,
            content: '可自定义RPC节点',
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
                        EasyLoading.showInfo('loading'.tr, duration: const Duration(milliseconds: 2000));
                        Future.delayed(const Duration(milliseconds: 500)).then((value) async {
                          final res = await NativeLib().GoTransfer(chooseChainName, _transferRpcController.text.toString(), _transferFromController.text.toString(),
                              _transferToController.text.toString(), _transferAmountController.text.toString(), coinAddress, LanStream().currentLan);
                          debugPrint('当前的结果：res:$res');
                          if (res != null) {
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
                              EasyLoading.showToast(res.errMsg.toDartString());
                            }
                          }
                        });
                      } else {
                        EasyLoading.showToast('当前未链接网络');
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
                  string: '确认转出',
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
            '注意，转出说明：',
            style: TextStyle(
              color: ColorConstant.color_0x000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '1.确认转出，表示您同意客户端联网进行链上广播交易的联网操作.',
            style: TextStyle(
              color: ColorConstant.color_0x000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '2.离线签名，客户端将生成一段已签名的消息码，您需复制消息码并委托第三方进行上链广播交易.',
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

  Future<void> isolateSign(List<dynamic> args) async {
    SendPort resultPort = args[0];
    String name = args[1];
    String str = args[2];
    String str1 = args[3];
    String str2 = args[4];
    String str3 = args[5];
    String str4 = args[6];
    String str5 = args[7];
    final res = NativeLib().GoSign(name, str, str1, str2, str3, str4, str5);
    Isolate.exit(resultPort, res);
  }

  Future<void> readAndParseJson(List<dynamic> args) async {
    SendPort resultPort = args[0];
    String fileLink = args[1];

    print('获取下载链接: $fileLink');

    String fileContent = '文件内容';
    await Future.delayed(const Duration(seconds: 2));
    Isolate.exit(resultPort, fileContent);
  }

  Future<void> _isolateMain(RootIsolateToken rootIsolateToken) async {
    // Register the background isolate with the root isolate.
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // You can now use the shared_preferences plugin.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print(sharedPreferences.getBool('isDebug'));
  }
}

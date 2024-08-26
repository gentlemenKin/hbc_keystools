
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/local/color_constant.dart';

import 'package:hbc_keystools/translation_service.dart';

import 'package:hbc_keystools/window_watcher.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'home_page.dart';
import 'local/constant.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..dismissOnTap = false;
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
       WindowOptions(
        // size: Platform.isMacOS?Size(1280, 800):Size(800, 600),
         size: Size(1280, 800),
        minimumSize: Size(800, 600),
        center: true,
        title: 'KeyRecovery',
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
    return WindowWatcher(
      child: GetMaterialApp(
        title: 'KeyRecovery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorConstant.themeColor),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        locale: Locale('en', 'US'),
        translations: TranslationService(),
        fallbackLocale: TranslationService.fallbackLocale,
        home: const HomePage(),
      ),
    );
  }
}



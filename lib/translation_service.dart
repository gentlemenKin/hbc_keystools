import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbc_keystools/lan/en.dart';
import 'package:hbc_keystools/lan/zh.dart';

class TranslationService extends Translations {
  // static Locale? get locale => Get.deviceLocale;
  // static Locale? get locale => const Locale('zh', "CN");

  // String languageCode = UserStore.to.lang.language;
  // String countryCode = UserStore.to.lang.country;

  // static Locale? get locale =>
  //     Locale(UserStore.to.lang.language, UserStore.to.lang.country);

  static const fallbackLocale = Locale('en', 'US');
  // static const fallbackLocale = Locale('zh', 'CN');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'zh_CN': zh_CN,
  };
}

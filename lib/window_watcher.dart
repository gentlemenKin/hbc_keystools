import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class WindowWatcher extends StatefulWidget {
  const WindowWatcher({super.key,required this.child});
  final Widget child;
  @override
  State<WindowWatcher> createState() => _WindowWatcherState();
}

class _WindowWatcherState extends State<WindowWatcher> with TrayListener,WindowListener{

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);

  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  @override
  void onWindowMove() {
    print('move----');
    super.onWindowMove();
  }
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    // TODO: implement onTrayMenuItemClick
    super.onTrayMenuItemClick(menuItem);
    switch(menuItem.key){
      case 'open':
        windowManager.show();
        break;
      case 'hide':
        windowManager.hide();
        break;
      case 'quit':
        exit(0);
        break;
      default:
        break;
    }
  }
}

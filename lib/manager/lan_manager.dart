import 'dart:async';



class LanStream {
  static final LanStream _singleton = LanStream._internal();

  factory LanStream() {
    return _singleton;
  }

  LanStream._internal();

  final _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void addData(String lan) {
    _controller.add(lan);
    currentLan = lan;
  }
  String currentLan = 'en';
}

import 'dart:async';
import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform
import 'package:ffi/ffi.dart'; // For using Utf8 from ffi
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;

// Define the GoString struct
final class GoString extends Struct {
  external Pointer<Utf8> p;
  @Int64()
  external int n;
}

final class RSResult extends Struct {
  external Pointer<Utf8> errMsg;

  external Pointer<Utf8> data;

  @ffi.Int()
  external int ok;
}

typedef GetRSResultC = RSResult Function(GoString str);

typedef GetRSResultDart = RSResult Function(GoString str);

// Define the function signature in C
typedef PrintHelloC = GoString Function(
  GoString name,
  GoString str,
  GoString str1,
  GoString str2,
  GoString str3,
  GoString str4,
);
// Define the function signature in Dart
typedef PrintHelloDart = GoString Function(
  GoString name,
  GoString str,
  GoString str1,
  GoString str2,
  GoString str3,
  GoString str4,
);

typedef SumFunc = Int32 Function(Int32 a, Int32 b);
typedef Sum = int Function(int a, int b);

typedef GetKeyC = GoString Function(
);
// Define the function signature in Dart
typedef GetKeyDart = GoString Function(
);


typedef GetRecoveryC = RSResult Function(
  GoString name,
  GoString str,
  GoString str1,
  GoString str2,
  GoString str3,
  GoString str4,
);

typedef GetRecoveryDart = RSResult Function(
  GoString name,
  GoString str,
  GoString str1,
  GoString str2,
  GoString str3,
  GoString str4,
);

class NativeLib {
  // Load the dynamic library
  // var libraryPath = path.join(Directory.current.path, 'recovery_tool.dylib');

  static final DynamicLibrary _dylib = ffi.DynamicLibrary.open(Platform.isMacOS ? 'lib_recovery_tool.dylib' : 'recovery_tool.dll');

  static final GetRSResultDart dartFunction = _dylib.lookupFunction<GetRSResultC, GetRSResultDart>('GetRSResult');

  Future<DynamicLibrary?> getLib() async {
    if (Platform.isMacOS) {
      String cpu = await getCpuArchitecture();
      debugPrint('当前的cpu ----$cpu');
      if (cpu == 'x86') {
        return ffi.DynamicLibrary.open('lib_recovery_tool.dylib');
      } else if (cpu == 'arm64') {
        return ffi.DynamicLibrary.open('lib_recovery_tool_arm64.dylib');
      } else {
        return null;
      }
    } else {

      return ffi.DynamicLibrary.open('recovery_tool.dll');
    }
  }

  Future<GetRecoveryDart?> getFun() async {
    final _dylib = await getLib();

    debugPrint('当前的cpu ----${_dylib.toString()}');
    if (_dylib != null) {
      return _dylib.lookupFunction<GetRecoveryC, GetRecoveryDart>('GoRecovery');
    } else {
      return null;
    }
  }

  Future<GetKeyDart?> getKeyFun()async{
    final _dylib = await getLib();
    debugPrint('当前的cpu ----${_dylib.toString()}');
    if (_dylib != null) {
      return _dylib.lookupFunction<GetKeyC, GetKeyDart>('GetChainList');
    } else {
      return null;
    }
  }


  Future<GoString?> getChainList()async{
    final fun = await getKeyFun();
    GoString? result;
    if (fun != null) {
      result = fun();
    } else {
      result = null;
    }
    return result;
  }


  static RSResult test(String str) {
    final namePtr = str.toNativeUtf8();
    final goString = malloc<GoString>();
    goString.ref
      ..p = namePtr
      ..n = namePtr.length;
    final res = dartFunction(goString.ref);
    return res;
  }

  Future<String> getCpuArchitecture() async {
    try {
      // 执行 `uname -m` 命令以获取 CPU 架构
      ProcessResult result = await Process.run('uname', ['-m']);
      if (result.exitCode == 0) {
        String architecture = result.stdout.trim();
        if (architecture == 'x86_64') {
          return 'x86';
        } else if (architecture == 'arm64') {
          return 'arm64';
        } else {
          return 'unknown';
        }
      } else {
        return 'unknown';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  // Lookup the PrintHello function
  // static final GetRecoveryDart printHello = _dylib.lookupFunction<GetRecoveryC, GetRecoveryDart>('GoRecovery');

  // static final Sum sum = _dylib.lookupFunction<SumFunc, Sum>('SumTest');
  //  static final GetKeyDart printHello =
  //  _dylib.lookupFunction<GetKeyC, GetKeyDart>('GetKey');
  //
  // static int testSum(int a,int b){
  //   return  sum(a,b);
  // }
  //
  // static String GetKey(String name){
  //     final namePtr = name.toNativeUtf8();
  //     final goString = malloc<GoString>();
  //     goString.ref
  //       ..p = namePtr
  //       ..n = name.length;
  //     final res = printHello(goString.ref);
  //       final resultStr = res.p.toDartString();
  //     return resultStr;
  // }
  // Create a Dart wrapper for the PrintHello function
  Future<RSResult?> printHelloWrapper(
    String name,
    String str,
    String str1,
    String str2,
    String str3,
    String string4,
  ) async {
    final namePtr = name.toNativeUtf8();
    final goString = malloc<GoString>();
    goString.ref
      ..p = namePtr
      ..n = name.length;

    final params1 = str.toNativeUtf8();
    final goString1 = malloc<GoString>();
    goString1.ref
      ..p = params1
      ..n = params1.length;

    final params2 = str1.toNativeUtf8();
    final goString2 = malloc<GoString>();
    goString2.ref
      ..p = params2
      ..n = params2.length;

    final params3 = str2.toNativeUtf8();
    final goString3 = malloc<GoString>();
    goString3.ref
      ..p = params3
      ..n = params3.length;

    final params4 = str3.toNativeUtf8();
    final goString4 = malloc<GoString>();
    goString4.ref
      ..p = params4
      ..n = params4.length;

    final params5 = string4.toNativeUtf8();
    final goString5 = malloc<GoString>();
    goString5.ref
      ..p = params5
      ..n = params5.length;

    final fun = await getFun();
    RSResult? result;
    if (fun != null) {
      result = fun!(
        goString.ref,
        goString1.ref,
        goString2.ref,
        goString3.ref,
        goString4.ref,
        goString5.ref,
      );
    } else {
      result = null;
    }

    // final resultStr = result.p.toDartString();

    // Free the allocated memory
    malloc.free(namePtr);
    malloc.free(goString);

    malloc.free(params1);
    malloc.free(goString1);

    malloc.free(params2);
    malloc.free(goString2);

    malloc.free(params3);
    malloc.free(goString3);

    malloc.free(params4);
    malloc.free(goString4);

    malloc.free(params5);
    malloc.free(goString5);
    return result;
  }
}

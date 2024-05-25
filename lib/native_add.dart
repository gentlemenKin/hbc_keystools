import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform
import 'package:ffi/ffi.dart'; // For using Utf8 from ffi
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
  GoString name,
);
// Define the function signature in Dart
typedef GetKeyDart = GoString Function(
  GoString name,
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
  static final DynamicLibrary _dylib = ffi.DynamicLibrary.open(path.join(Directory.current.path, Platform.isMacOS ? 'lib_recovery_tool.dylib' : 'recovery_tool.dll'));

  static final GetRSResultDart dartFunction = _dylib.lookupFunction<GetRSResultC, GetRSResultDart>('GetRSResult');

  static RSResult test(String str) {
    final namePtr = str.toNativeUtf8();
    final goString = malloc<GoString>();
    goString.ref
      ..p = namePtr
      ..n = namePtr.length;
    final res = dartFunction(goString.ref);
    return res;
  }

  // Lookup the PrintHello function
  static final GetRecoveryDart printHello = _dylib.lookupFunction<GetRecoveryC, GetRecoveryDart>('GoRecovery');

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
  static RSResult printHelloWrapper(
    String name,
    String str,
    String str1,
    String str2,
    String str3,
    String string4,
  ) {
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

    final result = printHello(
      goString.ref,
      goString1.ref,
      goString2.ref,
      goString3.ref,
      goString4.ref,
      goString5.ref,
    );
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

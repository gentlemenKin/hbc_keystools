// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int SumTest(
    int a,
    int b,
  ) {
    return _SumTest(
      a,
      b,
    );
  }

  late final _SumTestPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(GoInt, GoInt)>>('SumTest');
  late final _SumTest = _SumTestPtr.asFunction<int Function(int, int)>();

  ffi.Pointer<ffi.Char> GetChainList1() {
    return _GetChainList1();
  }

  late final _GetChainList1Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
          'GetChainList1');
  late final _GetChainList1 =
      _GetChainList1Ptr.asFunction<ffi.Pointer<ffi.Char> Function()>();

  RSResult GetChainList() {
    return _GetChainList();
  }

  late final _GetChainListPtr =
      _lookup<ffi.NativeFunction<RSResult Function()>>('GetChainList');
  late final _GetChainList = _GetChainListPtr.asFunction<RSResult Function()>();

  ffi.Pointer<ffi.Char> MacGetChainList() {
    return _MacGetChainList();
  }

  late final _MacGetChainListPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
          'MacGetChainList');
  late final _MacGetChainList =
      _MacGetChainListPtr.asFunction<ffi.Pointer<ffi.Char> Function()>();
}

final class _GoString_ extends ffi.Opaque {}

final class RSResult extends ffi.Struct {
  external ffi.Pointer<ffi.Char> errMsg;

  external ffi.Pointer<ffi.Char> data;

  @ffi.Int()
  external int ok;
}

final class GoInterface extends ffi.Struct {
  external ffi.Pointer<ffi.Void> t;

  external ffi.Pointer<ffi.Void> v;
}

final class GoSlice extends ffi.Struct {
  external ffi.Pointer<ffi.Void> data;

  @GoInt()
  external int len;

  @GoInt()
  external int cap;
}

typedef GoInt = GoInt64;
typedef GoInt64 = ffi.LongLong;
typedef DartGoInt64 = int;

const int NULL = 0;

const int TRUE = 1;

const int FALSE = 0;

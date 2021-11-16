import 'package:pigeon/pigeon.dart';

// Flutter 调用原生方法
@HostApi()
abstract class Api {
  @async
  String getPlatformVersion();
}

// 原生调用 Flutter 方法
@FlutterApi()
abstract class MyApi {
  @async
  void sessionInValid();
}

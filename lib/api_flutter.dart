import 'package:flutter/foundation.dart';

import 'api_generated.dart';

// 实现 Flutter ApiGenerated 的接口
class FTLApiManager extends MyApi {
  @override
  Future<void> sessionInValid() async {
    if (kDebugMode) {
      print('====Call session invalid====');
    }
  }
}

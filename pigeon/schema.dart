import 'package:pigeon/pigeon.dart';

class Version {
  late String string;
}

@HostApi()
abstract class Api {
  Version getPlatformVersion();
}


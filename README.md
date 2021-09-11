# flutter_pigeon

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# [Flutter] 使用 Pigeon 类型安全地调用原生代码

### 简介

[Pigeon](https://pub.dev/packages/pigeon) 是在 [Flutter 1.20](https://medium.com/flutter/announcing-flutter-1-20-2aaf68c89c75) 发布的，为了解决 Flutter 调用 native 代码过于麻烦和困难，需要在字符串的基础上匹配函数名和参数，通过使用这个包可以实现

- 与 native 类型安全通信
- 通过自动生成减少手写代码量

这篇文章主要是详细描述了如何使用 Pigeon 从 Flutter 端调用一个在 Swift/Kotlin 中实现的简单 `getPlatformVersion` 方法。实例项目可在此处获得。

### 创建 Flutter app

```bash
$ flutter create flutter_pigeon
```

### Pigeon 是做什么的

Java/Objective-C 接口协议是根据 Dart 端定义的参数和返回值信息`自动生成`的。

原生基于这些接口实现，可以与 Flutter 端进行类型安全通信。

类似于使用 TypeScript 创建类型定义文件。

### 安装

```bash
# pubspec.yaml

dev_dependencies:
  pigeon: ^1.0.0
```

### Dart

首先，创建一个定义与原生通信的 dart 文件。在根目录下创建 pigeon/schema.dart 文件

```dart
// schema.dart

import 'package:pigeon/pigeon.dart';

class Version {
  late String string;
}

@HostApi()
abstract class Api {
  Version getPlatformVersion();
}
```

新建脚本文件 `run_pigeon.sh`  

```bash
# run_pigeon.h

$ flutter pub run pigeon \
  --input pigeon/schema.dart \
  --dart_out lib/api_generated.dart  \
  --objc_header_out ios/Runner/Pigeon.h \
  --objc_source_out ios/Runner/Pigeon.m \
  --objc_prefix FLT \
  --java_out android/app/src/main/java/io/flutter/plugins/Pigeon.java \
  --java_package "io.flutter.plugins"
```

运行脚本自动生成对应的接口文件

```bash
$ ./run_pigeon.sh
```

在需要调用原生方法函数的地方导入并使用 Pigeon 生成的 dart 文件

### Kotlin

API接口写在Pigeon生成的Java文件中，所以创建一个实现它的类，并传递给setup方法。

```kotlin
// MainActivity.kt
package com.example.flutter_pigeon

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.Pigeon

class MainActivity: FlutterActivity() {
    private class MyApi: Pigeon.Api {
        override fun getPlatformVersion(): Pigeon.Version {
            var result = Pigeon.Version()
            result.string = "Android ${android.os.Build.VERSION.RELEASE}"
            return result
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 2. setup()
        Pigeon.Api.setup(flutterEngine.dartExecutor.binaryMessenger, MyApi())
    }

}
```

### Swift

在桥接文件 `ios/RunnerRunner-Bridging-Header.h` 添加 import 语句，让 Pigeon 生成的 Objective-C 文件对 Swift 可见

```objectivec
// ios / Runner / Runner-Bridging-Header.h
#import "Pigeon.h"
```

由于 API 协议写在生成的文件中，创建一个实现该协议的类 `MyApi` 

创建 SwiftPigeonService.swift 文件 实现协议方法

```swift
// SwiftPigeonService.swift

import Flutter
import UIKit

public class SwiftPigeonService: NSObject, FLTApi {
    public func getPlatformVersionWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTVersion? {
        let result = FLTVersion.init()
        result.string = "iOS " + UIDevice.current.systemVersion
        return result
    }
}
```

在 AppDelegate 中实例化 API 并将其传递给 setup 方法

```swift
// AppDelegate.swift

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    FLTApiSetup(controller.binaryMessenger, SwiftPigeonService())
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 总结

- Pigeon 自动生成使用 [MethodChannel](https://api.flutter.dev/flutter/services/MethodChannel-class.html) 相关部分内容。（严格来说，Pigeon 使用的是[BasicMessageChannel](https://api.flutter.dev/flutter/services/BasicMessageChannel-class.html)）
- 预定义模式允许与 native 进行类型安全通信
- 生成的代码是 Java/Objective-C，但是由于 Kotlin 可以调用 Java，Swift 可以调用 Objective-C
- 不必了解 Dart 端代码 （只需调用自动生成的 API）
- 不必了解原生代码 （只需实现自动生成的接口）
- 实际已经在 [video_player](https://github.com/flutter/plugins/tree/master/packages/video_player/video_player) 官方插件中使用

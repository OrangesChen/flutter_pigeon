import UIKit
import Flutter
import Dispatch

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var _flutterApi: FLTMyApi?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    FLTApiSetup(controller.binaryMessenger, SwiftPigeonService())
    GeneratedPluginRegistrant.register(with: self)
    _flutterApi = FLTMyApi(binaryMessenger: controller.binaryMessenger)
    // 注意：方法必须在主线程上执行
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        self._flutterApi?.sessionInValid(completion: { (error) in
            print("===Native Call flutter func!===")
        })
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import Flutter
import UIKit

public class SwiftPigeonService: NSObject, FLTApi {
    public func getPlatformVersion(completion: @escaping (String?, FlutterError?) -> Void) {
        let result = "iOS " + UIDevice.current.systemVersion
        completion(result, nil)
    }
}

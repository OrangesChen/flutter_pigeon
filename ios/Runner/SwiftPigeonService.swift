import Flutter
import UIKit

public class SwiftPigeonService: NSObject, FLTApi {
    public func getPlatformVersionWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTVersion? {
        let result = FLTVersion.init()
        result.string = "iOS " + UIDevice.current.systemVersion
        return result
    }
}

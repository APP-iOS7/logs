import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "kr.co.codegrove.platform_channel_demo/battery",
                                              binaryMessenger: controller.binaryMessenger)

    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in

      guard self != nil else { return }

      if call.method == "getBatteryLevel" {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
          //          result(FlutterError(code: "UNAVAILABLE",
          //                              message: "Battery info unavailable",
          //                              details: nil))
          result(Int(33))
        } else {
          result(Int(device.batteryLevel * 100))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    print("========== 4 ===========")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

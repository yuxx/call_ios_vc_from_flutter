import UIKit
import Flutter
import ContactsUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var flutterVC: FlutterViewController {
    self.window.rootViewController as! FlutterViewController
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("\(String(describing: Self.self))::\(#function)@\(#line)")

    let flutterMethodChannel = FlutterMethodChannel(
        name: "dev.yuxx/call_ios_vc",
        binaryMessenger: flutterVC.binaryMessenger
    )
    flutterMethodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else {
        return
      }
      self.flutterMethodCallHandler(call: call, result: result)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {
  private func flutterMethodCallHandler(call: FlutterMethodCall, result: FlutterResult) -> Void {
    print("\(String(describing: Self.self))::\(#function)@\(#line) channel called."
        + "\ncall.method: \(call.method)")
    guard let nativeCallBackType = NativeCallBackType(rawValue: call.method) else {
      print("\(String(describing: Self.self))::\(#function)@\(#line)")
      return
    }
    nativeCallBackType.nativeProcedure(call, result)
  }
}
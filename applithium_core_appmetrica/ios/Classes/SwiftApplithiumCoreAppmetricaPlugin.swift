import Flutter
import UIKit

public class SwiftApplithiumCoreAppmetricaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "applithium_core_appmetrica", binaryMessenger: registrar.messenger())
    let instance = SwiftApplithiumCoreAppmetricaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

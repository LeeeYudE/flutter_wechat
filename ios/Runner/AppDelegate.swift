import UIKit
import Flutter
import LeanCloud

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    do {
                LCApplication.logLevel = .all
                try LCApplication.default.set(
                    id: "JN2Q4XReVkr7sQYEmma3bT6R-MdYXbMMI",
                    key: "pgktbsL98hKS2hzdi3OeJ8Pe",
                    serverURL: "")
                GeneratedPluginRegistrant.register(with: self)
                return super.application(application, didFinishLaunchingWithOptions: launchOptions)
            } catch {
                fatalError("\(error)")
            }
        }
}

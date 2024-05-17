import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
      override func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
          let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
          controller.view.window?.layer.addSublayer(CATextLayer())
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

      override func applicationWillResignActive(_ application: UIApplication) {
          window?.isHidden = true
      }

      override func applicationDidBecomeActive(_ application: UIApplication) {
          window?.isHidden = false
      }

}

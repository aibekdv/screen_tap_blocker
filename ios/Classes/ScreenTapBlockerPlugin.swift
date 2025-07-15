import Flutter
import UIKit

public class ScreenTapBlockerPlugin: NSObject, FlutterPlugin {
    var blockerWindow: UIWindow?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screen_tap_blocker", binaryMessenger: registrar.messenger())
        let instance = ScreenTapBlockerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enable":
            DispatchQueue.main.async {
                self.enableBlocker()
                result(nil)
            }
        case "disable":
            DispatchQueue.main.async {
                self.disableBlocker()
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func enableBlocker() {
        guard blockerWindow == nil else { return }

        // Support both iOS 13+ (with window scenes) and older versions
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            blockerWindow = UIWindow(windowScene: windowScene!)
        } else {
            blockerWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        
        blockerWindow?.frame = UIScreen.main.bounds
        blockerWindow?.backgroundColor = UIColor.clear
        blockerWindow?.windowLevel = UIWindow.Level.statusBar + 1

        let blockerViewController = UIViewController()
        blockerViewController.view.backgroundColor = UIColor.clear
        blockerViewController.view.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ignoreTap))
        blockerViewController.view.addGestureRecognizer(tapRecognizer)

        blockerWindow?.rootViewController = blockerViewController
        blockerWindow?.isHidden = false
    }

    private func disableBlocker() {
        blockerWindow?.isHidden = true
        blockerWindow = nil
    }

    @objc private func ignoreTap() {
        // Поглощаем тап — ничего не делаем
    }
}

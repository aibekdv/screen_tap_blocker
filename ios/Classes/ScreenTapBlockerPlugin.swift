import Flutter
import UIKit

/// Flutter plugin for blocking screen taps on iOS
/// Creates an invisible overlay window that intercepts all touch events
public class ScreenTapBlockerPlugin: NSObject, FlutterPlugin {
    /// The overlay window used to block user interactions
    /// When non-nil, all taps are blocked; when nil, taps are allowed
    var blockerWindow: UIWindow?

    /// Register the plugin with Flutter
    /// - Parameter registrar: The Flutter plugin registrar
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screen_tap_blocker", binaryMessenger: registrar.messenger())
        let instance = ScreenTapBlockerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// Handle method calls from Flutter
    /// - Parameters:
    ///   - call: The Flutter method call containing the method name and arguments
    ///   - result: Callback to return the result back to Flutter
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enable":
            // Enable tap blocking on the main thread (UI operations must be on main thread)
            DispatchQueue.main.async {
                self.enableBlocker()
                result(nil)
            }
        case "disable":
            // Disable tap blocking on the main thread
            DispatchQueue.main.async {
                self.disableBlocker()
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Enable tap blocking by creating an invisible overlay window
    /// The window intercepts all touch events, preventing them from reaching the app
    private func enableBlocker() {
        // Prevent creating multiple blocker windows
        guard blockerWindow == nil else { return }

        // Support both iOS 13+ (with window scenes) and older versions
        if #available(iOS 13.0, *) {
            // iOS 13+ uses window scenes for better multi-window support
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            blockerWindow = UIWindow(windowScene: windowScene!)
        } else {
            // iOS 12 and earlier use the legacy window initialization
            blockerWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        
        // Configure the overlay window
        blockerWindow?.frame = UIScreen.main.bounds
        blockerWindow?.backgroundColor = UIColor.clear  // Invisible overlay
        blockerWindow?.windowLevel = UIWindow.Level.statusBar + 1  // Above status bar but below alerts

        // Create a view controller for the overlay
        let blockerViewController = UIViewController()
        blockerViewController.view.backgroundColor = UIColor.clear
        blockerViewController.view.isUserInteractionEnabled = true  // Enable interaction to capture taps

        // Add gesture recognizer to capture and ignore all tap events
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ignoreTap))
        blockerViewController.view.addGestureRecognizer(tapRecognizer)

        // Set up and show the overlay window
        blockerWindow?.rootViewController = blockerViewController
        blockerWindow?.isHidden = false  // Make the window visible (but transparent)
    }

    /// Disable tap blocking by hiding and removing the overlay window
    /// This allows normal user interactions to resume
    private func disableBlocker() {
        blockerWindow?.isHidden = true  // Hide the overlay window
        blockerWindow = nil  // Release the window from memory
    }

    /// Gesture recognizer action that ignores tap events
    /// This method is called when a tap is detected on the overlay
    /// By doing nothing, we effectively "swallow" the tap event
    @objc private func ignoreTap() {
        // Intentionally empty - this absorbs the tap without any action
    }
}

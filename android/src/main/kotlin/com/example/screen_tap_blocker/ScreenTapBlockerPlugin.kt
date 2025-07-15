package com.example.screen_tap_blocker

import android.app.Activity
import android.graphics.Color
import android.graphics.PixelFormat
import android.view.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter plugin for blocking screen taps on Android
 * Creates an invisible overlay view that intercepts all touch events
 * 
 * Implements FlutterPlugin for Flutter integration and ActivityAware for activity lifecycle management
 */
class ScreenTapBlockerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    /** Method channel for communication between Flutter and native Android code */
    private lateinit var channel: MethodChannel
    
    /** Current activity instance, needed for UI operations */
    private var activity: Activity? = null
    
    /** The overlay view used to block user interactions. When non-null, all taps are blocked */
    private var blockerView: View? = null

    /**
     * Called when the plugin is attached to the Flutter engine
     * Sets up the method channel for communication with Flutter
     */
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "screen_tap_blocker")
        channel.setMethodCallHandler(this)
    }

    /**
     * Called when the plugin is detached from the Flutter engine
     * Cleans up the method channel
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Called when the plugin is attached to an activity
     * Stores the activity reference for UI operations
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    /**
     * Called when the activity is detached for configuration changes (e.g., screen rotation)
     * Temporarily clears the activity reference
     */
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    /**
     * Called when the activity is reattached after configuration changes
     * Restores the activity reference
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    /**
     * Called when the plugin is permanently detached from the activity
     * Clears the activity reference and cleans up resources
     */
    override fun onDetachedFromActivity() {
        activity = null
    }

    /**
     * Handle method calls from Flutter
     * @param call The method call containing the method name and arguments
     * @param result Callback to return the result back to Flutter
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enable" -> {
                // Enable tap blocking on the UI thread (all UI operations must be on main thread)
                activity?.runOnUiThread {
                    // Only create blocker view if it doesn't already exist
                    if (blockerView == null) {
                        // Create invisible overlay view that captures all touch events
                        blockerView = View(activity).apply {
                            setBackgroundColor(Color.TRANSPARENT)  // Invisible background
                            isClickable = true      // Enable click handling
                            isFocusable = true      // Enable focus handling
                            // Touch listener that consumes all touch events (returns true)
                            setOnTouchListener { _, _ -> true }
                        }
                        
                        // Configure window layout parameters for the overlay
                        val params = WindowManager.LayoutParams(
                            WindowManager.LayoutParams.MATCH_PARENT,    // Full width
                            WindowManager.LayoutParams.MATCH_PARENT,    // Full height
                            WindowManager.LayoutParams.TYPE_APPLICATION_PANEL,  // Window type
                            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,      // Don't steal focus
                            PixelFormat.TRANSPARENT  // Transparent pixel format
                        )
                        
                        // Add the overlay view to the window
                        val windowManager = activity?.windowManager
                        windowManager?.addView(blockerView, params)
                    }
                }
                result.success(null)
            }
            "disable" -> {
                // Disable tap blocking on the UI thread
                activity?.runOnUiThread {
                    // Remove and clean up the blocker view if it exists
                    blockerView?.let {
                        val windowManager = activity?.windowManager
                        windowManager?.removeView(it)  // Remove from window
                        blockerView = null  // Clear reference to allow garbage collection
                    }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}

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


class ScreenTapBlockerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var blockerView: View? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "screen_tap_blocker")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enable" -> {
                activity?.runOnUiThread {
                    if (blockerView == null) {
                        blockerView = View(activity).apply {
                            setBackgroundColor(Color.TRANSPARENT)
                            isClickable = true
                            isFocusable = true
                            setOnTouchListener { _, _ -> true }
                        }
                        val params = WindowManager.LayoutParams(
                            WindowManager.LayoutParams.MATCH_PARENT,
                            WindowManager.LayoutParams.MATCH_PARENT,
                            WindowManager.LayoutParams.TYPE_APPLICATION_PANEL,
                            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                            PixelFormat.TRANSPARENT
                        )
                        val windowManager = activity?.windowManager
                        windowManager?.addView(blockerView, params)
                    }
                }
                result.success(null)
            }
            "disable" -> {
                activity?.runOnUiThread {
                    blockerView?.let {
                        val windowManager = activity?.windowManager
                        windowManager?.removeView(it)
                        blockerView = null
                    }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}

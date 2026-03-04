package com.vphone.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.vphone/virtual_app"
    private lateinit var virtualEngine: VirtualAppEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        virtualEngine = VirtualAppEngine(this)
        virtualEngine.initialize()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "initialize" -> {
                        val success = virtualEngine.initialize()
                        result.success(success)
                    }

                    "installApp" -> {
                        val apkPath = call.argument<String>("apkPath") ?: return@setMethodCallHandler result.error("MISSING_ARG", "apkPath required", null)
                        val userId = call.argument<Int>("userId") ?: 0
                        val success = virtualEngine.installApp(apkPath, userId)
                        result.success(success)
                    }

                    "launchApp" -> {
                        val packageName = call.argument<String>("packageName") ?: return@setMethodCallHandler result.error("MISSING_ARG", "packageName required", null)
                        val userId = call.argument<Int>("userId") ?: 0
                        val success = virtualEngine.launchApp(packageName, userId)
                        result.success(success)
                    }

                    "stopApp" -> {
                        val packageName = call.argument<String>("packageName") ?: return@setMethodCallHandler result.error("MISSING_ARG", "packageName required", null)
                        val userId = call.argument<Int>("userId") ?: 0
                        virtualEngine.stopApp(packageName, userId)
                        result.success(null)
                    }

                    "uninstallApp" -> {
                        val packageName = call.argument<String>("packageName") ?: return@setMethodCallHandler result.error("MISSING_ARG", "packageName required", null)
                        val userId = call.argument<Int>("userId") ?: 0
                        val success = virtualEngine.uninstallApp(packageName, userId)
                        result.success(success)
                    }

                    "getInstalledApps" -> {
                        val userId = call.argument<Int>("userId") ?: 0
                        val apps = virtualEngine.getInstalledApps(userId)
                        result.success(apps)
                    }

                    "getStats" -> {
                        val stats = virtualEngine.getResourceStats()
                        result.success(stats)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}

package com.vphone.app

import android.content.Context
import android.util.Log

/**
 * VirtualAppEngine - Stub implementation
 * 
 * الـ UI يشتغل كامل الحين.
 * لتفعيل التشغيل الفعلي للتطبيقات، أضف VirtualApp:
 *   github.com/asLody/VirtualApp
 */
class VirtualAppEngine(private val context: Context) {

    companion object {
        private const val TAG = "VirtualAppEngine"
    }

    // قائمة التطبيقات المثبتة (محلية)
    private val installedApps = mutableListOf<MutableMap<String, Any>>()

    fun initialize(): Boolean {
        Log.d(TAG, "VPhone engine initialized (UI mode)")
        return true
    }

    fun installApp(apkPath: String, userId: Int): Boolean {
        Log.d(TAG, "Install: $apkPath → Space $userId")
        // TODO: استبدل بـ VirtualCore.get().installPackage(apkPath, 0)
        val fakeApp = mutableMapOf<String, Any>(
            "packageName" to apkPath.substringAfterLast("/").removeSuffix(".apk"),
            "name" to apkPath.substringAfterLast("/").removeSuffix(".apk"),
            "userId" to userId,
            "isRunning" to false,
        )
        installedApps.add(fakeApp)
        return true
    }

    fun launchApp(packageName: String, userId: Int): Boolean {
        Log.d(TAG, "Launch: $packageName (Space $userId)")
        // TODO: استبدل بـ VirtualCore.get().launchApp(packageName, userId)
        installedApps.find { it["packageName"] == packageName && it["userId"] == userId }
            ?.set("isRunning", true)
        return true
    }

    fun stopApp(packageName: String, userId: Int) {
        Log.d(TAG, "Stop: $packageName")
        // TODO: استبدل بـ VirtualCore.get().killAppByPkg(packageName, userId)
        installedApps.find { it["packageName"] == packageName && it["userId"] == userId }
            ?.set("isRunning", false)
    }

    fun uninstallApp(packageName: String, userId: Int): Boolean {
        Log.d(TAG, "Uninstall: $packageName")
        // TODO: استبدل بـ VirtualCore.get().uninstallPackageAsUser(packageName, userId)
        return installedApps.removeAll { it["packageName"] == packageName && it["userId"] == userId }
    }

    fun getInstalledApps(userId: Int): List<Map<String, Any>> {
        return installedApps.filter { it["userId"] == userId }
    }

    fun getResourceStats(): Map<String, Any> {
        val runtime = Runtime.getRuntime()
        val usedMem = (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024)
        return mapOf(
            "memoryUsedMB" to usedMem,
            "memoryTotalMB" to (runtime.totalMemory() / (1024 * 1024)),
            "cpuPercent" to 0,
        )
    }
}

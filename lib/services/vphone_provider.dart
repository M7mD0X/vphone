import 'package:flutter/foundation.dart';
import '../models/virtual_app.dart';

class VPhoneProvider extends ChangeNotifier {
  List<VirtualApp> _apps = [];
  List<VirtualSpace> _spaces = VirtualSpace.defaults;
  int _activeSpaceId = 0;
  bool _isLoading = false;
  double _totalCpu = 0;
  int _totalMemory = 0;

  List<VirtualApp> get apps => _apps.where((a) => a.userId == _activeSpaceId).toList();
  List<VirtualApp> get runningApps => _apps.where((a) => a.isRunning).toList();
  List<VirtualSpace> get spaces => _spaces;
  int get activeSpaceId => _activeSpaceId;
  bool get isLoading => _isLoading;
  double get totalCpu => _totalCpu;
  int get totalMemory => _totalMemory;
  int get totalApps => _apps.length;

  void setActiveSpace(int id) {
    _activeSpaceId = id;
    _spaces = _spaces.map((s) => VirtualSpace(
      id: s.id,
      name: s.name,
      emoji: s.emoji,
      appsCount: s.appsCount,
      isActive: s.id == id,
    )).toList();
    notifyListeners();
  }

  Future<void> loadApps() async {
    _isLoading = true;
    notifyListeners();

    // Simulate loading - replace with actual VirtualApp channel call
    await Future.delayed(const Duration(milliseconds: 800));

    _apps = [
      VirtualApp(
        id: '1',
        name: 'WhatsApp',
        packageName: 'com.whatsapp',
        apkPath: '/storage/apks/whatsapp.apk',
        userId: 0,
        isRunning: true,
        cpuUsage: 12,
        memoryMB: 145,
        installedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Social',
        sizeBytes: 85 * 1024 * 1024,
      ),
      VirtualApp(
        id: '2',
        name: 'Instagram',
        packageName: 'com.instagram.android',
        apkPath: '/storage/apks/instagram.apk',
        userId: 0,
        isRunning: false,
        cpuUsage: 0,
        memoryMB: 0,
        installedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Social',
        sizeBytes: 65 * 1024 * 1024,
      ),
      VirtualApp(
        id: '3',
        name: 'PUBG Mobile',
        packageName: 'com.tencent.ig',
        apkPath: '/storage/apks/pubg.apk',
        userId: 0,
        isRunning: true,
        cpuUsage: 45,
        memoryMB: 620,
        installedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Games',
        sizeBytes: 2200 * 1024 * 1024,
      ),
      VirtualApp(
        id: '4',
        name: 'TikTok',
        packageName: 'com.zhiliaoapp.musically',
        apkPath: '/storage/apks/tiktok.apk',
        userId: 1,
        isRunning: false,
        cpuUsage: 0,
        memoryMB: 0,
        installedAt: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'Social',
        sizeBytes: 120 * 1024 * 1024,
      ),
    ];

    _calculateStats();
    _isLoading = false;
    notifyListeners();
  }

  void _calculateStats() {
    _totalCpu = _apps.fold(0.0, (sum, a) => sum + a.cpuUsage);
    _totalMemory = _apps.fold(0, (sum, a) => sum + a.memoryMB);
  }

  Future<void> launchApp(String appId) async {
    _apps = _apps.map((a) {
      if (a.id == appId) return a.copyWith(isRunning: true, cpuUsage: 8, memoryMB: 120);
      return a;
    }).toList();
    _calculateStats();
    notifyListeners();

    // TODO: Call native VirtualApp channel
    // await VirtualAppChannel.launch(packageName);
  }

  Future<void> stopApp(String appId) async {
    _apps = _apps.map((a) {
      if (a.id == appId) return a.copyWith(isRunning: false, cpuUsage: 0, memoryMB: 0);
      return a;
    }).toList();
    _calculateStats();
    notifyListeners();
  }

  Future<void> uninstallApp(String appId) async {
    _apps.removeWhere((a) => a.id == appId);
    _calculateStats();
    notifyListeners();
  }

  Future<void> installApk(String apkPath) async {
    // TODO: Call native VirtualApp install channel
    // await VirtualAppChannel.install(apkPath, _activeSpaceId);
    await loadApps();
  }
}

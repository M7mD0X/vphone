class VirtualApp {
  final String id;
  final String name;
  final String packageName;
  final String apkPath;
  final String? iconPath;
  final int userId; // virtual user ID (0 = space 1, 1 = space 2, etc.)
  final bool isRunning;
  final int cpuUsage;     // 0-100
  final int memoryMB;
  final DateTime installedAt;
  final String category;
  final int sizeBytes;

  VirtualApp({
    required this.id,
    required this.name,
    required this.packageName,
    required this.apkPath,
    this.iconPath,
    this.userId = 0,
    this.isRunning = false,
    this.cpuUsage = 0,
    this.memoryMB = 0,
    required this.installedAt,
    this.category = 'Other',
    this.sizeBytes = 0,
  });

  VirtualApp copyWith({
    bool? isRunning,
    int? cpuUsage,
    int? memoryMB,
  }) {
    return VirtualApp(
      id: id,
      name: name,
      packageName: packageName,
      apkPath: apkPath,
      iconPath: iconPath,
      userId: userId,
      isRunning: isRunning ?? this.isRunning,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryMB: memoryMB ?? this.memoryMB,
      installedAt: installedAt,
      category: category,
      sizeBytes: sizeBytes,
    );
  }

  String get sizeFormatted {
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class VirtualSpace {
  final int id;
  final String name;
  final String emoji;
  final int appsCount;
  final bool isActive;

  const VirtualSpace({
    required this.id,
    required this.name,
    required this.emoji,
    this.appsCount = 0,
    this.isActive = false,
  });

  static List<VirtualSpace> defaults = [
    VirtualSpace(id: 0, name: 'Space 1', emoji: '🔵', appsCount: 3, isActive: true),
    VirtualSpace(id: 1, name: 'Space 2', emoji: '🟣', appsCount: 1),
    VirtualSpace(id: 2, name: 'Space 3', emoji: '🟢', appsCount: 0),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class InstallScreen extends StatefulWidget {
  const InstallScreen({super.key});

  @override
  State<InstallScreen> createState() => _InstallScreenState();
}

class _InstallScreenState extends State<InstallScreen> {
  bool _isInstalling = false;
  double _progress = 0;
  String? _selectedFile;
  int _selectedSpace = 0;

  final List<Map<String, dynamic>> _recentApks = [
    {'name': 'WhatsApp', 'size': '85 MB', 'path': '/storage/apks/whatsapp.apk', 'category': 'Social'},
    {'name': 'Chrome', 'size': '120 MB', 'path': '/storage/apks/chrome.apk', 'category': 'Browser'},
    {'name': 'PUBG Mobile', 'size': '2.2 GB', 'path': '/storage/apks/pubg.apk', 'category': 'Game'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VPhoneTheme.bgDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VPhoneTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VPhoneTheme.border),
            ),
            child: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: VPhoneTheme.accent),
          ),
        ),
        title: const Text('INSTALL APP', style: TextStyle(letterSpacing: 3, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropZone(),
            const SizedBox(height: 20),
            _buildSpaceSelector(),
            const SizedBox(height: 20),
            _buildRecentSection(),
            if (_isInstalling) ...[
              const SizedBox(height: 20),
              _buildProgressSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _selectedFile != null
                ? VPhoneTheme.success.withOpacity(0.6)
                : VPhoneTheme.accent.withOpacity(0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: VPhoneTheme.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedFile != null ? Icons.check_rounded : Icons.upload_file_rounded,
                color: _selectedFile != null ? VPhoneTheme.success : VPhoneTheme.accent,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFile != null ? _selectedFile! : 'Tap to select APK file',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _selectedFile != null ? VPhoneTheme.success : VPhoneTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Supports .apk and .xapk files',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                color: VPhoneTheme.textMuted,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: Duration(milliseconds: 500)),
    );
  }

  Widget _buildSpaceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INSTALL TO SPACE',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            letterSpacing: 2,
            color: VPhoneTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (i) {
            final labels = ['🔵 Space 1', '🟣 Space 2', '🟢 Space 3'];
            final isSelected = _selectedSpace == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedSpace = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? VPhoneTheme.accent.withOpacity(0.15)
                        : VPhoneTheme.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? VPhoneTheme.accent : VPhoneTheme.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? VPhoneTheme.accent : VPhoneTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT APKS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            letterSpacing: 2,
            color: VPhoneTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ..._recentApks.asMap().entries.map((e) {
          final app = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: VPhoneTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: VPhoneTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [VPhoneTheme.accentSecondary, VPhoneTheme.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(app['name'][0],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Rajdhani',
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app['name'],
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: VPhoneTheme.textPrimary,
                          )),
                      Row(
                        children: [
                          _chip(app['category'], VPhoneTheme.accentSecondary),
                          const SizedBox(width: 6),
                          _chip(app['size'], VPhoneTheme.textMuted),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _installApp(app['path']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [VPhoneTheme.accent, VPhoneTheme.accentSecondary],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('INSTALL',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        )),
                  ),
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: e.key * 80))
              .fadeIn()
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }

  Widget _chip(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 11,
              color: color,
            )),
      );

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: glowDecoration(color: VPhoneTheme.success),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: VPhoneTheme.success,
                ),
              ),
              const SizedBox(width: 10),
              const Text('Installing...',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: VPhoneTheme.success,
                  )),
              const Spacer(),
              Text('${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    color: VPhoneTheme.success,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: VPhoneTheme.success.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(VPhoneTheme.success),
              minHeight: 4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Future<void> _pickFile() async {
    // TODO: Use file_picker package
    // final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['apk', 'xapk']);
    setState(() => _selectedFile = 'selected_app.apk');
  }

  Future<void> _installApp(String path) async {
    setState(() {
      _isInstalling = true;
      _progress = 0;
    });

    // Simulate install progress
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _progress = i / 10);
    }

    setState(() => _isInstalling = false);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

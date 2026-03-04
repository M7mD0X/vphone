import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableGpu = true;
  bool _highPerformance = false;
  bool _networkIsolation = true;
  bool _rootAccess = false;
  double _cpuLimit = 80;
  double _ramLimit = 1024;

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
        title: const Text('SETTINGS', style: TextStyle(letterSpacing: 3, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('PERFORMANCE'),
          _switchTile(
            icon: Icons.speed_rounded,
            title: 'High Performance Mode',
            subtitle: 'Max CPU & GPU priority',
            value: _highPerformance,
            color: VPhoneTheme.warning,
            onChanged: (v) => setState(() => _highPerformance = v),
          ),
          _switchTile(
            icon: Icons.memory_rounded,
            title: 'GPU Acceleration',
            subtitle: 'Hardware rendering for games',
            value: _enableGpu,
            color: VPhoneTheme.accent,
            onChanged: (v) => setState(() => _enableGpu = v),
          ),
          _sliderTile(
            icon: Icons.developer_board_rounded,
            title: 'CPU Limit',
            value: _cpuLimit,
            min: 20,
            max: 100,
            unit: '%',
            color: VPhoneTheme.danger,
            onChanged: (v) => setState(() => _cpuLimit = v),
          ),
          _sliderTile(
            icon: Icons.storage_rounded,
            title: 'RAM Limit',
            value: _ramLimit,
            min: 256,
            max: 4096,
            unit: 'MB',
            color: VPhoneTheme.accentSecondary,
            onChanged: (v) => setState(() => _ramLimit = v),
          ),
          const SizedBox(height: 16),
          _sectionLabel('SECURITY'),
          _switchTile(
            icon: Icons.security_rounded,
            title: 'Network Isolation',
            subtitle: 'Separate virtual network',
            value: _networkIsolation,
            color: VPhoneTheme.success,
            onChanged: (v) => setState(() => _networkIsolation = v),
          ),
          _switchTile(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Root Access',
            subtitle: 'Grant root to virtual apps',
            value: _rootAccess,
            color: VPhoneTheme.danger,
            onChanged: (v) => setState(() => _rootAccess = v),
          ),
          const SizedBox(height: 16),
          _sectionLabel('ABOUT'),
          _infoTile(Icons.info_outline_rounded, 'Version', '1.0.0'),
          _infoTile(Icons.code_rounded, 'Engine', 'VirtualApp 3.0'),
          _infoTile(Icons.android_rounded, 'Android', 'API 26+'),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
        child: Text(label,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              letterSpacing: 2,
              color: VPhoneTheme.textSecondary,
            )),
      ).animate().fadeIn();

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: value ? color.withOpacity(0.3) : VPhoneTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: VPhoneTheme.textPrimary,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: VPhoneTheme.textSecondary,
                      )),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.2),
            ),
          ],
        ),
      ).animate().fadeIn().slideX(begin: 0.05, end: 0);

  Widget _sliderTile({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Color color,
    required ValueChanged<double> onChanged,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VPhoneTheme.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: VPhoneTheme.textPrimary,
                    )),
                const Spacer(),
                Text('${value.toInt()} $unit',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      color: color,
                    )),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              activeColor: color,
              inactiveColor: color.withOpacity(0.1),
              onChanged: onChanged,
            ),
          ],
        ),
      ).animate().fadeIn();

  Widget _infoTile(IconData icon, String label, String value) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VPhoneTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: VPhoneTheme.textSecondary, size: 18),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 15,
                  color: VPhoneTheme.textPrimary,
                )),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  color: VPhoneTheme.textSecondary,
                )),
          ],
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/virtual_app.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final VirtualApp app;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final int index;

  const AppCard({
    super.key,
    required this.app,
    required this.onTap,
    this.onLongPress,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: app.isRunning
                ? VPhoneTheme.accent.withOpacity(0.4)
                : VPhoneTheme.border,
            width: 1,
          ),
          boxShadow: app.isRunning
              ? [
                  BoxShadow(
                    color: VPhoneTheme.accent.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _appColors(app.packageName),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      app.name[0],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Rajdhani',
                      ),
                    ),
                  ),
                ),
                if (app.isRunning)
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: VPhoneTheme.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: VPhoneTheme.bgCard, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: VPhoneTheme.success.withOpacity(0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // App name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                app.name,
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: VPhoneTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 4),

            // Memory usage (if running)
            if (app.isRunning)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: VPhoneTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${app.memoryMB}MB',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: VPhoneTheme.accent,
                  ),
                ),
              )
            else
              Text(
                app.sizeFormatted,
                style: const TextStyle(
                  fontSize: 11,
                  color: VPhoneTheme.textMuted,
                  fontFamily: 'Rajdhani',
                ),
              ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: index * 60))
          .fadeIn(duration: const Duration(milliseconds: 400))
          .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut),
    );
  }

  List<Color> _appColors(String packageName) {
    final hash = packageName.hashCode;
    final palettes = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFF00D4FF), const Color(0xFF0099CC)],
      [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
      [const Color(0xFF56AB2F), const Color(0xFFA8E063)],
      [const Color(0xFFFC5C7D), const Color(0xFF6A82FB)],
      [const Color(0xFFF7971E), const Color(0xFFFFD200)],
      [const Color(0xFF7C3AFF), const Color(0xFF3B82F6)],
    ];
    return palettes[hash.abs() % palettes.length];
  }
}

// Context menu for long press
class AppContextMenu extends StatelessWidget {
  final VirtualApp app;
  final VoidCallback onLaunch;
  final VoidCallback onStop;
  final VoidCallback onUninstall;

  const AppContextMenu({
    super.key,
    required this.app,
    required this.onLaunch,
    required this.onStop,
    required this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: glowDecoration(borderRadius: 24),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildAppHeader(),
          const Divider(color: VPhoneTheme.border, height: 1),
          if (!app.isRunning)
            _menuItem(Icons.play_arrow_rounded, 'Launch', VPhoneTheme.success, onLaunch),
          if (app.isRunning)
            _menuItem(Icons.stop_rounded, 'Force Stop', VPhoneTheme.warning, onStop),
          _menuItem(Icons.info_outline_rounded, 'App Info', VPhoneTheme.accent, () {}),
          _menuItem(Icons.delete_outline_rounded, 'Uninstall', VPhoneTheme.danger, onUninstall),
        ],
      ),
    );
  }

  Widget _buildHandle() => Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: VPhoneTheme.textMuted,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildAppHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [VPhoneTheme.accent, VPhoneTheme.accentSecondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  app.name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name,
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: VPhoneTheme.textPrimary,
                    )),
                Text(app.packageName,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: VPhoneTheme.textMuted,
                    )),
              ],
            ),
          ],
        ),
      );

  Widget _menuItem(IconData icon, String label, Color color, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Text(label,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  )),
            ],
          ),
        ),
      );
}

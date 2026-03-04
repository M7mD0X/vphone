import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class StatsBar extends StatelessWidget {
  final double cpuPercent;
  final int memoryMB;
  final int totalApps;
  final int runningApps;

  const StatsBar({
    super.key,
    required this.cpuPercent,
    required this.memoryMB,
    required this.totalApps,
    required this.runningApps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VPhoneTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VPhoneTheme.border),
      ),
      child: Row(
        children: [
          Expanded(child: _StatItem(
            label: 'CPU',
            value: '${cpuPercent.toStringAsFixed(1)}%',
            percent: cpuPercent / 100,
            color: _cpuColor(cpuPercent),
            icon: Icons.memory_rounded,
          )),
          _divider(),
          Expanded(child: _StatItem(
            label: 'RAM',
            value: '${memoryMB}MB',
            percent: (memoryMB / 2048).clamp(0, 1),
            color: VPhoneTheme.accentSecondary,
            icon: Icons.storage_rounded,
          )),
          _divider(),
          Expanded(child: _StatItem(
            label: 'Apps',
            value: '$runningApps/$totalApps',
            percent: totalApps > 0 ? runningApps / totalApps : 0,
            color: VPhoneTheme.success,
            icon: Icons.apps_rounded,
          )),
        ],
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 500)).slideY(begin: -0.1, end: 0);
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: VPhoneTheme.border,
      );

  Color _cpuColor(double percent) {
    if (percent < 40) return VPhoneTheme.success;
    if (percent < 70) return VPhoneTheme.warning;
    return VPhoneTheme.danger;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final double percent;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              color: VPhoneTheme.textSecondary,
              letterSpacing: 1,
            )),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: color,
        )),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 3,
          ),
        ),
      ],
    );
  }
}

class SpaceSelector extends StatelessWidget {
  final List spaces;
  final int activeId;
  final ValueChanged<int> onSelect;

  const SpaceSelector({
    super.key,
    required this.spaces,
    required this.activeId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: spaces.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == spaces.length) return _addButton(context);
          final space = spaces[i];
          final isActive = space.id == activeId;
          return GestureDetector(
            onTap: () => onSelect(space.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? VPhoneTheme.accent.withOpacity(0.15) : VPhoneTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? VPhoneTheme.accent : VPhoneTheme.border,
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(space.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(space.name,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive ? VPhoneTheme.accent : VPhoneTheme.textSecondary,
                      )),
                  if (space.appsCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isActive ? VPhoneTheme.accent : VPhoneTheme.textMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${space.appsCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'JetBrainsMono',
                          )),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addButton(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          width: 48,
          decoration: BoxDecoration(
            color: VPhoneTheme.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VPhoneTheme.border),
          ),
          child: const Icon(Icons.add_rounded, color: VPhoneTheme.textSecondary, size: 20),
        ),
      );
}

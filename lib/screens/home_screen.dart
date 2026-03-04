import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/vphone_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/stats_bar.dart';
import 'install_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VPhoneProvider>().loadApps();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VPhoneTheme.bgDeep,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSpaceSelector(),
                _buildStatsBar(),
                _buildSectionTitle(),
                _buildAppGrid(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -100 + (_bgController.value * 30),
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VPhoneTheme.accent.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100 - (_bgController.value * 20),
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VPhoneTheme.accentSecondary.withOpacity(0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VPHONE',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: VPhoneTheme.textPrimary,
                  letterSpacing: 4,
                ),
              ).animate().fadeIn(duration: Duration(milliseconds: 600)).slideX(begin: -0.2, end: 0),
              Container(
                width: 60,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [VPhoneTheme.accent, VPhoneTheme.accentSecondary],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          _iconButton(Icons.search_rounded, () {}),
          const SizedBox(width: 4),
          _iconButton(Icons.settings_rounded, () => Navigator.pushNamed(context, '/settings')),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: VPhoneTheme.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VPhoneTheme.border),
          ),
          child: Icon(icon, color: VPhoneTheme.textSecondary, size: 20),
        ),
      );

  Widget _buildSpaceSelector() {
    return Consumer<VPhoneProvider>(
      builder: (_, provider, __) => SpaceSelector(
        spaces: provider.spaces,
        activeId: provider.activeSpaceId,
        onSelect: provider.setActiveSpace,
      ),
    );
  }

  Widget _buildStatsBar() {
    return Consumer<VPhoneProvider>(
      builder: (_, provider, __) => StatsBar(
        cpuPercent: provider.totalCpu,
        memoryMB: provider.totalMemory,
        totalApps: provider.totalApps,
        runningApps: provider.runningApps.length,
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Consumer<VPhoneProvider>(
      builder: (_, provider, __) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          children: [
            const Text(
              'INSTALLED APPS',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: VPhoneTheme.textSecondary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: VPhoneTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: VPhoneTheme.accent.withOpacity(0.3)),
              ),
              child: Text(
                '${provider.apps.length}',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: VPhoneTheme.accent,
                ),
              ),
            ),
            const Spacer(),
            if (provider.runningApps.isNotEmpty)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/running'),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: VPhoneTheme.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.runningApps.length} running',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: VPhoneTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppGrid() {
    return Expanded(
      child: Consumer<VPhoneProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) return _buildShimmer();
          if (provider.apps.isEmpty) return _buildEmpty();

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: provider.apps.length,
            itemBuilder: (context, i) {
              final app = provider.apps[i];
              return AppCard(
                app: app,
                index: i,
                onTap: () => _launchApp(provider, app.id),
                onLongPress: () => _showContextMenu(context, provider, app),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: VPhoneTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
        ),
      ).animate(onPlay: (c) => c.repeat())
          .shimmer(duration: const Duration(milliseconds: 1200), color: VPhoneTheme.textMuted.withOpacity(0.3)),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VPhoneTheme.accent.withOpacity(0.1),
              border: Border.all(color: VPhoneTheme.accent.withOpacity(0.3)),
            ),
            child: const Icon(Icons.apps_rounded, color: VPhoneTheme.accent, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No Apps Installed',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: VPhoneTheme.textPrimary,
              )),
          const SizedBox(height: 8),
          const Text('Tap + to install your first app',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: VPhoneTheme.textSecondary,
              )),
        ],
      ).animate().fadeIn(duration: Duration(milliseconds: 600)).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InstallScreen()),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [VPhoneTheme.accent, VPhoneTheme.accentSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: VPhoneTheme.accent.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: -4,
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    ).animate().scale(delay: Duration(milliseconds: 800), duration: Duration(milliseconds: 400), curve: Curves.elasticOut);
  }

  void _launchApp(VPhoneProvider provider, String appId) {
    HapticFeedback.lightImpact();
    provider.launchApp(appId);
  }

  void _showContextMenu(BuildContext context, VPhoneProvider provider, app) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AppContextMenu(
        app: app,
        onLaunch: () {
          Navigator.pop(context);
          provider.launchApp(app.id);
        },
        onStop: () {
          Navigator.pop(context);
          provider.stopApp(app.id);
        },
        onUninstall: () {
          Navigator.pop(context);
          provider.uninstallApp(app.id);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _haptics = true;
  bool _notifications = true;
  double _fineLevel = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildSection('Appearance', [
            _buildSwitchTile(
              'Dark Mode',
              'Use dark theme throughout the app',
              Icons.dark_mode_outlined,
              _darkMode,
              (val) => setState(() => _darkMode = val),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Behavior', [
            _buildSwitchTile(
              'Haptic Feedback',
              'Vibrate on interactions',
              Icons.vibration_outlined,
              _haptics,
              (val) => setState(() => _haptics = val),
            ),
            _buildSwitchTile(
              'Notifications',
              'Session reminders and updates',
              Icons.notifications_outlined,
              _notifications,
              (val) => setState(() => _notifications = val),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Fine Control', [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Strictness Level',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.divider,
                      thumbColor: AppColors.primary,
                    ),
                    child: Slider(
                      value: _fineLevel,
                      onChanged: (val) => setState(() => _fineLevel = val),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Lenient', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      Text('Strict', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Account', [
            _buildListTile(
              'Parachutes',
              '3 remaining',
              Icons.paragliding_outlined,
              () {},
            ),
            _buildListTile(
              'Remove Ads',
              'One-time purchase',
              Icons.ads_click_outlined,
              () {},
            ),
            _buildListTile(
              'Restore Purchases',
              '',
              Icons.restore_outlined,
              () {},
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('About', [
            _buildListTile(
              'Privacy Policy',
              '',
              Icons.privacy_tip_outlined,
              () {},
            ),
            _buildListTile(
              'Terms of Service',
              '',
              Icons.description_outlined,
              () {},
            ),
            _buildListTile(
              'Version',
              '1.0.0 (Beta)',
              Icons.info_outline,
              () {},
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      secondary: Icon(icon, color: AppColors.primary),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildListTile(String title, String trailing, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: Text(
        trailing,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}

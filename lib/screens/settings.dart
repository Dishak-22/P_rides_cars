import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/ride_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final values = [true, true, true, false];
  final labels = ['Notifications', 'Sound & vibration', 'Save places', 'Location sharing'];
  final subtitles = ['Ride updates, offers and alerts', 'Driver arrival and ride sounds', 'Quick access to Home and Work', 'Demo only — no real tracking'];

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Settings',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (var i = 0; i < labels.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SoftCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: values[i],
                    onChanged: (v) => setState(() => values[i] = v),
                    title: Text(labels[i], style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(subtitles[i], style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    activeThumbColor: AppColors.teal,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const SoftCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.privacy_tip_outlined),
                    title: Text('Privacy', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.info_outline),
                    title: Text('About P-Ride', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Text('v1.0.0', style: TextStyle(color: AppColors.muted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

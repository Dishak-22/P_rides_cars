import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../models/ride_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class ChooseRideScreen extends StatefulWidget {
  const ChooseRideScreen({super.key});
  @override
  State<ChooseRideScreen> createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRideScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Choose your ride',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(),
          footer: PrimaryButton(label: 'View fare estimate', onTap: () => go(c, '/fare')),
          children: [
            const Text('Available rides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            for (var i = 0; i < rideOptions.length; i++)
              _RideOptionTile(option: rideOptions[i], selected: selected == i, onTap: () => setState(() => selected = i)),
          ],
        ),
      );
}

class _RideOptionTile extends StatelessWidget {
  const _RideOptionTile({required this.option, required this.selected, required this.onTap});
  final RideOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.teal : AppColors.line, width: selected ? 1.7 : 1),
          ),
          child: Row(
            children: [
              Icon(option.icon, color: AppColors.navy, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text('${option.eta} • ${option.capacity}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              Text(option.fare, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
        ),
      );
}

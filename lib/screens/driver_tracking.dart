import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class DriverTrackingScreen extends StatelessWidget {
  const DriverTrackingScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= Breakpoints.split;
            return Stack(
              children: [
                const Positioned.fill(child: MockMap(tracking: true)),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Align(
                    alignment: wide ? Alignment.bottomLeft : Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: wide ? 420 : 560, maxHeight: math.max(0.0, box.maxHeight - 32)),
                      child: SoftCard(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(radius: 25, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Amit is on the way', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                                      Text('Maruti Suzuki Dzire • MH 12 KT 4821', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: () => go(c, '/call'), icon: const Icon(Icons.call_outlined)),
                                IconButton(onPressed: () => go(c, '/chat'), icon: const Icon(Icons.chat_bubble_outline)),
                              ],
                            ),
                            const Divider(),
                            const RideInfoRow('Arriving in', '4 min'),
                            const RideInfoRow('Trip estimate', '₹189'),
                            PrimaryButton(label: 'Complete demo ride', onTap: () => go(c, '/complete')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
}

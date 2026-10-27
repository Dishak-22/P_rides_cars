import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_style.dart';

/// "Where to?" pill under the greeting. Opens the existing booking flow.
class HomeSearchPill extends StatelessWidget {
  const HomeSearchPill({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
        child: Semantics(
          button: true,
          label: 'Enter pickup and drop location',
          child: Material(
            color: HomeColors.glass,
            shape: StadiumBorder(side: BorderSide(color: HomeColors.stroke)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                child: Row(children: [
                  Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: .7)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Enter pickup & drop location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withValues(alpha: .65), fontSize: 14)),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: P.gold, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_rounded, color: P.navy, size: 20),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

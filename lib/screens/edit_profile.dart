import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Edit profile',
        body: FormScroll(
          child: Column(
            children: [
              const CircleAvatar(radius: 42, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 42)),
              const SizedBox(height: 22),
              const TextField(decoration: InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Mobile number', prefixIcon: Icon(Icons.phone_outlined))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Save changes', onTap: () => Navigator.pop(c)),
            ],
          ),
        ),
      );
}

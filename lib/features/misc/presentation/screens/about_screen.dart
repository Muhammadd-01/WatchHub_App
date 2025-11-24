import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About WatchHub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.accentColor.withAlpha(77), // 0.3 * 255 ~= 77
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.watch,
                size: 50,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'WatchHub',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 40),
            const Text(
              'WatchHub is your premier destination for luxury timepieces. We offer a curated selection of the finest watches from around the world, ensuring authenticity and quality in every purchase.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoTile(
              context,
              Icons.language,
              'Website',
              'www.watchhub.com',
            ),
            _buildInfoTile(
              context,
              Icons.email,
              'Contact',
              'support@watchhub.com',
            ),
            _buildInfoTile(
              context,
              Icons.location_on,
              'Location',
              'New York, USA',
            ),
            const SizedBox(height: 40),
            const Text(
              '© 2025 WatchHub. All rights reserved.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withAlpha(26), // 0.1 * 255 ~= 26
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.accentColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6366F1), width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 46,
                      backgroundColor: Color(0xFF1E293B),
                      child: Icon(Icons.person, size: 50, color: Colors.white70),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Noufel Dev',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              'noufel@developer.com',
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 30),

            // Profile Options
            _buildProfileTile(Icons.security_rounded, 'Security & 2FA'),
            _buildProfileTile(Icons.account_balance_rounded, 'Linked Bank Accounts'),
            _buildProfileTile(Icons.notifications_outlined, 'Push Notifications'),
            _buildProfileTile(Icons.help_outline_rounded, 'Help & Support'),
            _buildProfileTile(Icons.logout_rounded, 'Sign Out', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF818CF8),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive ? const Color(0xFFEF4444) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white38),
          onTap: () {},
        ),
      ),
    );
  }
}

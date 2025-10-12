import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _pushPlaceholder(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _PlaceholderPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE02200);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        AssetImage('assets/images/profile_avatar.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emily',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('emily97@gmail.com',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _pushPlaceholder(context, 'Edit Profile'),
                    icon: const Icon(Icons.edit, color: red),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Rounded card with list tiles
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'My Preferences',
                      onTap: () => _pushPlaceholder(context, 'My Preferences'),
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.credit_card_outlined,
                      label: 'My Activity',
                      onTap: () => _pushPlaceholder(context, 'My Activity'),
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.notifications_none,
                      label: 'Notifications',
                      onTap: () => _pushPlaceholder(context, 'Notifications'),
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.help_outline,
                      label: 'Help',
                      onTap: () => _pushPlaceholder(context, 'Help'),
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.info_outline,
                      label: 'About',
                      onTap: () => _pushPlaceholder(context, 'About'),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Log out button
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: () => _pushPlaceholder(context, 'Log Out'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: red),
                        const SizedBox(width: 12),
                        Text('Log Out',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700, color: red)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.black87),
      ),
      title:
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          Center(child: Text(title, style: GoogleFonts.poppins(fontSize: 18))),
    );
  }
}

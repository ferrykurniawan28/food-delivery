import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Dummy user data
  final String userName = 'John Doe';
  final String userEmail = 'john.doe@example.com';
  final String userPhone = '+1 234 567 8900';
  final String userAddress = '123 Main Street, New York, NY 10001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile feature (Demo)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange[100],
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // User Email
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account Information Section
            _buildSection('Personal Information', [
              _buildInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: userEmail,
                onTap: () => _showEditDialog('Email'),
              ),
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: 'Phone',
                subtitle: userPhone,
                onTap: () => _showEditDialog('Phone'),
              ),
              _buildInfoTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                subtitle: userAddress,
                onTap: () => _showEditDialog('Address'),
              ),
            ]),

            const SizedBox(height: 20),

            // Preferences Section
            _buildSection('Preferences', [
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive order updates and promotions',
                value: true,
                onChanged: (value) => _showFeatureDemo('Notifications'),
              ),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Receive promotional emails',
                value: false,
                onChanged: (value) => _showFeatureDemo('Email Notifications'),
              ),
              _buildInfoTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () => _showFeatureDemo('Language'),
              ),
            ]),

            const SizedBox(height: 20),

            // Orders & Payment Section
            _buildSection('Orders & Payment', [
              _buildInfoTile(
                icon: Icons.history,
                title: 'Order History',
                subtitle: 'View your past orders',
                onTap: () => _showFeatureDemo('Order History'),
              ),
              _buildInfoTile(
                icon: Icons.favorite_outline,
                title: 'Favorite Restaurants',
                subtitle: 'Manage your favorites',
                onTap: () => _showFeatureDemo('Favorites'),
              ),
              _buildInfoTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage cards and payment options',
                onTap: () => _showFeatureDemo('Payment Methods'),
              ),
              _buildInfoTile(
                icon: Icons.local_offer_outlined,
                title: 'Promotions & Offers',
                subtitle: 'View available discounts',
                onTap: () => _showFeatureDemo('Promotions'),
              ),
            ]),

            const SizedBox(height: 20),

            // Support Section
            _buildSection('Support', [
              _buildInfoTile(
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Get answers to common questions',
                onTap: () => _showFeatureDemo('Help'),
              ),
              _buildInfoTile(
                icon: Icons.contact_support_outlined,
                title: 'Contact Support',
                subtitle: 'Chat with our support team',
                onTap: () => _showFeatureDemo('Contact Support'),
              ),
              _buildInfoTile(
                icon: Icons.star_outline,
                title: 'Rate the App',
                subtitle: 'Help us improve',
                onTap: () => _showFeatureDemo('Rate App'),
              ),
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and legal info',
                onTap: () => _showFeatureDemo('About'),
              ),
            ]),

            const SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.red[300]!),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
    );
  }

  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$field updated! (Demo)')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFeatureDemo(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature feature (Demo)')));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully! (Demo)'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

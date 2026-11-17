import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool loggedIn = await _authService.isLoggedIn();
    setState(() => _isLoggedIn = loggedIn);
  }

  void _logout() async {
    await _authService.logout();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondaryBackground,
              child: Icon(Icons.person, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('My Orders'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Wishlist'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('LOGOUT', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

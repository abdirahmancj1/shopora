import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textLight),
            SizedBox(height: 20),
            Text('Your cart is empty', style: TextStyle(fontSize: 18, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}

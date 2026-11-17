import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 50, color: AppColors.textLight),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'QUICK ADD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

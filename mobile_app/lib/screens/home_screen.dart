import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../constants/app_colors.dart';
import 'product_details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MINISHOP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
            },
          ),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => productProvider.fetchProducts(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Banner
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF333333)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SUMMER SALE',
                                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 2),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Up to 50% Off',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Categories',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = productProvider.categories[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryBackground,
                              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Featured Products',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: ProductCard(product: product),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

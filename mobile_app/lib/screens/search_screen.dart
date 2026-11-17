import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _results = [];
  bool _isSearching = false;

  void _onSearch(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearching = true);
    final results = await Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onSubmitted: _onSearch,
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No results found.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final product = _results[index];
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
    );
  }
}

import 'package:demo/models/products_model.dart';
import 'package:demo/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  query = value;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductsProvider>().searchProduct(query: query);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Products', style: TextStyle(fontSize: 24)),
              ),
            ),
            Consumer<ProductsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(
                    child: Text('${provider.error}'),
                  );
                }

                if (provider.productList != null) {
                  final products = provider.productList?.products;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: (products!.length + 1),
                      itemBuilder: (context, index) {
                        if (products.length == index) {
                          if (provider.isLoadMoreLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            );
                          }
                          return TextButton(
                            onPressed: () {
                              final skip = provider.productList?.skip;
                              context.read<ProductsProvider>().loadMore(skip ?? 0);
                            },
                            child: const Text('Load More'),
                          );
                        }
                        final product = provider.productList?.products?[index];
                        return CustomCard(product: product);
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('No Products Found'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({required this.product, super.key});
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${product?.title}',
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        '${product?.description}',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

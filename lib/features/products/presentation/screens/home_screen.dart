import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/product_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/product_card.dart';

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
      context.read<ProductProvider>().fetchFeaturedProducts();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.heroGradient,
                ),
              ),
              title: const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontFamily: AppTheme.headlineFont,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.textLight),
                onPressed: () {
                  // Navigate to search
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.shopping_cart, color: AppTheme.textLight),
                onPressed: () {
                  // Navigate to cart
                },
              ),
            ],
          ),

          // Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      Text(
                        authProvider.userModel?.name ?? 'Guest',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Banner Section (Placeholder)
          SliverToBoxAdapter(
            child: Container(
              height: 180,
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius:
                    BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.watch,
                      size: 48,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Premium Watches',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppTheme.textLight,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Up to 30% Off',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories Section (Placeholder)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('All'),
                        _buildCategoryChip('Luxury'),
                        _buildCategoryChip('Sport'),
                        _buildCategoryChip('Classic'),
                        _buildCategoryChip('Smart'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured Products
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Text(
                'Featured Products',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),

          // Products Grid
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              if (productProvider.isLoading &&
                  productProvider.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (productProvider.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No products available'),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(product: product);
                    },
                    childCount: productProvider.products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: AppTheme.accentColor.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

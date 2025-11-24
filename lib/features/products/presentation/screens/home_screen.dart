import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/product_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
import '../../../user_profile/presentation/screens/profile_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
    final screens = [
      _buildHomeContent(),
      const WishlistScreen(),
      const OrderHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _currentIndex == 0 ? _buildHomeContent() : screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

  Widget _buildHomeContent() {
    return CustomScrollView(
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
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppTheme.textLight),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: AppTheme.textLight),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
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

        // Banner Section
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

        // Categories Section
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
            if (productProvider.isLoading && productProvider.products.isEmpty) {
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

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/products/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WatchHubApp());
}

class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(userId: ''),
          update: (_, auth, previous) =>
              CartProvider(userId: auth.user?.uid ?? ''),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WishlistProvider>(
          create: (_) => WishlistProvider(userId: ''),
          update: (_, auth, previous) =>
              WishlistProvider(userId: auth.user?.uid ?? ''),
        ),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'WatchHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: AppConstants.splashRoute,
            routes: {
              AppConstants.splashRoute: (context) => const SplashScreen(),
              AppConstants.signInRoute: (context) => const SignInScreen(),
              AppConstants.homeRoute: (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

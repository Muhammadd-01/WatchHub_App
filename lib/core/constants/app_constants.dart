class AppConstants {
  // App Info
  static const String appName = 'WatchHub';
  static const String appVersion = '1.0.0';

  // Routes
  static const String splashRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String homeRoute = '/home';
  static const String productListRoute = '/products';
  static const String productDetailRoute = '/product-detail';
  static const String searchRoute = '/search';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String orderHistoryRoute = '/orders';
  static const String orderDetailRoute = '/order-detail';
  static const String wishlistRoute = '/wishlist';
  static const String profileRoute = '/profile';
  static const String editProfileRoute = '/edit-profile';
  static const String addressManagementRoute = '/addresses';
  static const String settingsRoute = '/settings';
  static const String reviewsRoute = '/reviews';
  static const String supportRoute = '/support';
  static const String faqRoute = '/faq';
  static const String adminDashboardRoute = '/admin';
  static const String adminProductsRoute = '/admin/products';
  static const String adminOrdersRoute = '/admin/orders';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String wishlistsCollection = 'wishlists';
  static const String cartsCollection = 'carts';
  static const String supportMessagesCollection = 'support_messages';

  // Storage Paths
  static const String productImagesPath = 'products';
  static const String avatarsPath = 'avatars';

  // Pagination
  static const int productsPerPage = 20;
  static const int reviewsPerPage = 10;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double minTapTarget = 44.0;

  // Animation Durations
  static const int splashDuration = 2500; // milliseconds
  static const int pageTransitionDuration = 300;
  static const int microInteractionDuration = 150;

  // Order Status
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusOutForDelivery = 'out_for_delivery';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentCOD = 'Cash on Delivery';
  static const String paymentCard = 'Credit/Debit Card';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication failed. Please try again.';
  static const String errorPermission =
      'You don\'t have permission to perform this action.';
}

# WatchHub — Flutter (iOS & Android)

![WatchHub Logo](assets/images/logo.png)

## Overview

WatchHub is a premium watch shopping mobile app built with Flutter and Firebase. It supports authentication, product browsing, cart and checkout, wishlist, reviews, profile management, and admin features.

## Features

- ✅ **Email/Password Authentication** with password recovery and email verification
- ✅ **Product Browsing** with search, filter, and sort capabilities
- ✅ **Product Details** with zoomable images and hero transitions
- ✅ **Shopping Cart** with quantity management and promo codes
- ✅ **Checkout Flow** with address management
- ✅ **Order Tracking** with status timeline
- ✅ **Wishlist** for saving favorite products
- ✅ **Reviews & Ratings** with user-generated content
- ✅ **User Profiles** with address management
- ✅ **Admin Panel** for product and order management
- ✅ **Dark Mode** support
- ✅ **Offline Persistence** with Firestore caching
- ✅ **Premium UI** with animations and micro-interactions

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Storage
  - Cloud Functions
  - Analytics
  - Crashlytics
- **UI Packages**: 
  - cached_network_image
  - photo_view
  - lottie
  - shimmer
  - flutter_svg

## Project Structure

```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   ├── theme/           # Theme configuration
│   ├── utils/           # Utility functions
│   └── widgets/         # Reusable widgets
├── features/
│   ├── auth/            # Authentication feature
│   ├── products/        # Product browsing & details
│   ├── cart/            # Shopping cart
│   ├── orders/          # Order management
│   ├── profile/         # User profile
│   └── admin/           # Admin panel
├── services/            # Firebase services
└── main.dart            # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Firebase account
- Android Studio / VS Code
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd WatchHub_App
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Follow the detailed instructions in [`firebase_guide.md`](firebase_guide.md)
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

4. **Run the app**:
   ```bash
   flutter run
   ```

## Firebase Configuration

See [`firebase_guide.md`](firebase_guide.md) for complete Firebase setup instructions including:
- Creating a Firebase project
- Registering Android and iOS apps
- Enabling Authentication
- Setting up Firestore and Storage
- Deploying security rules
- Deploying Cloud Functions
- Creating admin users
- Populating sample data

## Building for Release

### Android

```bash
flutter build appbundle --release
```

The release AAB will be located at `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ipa --release
```

The IPA will be located at `build/ios/ipa/`

**Note**: iOS builds require proper code signing and provisioning profiles configured in Xcode.

## Testing

### Run all tests:
```bash
flutter test
```

### Run specific test file:
```bash
flutter test test/unit/auth_service_test.dart
```

### Run with coverage:
```bash
flutter test --coverage
```

## Environment Variables

For sensitive configuration, create a `.env` file (not committed to version control):

```env
FIREBASE_API_KEY=your_api_key
STRIPE_PUBLISHABLE_KEY=your_stripe_key
```

## Project Configuration

### Minimum SDK Versions
- **Android**: minSdkVersion 21 (Android 5.0)
- **iOS**: iOS 12.0+

### Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
- INTERNET
- ACCESS_NETWORK_STATE

**iOS** (`ios/Runner/Info.plist`):
- NSPhotoLibraryUsageDescription
- NSCameraUsageDescription

## Features in Detail

### Authentication
- Email/password sign in and sign up
- Email verification
- Password reset via email
- Persistent authentication state

### Products
- Grid and list view
- Infinite scroll pagination
- Search functionality
- Filter by category, brand, price range
- Sort by price, popularity, rating

### Cart & Checkout
- Add/remove items
- Update quantities
- Apply promo codes
- Calculate shipping and tax
- Multiple shipping addresses
- Order confirmation

### Admin Panel
- Add/edit/delete products
- Upload product images
- Manage stock levels
- Update order status
- View and moderate reviews

## Troubleshooting

### Firebase Issues

**Problem**: `Missing google-services.json`  
**Solution**: Ensure the file is placed in `android/app/` directory

**Problem**: `PERMISSION_DENIED` errors  
**Solution**: Check Firestore security rules and ensure user is authenticated

**Problem**: Images not loading  
**Solution**: Verify Firebase Storage rules and image URLs

### Build Issues

**Problem**: Build fails on iOS  
**Solution**: Run `pod install` in the `ios/` directory

**Problem**: Gradle build fails  
**Solution**: Check `android/build.gradle` and ensure correct versions

## Performance Optimization

- Images are cached using `cached_network_image`
- Firestore offline persistence enabled
- Pagination for large lists
- Lazy loading of images
- Optimized build size with code splitting

## Accessibility

- Minimum tap target size: 44x44 dp
- Color contrast ratio: 4.5:1
- Screen reader support with semantic labels
- Dynamic font sizing support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Email: support@watchhub.com
- Documentation: See `docs/` folder

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend infrastructure
- All contributors and testers

## Roadmap

- [ ] Social authentication (Google, Apple)
- [ ] Real payment gateway integration (Stripe)
- [ ] Push notifications
- [ ] In-app chat support
- [ ] Multi-language support
- [ ] AR try-on feature
- [ ] Apple Watch companion app

---

**Built with ❤️ using Flutter**

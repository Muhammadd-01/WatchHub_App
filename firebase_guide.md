# Firebase Guide — WatchHub

This guide walks through creating a Firebase project, connecting it to the app (Android & iOS), configuring Auth/Firestore/Storage, deploying rules and Cloud Functions.

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add project**
3. Enter project name: `watchhub-app` (or your preferred name)
4. Disable Google Analytics for development (or enable if needed)
5. Click **Create project**

## 2. Register Apps

### Android App

1. In Firebase Console, click the Android icon to add an Android app
2. **Package name**: `com.watchhub.watchhub_app` (must match `android/app/build.gradle`)
3. **App nickname**: WatchHub Android (optional)
4. **Debug signing certificate SHA-1**: (optional, needed for Google Sign-In)
5. Click **Register app**
6. **Download `google-services.json`**
7. Place the file at: `android/app/google-services.json`

**Update Android Configuration**:

Edit `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

Edit `android/app/build.gradle`:
```gradle
// Add at the bottom of the file
apply plugin: 'com.google.gms.google-services'
```

### iOS App

1. In Firebase Console, click the iOS icon to add an iOS app
2. **Bundle ID**: `com.watchhub.watchhubApp` (must match Xcode project)
3. **App nickname**: WatchHub iOS (optional)
4. Click **Register app**
5. **Download `GoogleService-Info.plist`**
6. Open Xcode project: `open ios/Runner.xcworkspace`
7. Drag `GoogleService-Info.plist` into the Runner folder in Xcode
8. Ensure "Copy items if needed" is checked

## 3. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password**
   - Toggle on "Email/Password"
   - Click **Save**
5. (Optional) Enable **Google** sign-in
   - Toggle on "Google"
   - Enter support email
   - Click **Save**

## 4. Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in production mode** (we'll deploy rules later)
4. Select a location closest to your users (e.g., `us-central1`)
5. Click **Enable**

### Create Collections

Firestore will auto-create collections when data is added, but you can create them manually:

1. Click **Start collection**
2. Create these collections:
   - `users`
   - `products`
   - `categories`
   - `orders`
   - `carts`
   - `wishlists`
   - `support_messages`

## 5. Set Up Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Choose **Start in production mode**
4. Use the same location as Firestore
5. Click **Done**

### Create Folders

Create these folders in Storage:
- `products/` - for product images
- `avatars/` - for user profile pictures

## 6. Deploy Security Rules

### Firestore Rules

1. In your project, the rules are in `firestore.rules`
2. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
3. Login to Firebase:
   ```bash
   firebase login
   ```
4. Initialize Firebase in your project:
   ```bash
   firebase init
   ```
   - Select **Firestore** and **Functions** and **Storage**
   - Choose your Firebase project
   - Accept default file names
5. Deploy Firestore rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

### Storage Rules

Deploy Storage rules:
```bash
firebase deploy --only storage
```

## 7. Set Up Cloud Functions

1. Navigate to functions directory:
   ```bash
   cd functions
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Deploy functions:
   ```bash
   firebase deploy --only functions
   ```

### Available Functions

- `onOrderCreated` - Decreases product stock when order is placed
- `onReviewCreated` - Updates product rating when review is added
- `onReviewDeleted` - Updates product rating when review is deleted
- `onUserDeleted` - Cleans up user data when account is deleted

## 8. Create Firestore Indexes

Some queries require composite indexes. Firestore will provide links to create them when you run queries that need them.

To create indexes manually:
1. Go to **Firestore Database** → **Indexes** tab
2. Click **Create index**
3. Add required fields and sort orders

Common indexes needed:
- Collection: `products`, Fields: `categoryId` (Ascending), `createdAt` (Descending)
- Collection: `products`, Fields: `isFeatured` (Ascending), `createdAt` (Descending)

## 9. Populate Sample Data

### Option 1: Manual Entry (Firebase Console)

1. Go to **Firestore Database**
2. Click on `products` collection
3. Click **Add document**
4. Add sample product data

### Option 2: Using Script (Recommended)

Create a script `scripts/populate_firestore.js`:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Sample products
const products = [
  {
    title: 'Chrono Classic 42mm',
    brand: 'Luxury Brand',
    type: 'Automatic',
    price: 349.99,
    currency: 'USD',
    images: ['https://example.com/watch1.jpg'],
    specs: {
      caseMaterial: 'Stainless Steel',
      waterResistance: '50m',
      movement: 'Automatic',
      band: 'Leather'
    },
    stock: 12,
    rating: 4.6,
    numRatings: 324,
    categoryId: 'men_classics',
    isFeatured: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    description: 'A timeless classic watch with automatic movement.'
  },
  // Add more products...
];

async function populateData() {
  for (const product of products) {
    await db.collection('products').add(product);
  }
  console.log('Sample data added!');
}

populateData();
```

Run the script:
```bash
node scripts/populate_firestore.js
```

## 10. Create Admin User

To create an admin user:

1. Sign up a user through the app
2. Go to **Firestore Database**
3. Find the user in the `users` collection
4. Edit the document and set `isAdmin: true`

Alternatively, use Firebase Console:
```javascript
// In Firebase Console → Firestore
// Find user document and update:
{
  "isAdmin": true
}
```

## 11. Enable Analytics & Crashlytics

### Analytics

1. Go to **Analytics** in Firebase Console
2. Click **Enable Google Analytics**
3. Follow the setup wizard

### Crashlytics

1. Go to **Crashlytics** in Firebase Console
2. Click **Enable Crashlytics**
3. The Flutter app is already configured with the package

## 12. Local Testing with Emulators

For local development and testing:

1. Install emulators:
   ```bash
   firebase init emulators
   ```
2. Select: Firestore, Authentication, Storage, Functions
3. Start emulators:
   ```bash
   firebase emulators:start
   ```
4. Access emulator UI at: `http://localhost:4000`

## 13. Environment Configuration

### Development vs Production

Create different Firebase projects for dev and prod:
- `watchhub-dev` - Development
- `watchhub-prod` - Production

Use FlutterFire CLI to switch between environments:
```bash
flutterfire configure
```

## 14. Security Checklist

Before going to production:

- [ ] Firestore rules deployed and tested
- [ ] Storage rules deployed and tested
- [ ] Authentication email verification enabled
- [ ] Admin users properly configured
- [ ] Cloud Functions deployed
- [ ] Analytics enabled
- [ ] Crashlytics enabled
- [ ] App Check enabled (optional but recommended)
- [ ] Billing account set up (for production usage)

## 15. Useful Firebase CLI Commands

```bash
# View logs
firebase functions:log

# Deploy everything
firebase deploy

# Deploy specific service
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only storage

# Test security rules
firebase emulators:start --only firestore
```

## 16. Troubleshooting

### Common Issues

**Issue**: `Missing google-services.json`  
**Solution**: Ensure file is in `android/app/` directory

**Issue**: `PERMISSION_DENIED` in Firestore  
**Solution**: Check security rules and user authentication

**Issue**: Functions not triggering  
**Solution**: Check Firebase Console → Functions logs

**Issue**: Storage upload fails  
**Solution**: Verify storage rules and file size limits

### Getting Help

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Firebase Support](https://firebase.google.com/support)

## 17. Cost Management

### Free Tier Limits

- **Firestore**: 50K reads, 20K writes, 20K deletes per day
- **Storage**: 5GB storage, 1GB download per day
- **Functions**: 125K invocations, 40K GB-seconds per month
- **Authentication**: Unlimited

### Monitoring Usage

1. Go to **Usage and billing** in Firebase Console
2. Set up budget alerts
3. Monitor daily usage

### Optimization Tips

- Use Firestore offline persistence
- Implement pagination
- Cache images locally
- Optimize Cloud Functions cold starts
- Use Cloud Storage CDN

---

## Next Steps

1. Complete Firebase setup following this guide
2. Run `flutter pub get` to install dependencies
3. Run the app: `flutter run`
4. Test authentication flow
5. Add sample products
6. Test all features

For any issues, refer to the main [README.md](README.md) or create an issue in the repository.

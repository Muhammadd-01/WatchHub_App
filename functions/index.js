const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Triggered when a new order is created
exports.onOrderCreated = functions.firestore
    .document('orders/{orderId}')
    .onCreate(async (snap, context) => {
        const order = snap.data();
        const orderId = context.params.orderId;

        try {
            // Decrease product stock for each item in the order
            const batch = admin.firestore().batch();

            for (const item of order.items) {
                const productRef = admin.firestore()
                    .collection('products')
                    .doc(item.productId);

                // Decrement stock
                batch.update(productRef, {
                    stock: admin.firestore.FieldValue.increment(-item.quantity),
                });
            }

            await batch.commit();

            console.log(`Order ${orderId} processed. Stock updated.`);

            // TODO: Send email notification to customer
            // TODO: Send notification to admin
            // You can integrate with SendGrid, Mailgun, or Firebase Extensions

            return null;
        } catch (error) {
            console.error('Error processing order:', error);
            return null;
        }
    });

// Triggered when a review is created
exports.onReviewCreated = functions.firestore
    .document('products/{productId}/reviews/{reviewId}')
    .onCreate(async (snap, context) => {
        const review = snap.data();
        const productId = context.params.productId;

        try {
            const productRef = admin.firestore()
                .collection('products')
                .doc(productId);

            // Get all reviews for this product
            const reviewsSnapshot = await admin.firestore()
                .collection('products')
                .doc(productId)
                .collection('reviews')
                .get();

            // Calculate new average rating
            let totalRating = 0;
            let count = 0;

            reviewsSnapshot.forEach((doc) => {
                totalRating += doc.data().rating;
                count++;
            });

            const averageRating = count > 0 ? totalRating / count : 0;

            // Update product with new rating
            await productRef.update({
                rating: averageRating,
                numRatings: count,
            });

            console.log(`Product ${productId} rating updated to ${averageRating}`);

            return null;
        } catch (error) {
            console.error('Error updating product rating:', error);
            return null;
        }
    });

// Triggered when a review is deleted
exports.onReviewDeleted = functions.firestore
    .document('products/{productId}/reviews/{reviewId}')
    .onDelete(async (snap, context) => {
        const productId = context.params.productId;

        try {
            const productRef = admin.firestore()
                .collection('products')
                .doc(productId);

            // Get all remaining reviews for this product
            const reviewsSnapshot = await admin.firestore()
                .collection('products')
                .doc(productId)
                .collection('reviews')
                .get();

            // Calculate new average rating
            let totalRating = 0;
            let count = 0;

            reviewsSnapshot.forEach((doc) => {
                totalRating += doc.data().rating;
                count++;
            });

            const averageRating = count > 0 ? totalRating / count : 0;

            // Update product with new rating
            await productRef.update({
                rating: averageRating,
                numRatings: count,
            });

            console.log(`Product ${productId} rating updated after review deletion`);

            return null;
        } catch (error) {
            console.error('Error updating product rating:', error);
            return null;
        }
    });

// Clean up user data when account is deleted
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
    const uid = user.uid;

    try {
        const batch = admin.firestore().batch();

        // Delete user document
        const userRef = admin.firestore().collection('users').doc(uid);
        batch.delete(userRef);

        // Delete user's cart
        const cartRef = admin.firestore().collection('carts').doc(uid);
        batch.delete(cartRef);

        // Delete user's wishlist
        const wishlistRef = admin.firestore().collection('wishlists').doc(uid);
        batch.delete(wishlistRef);

        await batch.commit();

        console.log(`User ${uid} data cleaned up`);

        return null;
    } catch (error) {
        console.error('Error cleaning up user data:', error);
        return null;
    }
});

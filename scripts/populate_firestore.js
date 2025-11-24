const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin
// You need to download your service account key from Firebase Console
// and save it as serviceAccountKey.json in the scripts folder
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function populateFirestore() {
    try {
        // Read sample data
        const dataPath = path.join(__dirname, 'sample_data.json');
        const rawData = fs.readFileSync(dataPath);
        const data = JSON.parse(rawData);

        console.log('Starting to populate Firestore...');

        // Add categories
        console.log('\nAdding categories...');
        for (const category of data.categories) {
            const { id, ...categoryData } = category;
            await db.collection('categories').doc(id).set(categoryData);
            console.log(`✓ Added category: ${category.name}`);
        }

        // Add products
        console.log('\nAdding products...');
        for (const product of data.products) {
            const productData = {
                ...product,
                createdAt: admin.firestore.FieldValue.serverTimestamp()
            };
            const docRef = await db.collection('products').add(productData);
            console.log(`✓ Added product: ${product.title} (ID: ${docRef.id})`);
        }

        console.log('\n✅ Firestore population completed successfully!');
        console.log(`\nSummary:`);
        console.log(`- Categories added: ${data.categories.length}`);
        console.log(`- Products added: ${data.products.length}`);

    } catch (error) {
        console.error('❌ Error populating Firestore:', error);
    } finally {
        process.exit();
    }
}

// Run the script
populateFirestore();

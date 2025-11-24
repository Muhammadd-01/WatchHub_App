const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Firebase Admin
// NOTE: In a real production environment, you would use a service account key file.
// For this setup, we'll assume the user will provide the credentials or we use default app credentials if running in a Google environment.
// For local development without a key file, we can try to use a placeholder or ask the user to provide the service account JSON.

// Placeholder for service account - USER MUST REPLACE THIS WITH REAL CREDENTIALS
// const serviceAccount = require('./serviceAccountKey.json');

try {
    admin.initializeApp({
        credential: admin.credential.applicationDefault(), // Or use cert(serviceAccount)
    });
    console.log('Firebase Admin Initialized');
} catch (error) {
    console.error('Firebase Admin Initialization Error:', error);
}

const db = admin.firestore();

// Routes

// GET All Users
app.get('/api/users', async (req, res) => {
    try {
        const usersSnapshot = await db.collection('users').get();
        const users = [];
        usersSnapshot.forEach(doc => {
            users.push({ id: doc.id, ...doc.data() });
        });
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET All Products
app.get('/api/products', async (req, res) => {
    try {
        const productsSnapshot = await db.collection('products').get();
        const products = [];
        productsSnapshot.forEach(doc => {
            products.push({ id: doc.id, ...doc.data() });
        });
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST Add Product
app.post('/api/products', async (req, res) => {
    try {
        const newProduct = req.body;
        const docRef = await db.collection('products').add(newProduct);
        res.status(201).json({ id: docRef.id, ...newProduct });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET All Orders
app.get('/api/orders', async (req, res) => {
    try {
        const ordersSnapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
        const orders = [];
        ordersSnapshot.forEach(doc => {
            orders.push({ id: doc.id, ...doc.data() });
        });
        res.json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET Seller Applications
app.get('/api/seller-applications', async (req, res) => {
    try {
        const appsSnapshot = await db.collection('seller_applications').orderBy('createdAt', 'desc').get();
        const apps = [];
        appsSnapshot.forEach(doc => {
            apps.push({ id: doc.id, ...doc.data() });
        });
        res.json(apps);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

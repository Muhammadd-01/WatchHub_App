import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Dashboard = () => {
    const [stats, setStats] = useState({
        users: 0,
        products: 0,
        orders: 0,
        revenue: 0
    });

    useEffect(() => {
        // Fetch stats from API (mocking for now or fetching all and counting)
        const fetchData = async () => {
            try {
                const [usersRes, productsRes, ordersRes] = await Promise.all([
                    axios.get('http://localhost:5000/api/users'),
                    axios.get('http://localhost:5000/api/products'),
                    axios.get('http://localhost:5000/api/orders')
                ]);

                setStats({
                    users: usersRes.data.length,
                    products: productsRes.data.length,
                    orders: ordersRes.data.length,
                    revenue: ordersRes.data.reduce((acc, order) => acc + (order.total || 0), 0)
                });
            } catch (error) {
                console.error("Error fetching dashboard data", error);
            }
        };

        fetchData();
    }, []);

    return (
        <div>
            <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <StatCard title="Total Users" value={stats.users} icon="👥" color="bg-blue-500" />
                <StatCard title="Total Products" value={stats.products} icon="⌚" color="bg-green-500" />
                <StatCard title="Total Orders" value={stats.orders} icon="📦" color="bg-orange-500" />
                <StatCard title="Total Revenue" value={`$${stats.revenue.toFixed(2)}`} icon="💰" color="bg-purple-500" />
            </div>
        </div>
    );
};

const StatCard = ({ title, value, icon, color }) => (
    <div className="bg-white rounded-lg shadow-md p-6 flex items-center">
        <div className={`p-3 rounded-full ${color} text-white mr-4 text-2xl`}>
            {icon}
        </div>
        <div>
            <p className="text-gray-500 text-sm">{title}</p>
            <p className="text-2xl font-bold">{value}</p>
        </div>
    </div>
);

export default Dashboard;

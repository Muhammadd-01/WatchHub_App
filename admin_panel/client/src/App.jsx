import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import Products from './pages/Products';
import Orders from './pages/Orders';
// import SellerApplications from './pages/SellerApplications';

function App() {
    return (
        <Router>
            <div className="flex h-screen bg-gray-100">
                {/* Sidebar */}
                <div className="w-64 bg-primary text-white flex flex-col">
                    <div className="p-6 text-2xl font-bold text-accent">WatchHub Admin</div>
                    <nav className="flex-1 p-4 space-y-2">
                        <Link to="/" className="block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700 hover:text-white">
                            Dashboard
                        </Link>
                        <Link to="/users" className="block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700 hover:text-white">
                            Users
                        </Link>
                        <Link to="/products" className="block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700 hover:text-white">
                            Products
                        </Link>
                        <Link to="/orders" className="block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700 hover:text-white">
                            Orders
                        </Link>
                        {/* <Link to="/applications" className="block py-2.5 px-4 rounded transition duration-200 hover:bg-gray-700 hover:text-white">
                            Seller Apps
                        </Link> */}
                    </nav>
                </div>

                {/* Main Content */}
                <div className="flex-1 overflow-y-auto p-8">
                    <Routes>
                        <Route path="/" element={<Dashboard />} />
                        <Route path="/users" element={<Users />} />
                        <Route path="/products" element={<Products />} />
                        <Route path="/orders" element={<Orders />} />
                        {/* <Route path="/applications" element={<SellerApplications />} /> */}
                    </Routes>
                </div>
            </div>
        </Router>
    );
}

export default App;

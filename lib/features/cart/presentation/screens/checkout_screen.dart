import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/models/user_model.dart';
import '../providers/cart_provider.dart';
import '../../../orders/domain/models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  String _paymentMethod = AppConstants.paymentCOD;
  bool _isPlacingOrder = false;

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final cartProvider = context.read<CartProvider>();

      final order = OrderModel(
        id: '',
        userId: authProvider.user!.uid,
        items: cartProvider.items
            .map((item) => OrderItem(
                  productId: item.productId,
                  title: item.title,
                  price: item.price,
                  quantity: item.quantity,
                  image: item.image,
                ))
            .toList(),
        subtotal: cartProvider.subtotal,
        shipping: cartProvider.shipping,
        tax: cartProvider.tax,
        total: cartProvider.total,
        shippingAddress: _selectedAddress!,
        paymentMethod: _paymentMethod,
        status: AppConstants.orderStatusProcessing,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save order to Firestore
      await FirebaseFirestore.instance
          .collection(AppConstants.ordersCollection)
          .add(order.toFirestore());

      // Clear cart
      await cartProvider.clearCart();

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Order Placed!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your order has been placed successfully!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: \$${cartProvider.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer2<AuthProvider, CartProvider>(
        builder: (context, authProvider, cartProvider, _) {
          final user = authProvider.userModel;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                if (user?.addresses.isEmpty ?? true)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('No addresses found'),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              // Navigate to add address screen
                            },
                            child: const Text('Add Address'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...user!.addresses.map((address) {
                    return RadioListTile<Address>(
                      value: address,
                      groupValue: _selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          _selectedAddress = value;
                        });
                      },
                      title: Text(address.label),
                      subtitle: Text(address.fullAddress),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Theme.of(context).cardColor,
                    );
                  }).toList(),
                const SizedBox(height: 24),

                // Payment Method
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                RadioListTile<String>(
                  value: AppConstants.paymentCOD,
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  title: const Text('Cash on Delivery'),
                  subtitle: const Text('Pay when you receive'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Theme.of(context).cardColor,
                ),
                const SizedBox(height: 24),

                // Order Summary
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items'),
                            Text('${cartProvider.itemCount}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text(
                                '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shipping'),
                            Text(
                                '\$${cartProvider.shipping.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tax'),
                            Text('\$${cartProvider.tax.toStringAsFixed(2)}'),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              '\$${cartProvider.total.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: AppTheme.accentColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isPlacingOrder ? null : _placeOrder,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.textLight,
                                ),
                              ),
                            )
                          : const Text('Place Order'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

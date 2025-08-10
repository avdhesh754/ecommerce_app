import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../shared/models/cart_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../core/network/api_client.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final ApiClient _apiClient = Get.find<ApiClient>();

  // Observable variables
  final Rx<CartModel?> _cart = Rx<CartModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Getters
  CartModel? get cart => _cart.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  int get itemCount => cart?.itemCount ?? 0;
  double get subtotal => cart?.subtotal ?? 0.0;
  double get tax => cart?.tax ?? 0.0;
  double get shipping => cart?.shipping ?? 0.0;
  double get total => cart?.total ?? 0.0;
  bool get isEmpty => cart?.isEmpty ?? true;
  bool get isNotEmpty => cart?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // Load cart from API
  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.get(ApiEndpoints.cart);

      if (response.statusCode == 200) {
        final cartData = response.data['data'] ?? response.data;
        if (cartData != null) {
          _cart.value = CartModel.fromJson(cartData);
        } else {
          _cart.value = null;
        }
      } else {
        _setError('Failed to load cart');
      }
    } catch (e) {
      _setError('Error loading cart: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add item to cart
  Future<bool> addToCart(ProductModel product, {int quantity = 1}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.post(
        ApiEndpoints.cart,
        data: {
          'productId': product.id,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final cartData = response.data['data'] ?? response.data;
        _cart.value = CartModel.fromJson(cartData);
        
        Get.showSnackbar(GetSnackBar(
          message: '${product.name} added to cart',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError('Failed to add item to cart');
        return false;
      }
    } catch (e) {
      _setError('Error adding to cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update item quantity
  Future<bool> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      return removeFromCart(itemId);
    }

    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.cart}/$itemId',
        data: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        final cartData = response.data['data'] ?? response.data;
        _cart.value = CartModel.fromJson(cartData);
        return true;
      } else {
        _setError('Failed to update quantity');
        return false;
      }
    } catch (e) {
      _setError('Error updating quantity: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String itemId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.delete('${ApiEndpoints.cart}/$itemId');

      if (response.statusCode == 200) {
        final cartData = response.data['data'] ?? response.data;
        if (cartData != null) {
          _cart.value = CartModel.fromJson(cartData);
        } else {
          _cart.value = null;
        }
        
        Get.showSnackbar(const GetSnackBar(
          message: 'Item removed from cart',
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError('Failed to remove item');
        return false;
      }
    } catch (e) {
      _setError('Error removing item: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear entire cart
  Future<bool> clearCart() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.delete(ApiEndpoints.cart);

      if (response.statusCode == 200) {
        _cart.value = null;
        
        Get.showSnackbar(const GetSnackBar(
          message: 'Cart cleared',
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError('Failed to clear cart');
        return false;
      }
    } catch (e) {
      _setError('Error clearing cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get item quantity for a specific product
  int getItemQuantity(String productId) {
    if (cart == null) return 0;
    
    final item = cart!.items.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    
    return item?.quantity ?? 0;
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return getItemQuantity(productId) > 0;
  }

  // Refresh cart
  Future<void> refreshCart() async {
    await loadCart();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _error.value = error;
    if (error.isNotEmpty) {
      Get.showSnackbar(GetSnackBar(
        message: error,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      ));
    }
  }

  void _clearError() {
    _error.value = '';
  }
}
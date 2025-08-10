import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../shared/models/product_model.dart';
import '../data/product_repository.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();

  final ProductRepository _repository = ProductRepository();

  // Observable variables
  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _sortBy = 'name'.obs;
  final RxString _sortOrder = 'asc'.obs;
  final RxInt _currentPage = 1.obs;
  final RxInt _totalPages = 1.obs;
  final RxBool _hasNextPage = false.obs;

  // Getters
  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  String get sortBy => _sortBy.value;
  String get sortOrder => _sortOrder.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  bool get hasNextPage => _hasNextPage.value;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }

  // Load products with current filters
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _products.clear();
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getProducts(
        page: currentPage,
        search: searchQuery.isNotEmpty ? searchQuery : null,
        category: selectedCategory.isNotEmpty ? selectedCategory : null,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (result.isSuccess && result.data != null) {
        if (refresh) {
          _products.value = result.data!.products;
        } else {
          _products.addAll(result.data!.products);
        }
        
        _totalPages.value = result.data!.totalPages;
        _hasNextPage.value = result.data!.hasNextPage;
      } else {
        _setError(result.error ?? 'Failed to load products');
      }
    } catch (e) {
      _setError('Error loading products: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load more products for pagination
  Future<void> loadMoreProducts() async {
    if (!hasNextPage || isLoadingMore) return;

    _setLoadingMore(true);
    _currentPage.value++;

    try {
      final result = await _repository.getProducts(
        page: currentPage,
        search: searchQuery.isNotEmpty ? searchQuery : null,
        category: selectedCategory.isNotEmpty ? selectedCategory : null,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (result.isSuccess && result.data != null) {
        _products.addAll(result.data!.products);
        _hasNextPage.value = result.data!.hasNextPage;
      } else {
        _currentPage.value--; // Revert page increment on error
        _setError(result.error ?? 'Failed to load more products');
      }
    } catch (e) {
      _currentPage.value--; // Revert page increment on error
      _setError('Error loading more products: $e');
    } finally {
      _setLoadingMore(false);
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final result = await _repository.getCategories();
      if (result.isSuccess && result.data != null) {
        _categories.value = result.data!;
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery.value = query;
    loadProducts(refresh: true);
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory.value = category;
    loadProducts(refresh: true);
  }

  // Sort products
  void sortProducts(String sortBy, String sortOrder) {
    _sortBy.value = sortBy;
    _sortOrder.value = sortOrder;
    loadProducts(refresh: true);
  }

  // Clear filters
  void clearFilters() {
    _searchQuery.value = '';
    _selectedCategory.value = '';
    _sortBy.value = 'name';
    _sortOrder.value = 'asc';
    loadProducts(refresh: true);
  }

  // Get single product
  Future<ProductModel?> getProduct(String id) async {
    try {
      final result = await _repository.getProduct(id);
      if (result.isSuccess && result.data != null) {
        return result.data;
      } else {
        _setError(result.error ?? 'Failed to load product');
        return null;
      }
    } catch (e) {
      _setError('Error loading product: $e');
      return null;
    }
  }

  // Create product
  Future<bool> createProduct(Map<String, dynamic> productData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.createProduct(productData);
      if (result.isSuccess && result.data != null) {
        _products.insert(0, result.data!);
        _setLoading(false);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'Product created successfully',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to create product');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error creating product: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(String id, Map<String, dynamic> productData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.updateProduct(id, productData);
      if (result.isSuccess && result.data != null) {
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = result.data!;
        }
        _setLoading(false);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'Product updated successfully',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to update product');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error updating product: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      final result = await _repository.deleteProduct(id);
      if (result.isSuccess) {
        _products.removeWhere((p) => p.id == id);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'Product deleted successfully',
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to delete product');
        return false;
      }
    } catch (e) {
      _setError('Error deleting product: $e');
      return false;
    }
  }

  // Upload image
  Future<String?> uploadImage(String filePath) async {
    try {
      final result = await _repository.uploadImage(filePath);
      if (result.isSuccess && result.data != null) {
        return result.data;
      } else {
        _setError(result.error ?? 'Failed to upload image');
        return null;
      }
    } catch (e) {
      _setError('Error uploading image: $e');
      return null;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
    Get.showSnackbar(const GetSnackBar(
      message: 'Products refreshed',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    ));
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore.value = loading;
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
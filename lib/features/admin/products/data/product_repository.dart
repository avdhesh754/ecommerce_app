import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/api_result.dart';
import '../../../../shared/models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Get all products with pagination
  Future<ApiResult<ProductListResponse>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
      };

      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = ProductListResponse.fromJson(response.data);
        return ApiResult.success(data);
      } else {
        return ApiResult.failure('Failed to load products');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get single product by ID
  Future<ApiResult<ProductModel>> getProduct(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.products}/$id');

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(product);
      } else {
        return ApiResult.failure('Failed to load product');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Create new product
  Future<ApiResult<ProductModel>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.products,
        data: productData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final product = ProductModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(product);
      } else {
        return ApiResult.failure('Failed to create product');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Update product
  Future<ApiResult<ProductModel>> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.products}/$id',
        data: productData,
      );

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(product);
      } else {
        return ApiResult.failure('Failed to update product');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Delete product
  Future<ApiResult<bool>> deleteProduct(String id) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.products}/$id');

      if (response.statusCode == 200) {
        return ApiResult.success(true);
      } else {
        return ApiResult.failure('Failed to delete product');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get categories
  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = response.data['data'] ?? response.data;
        final categories = categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        return ApiResult.success(categories);
      } else {
        return ApiResult.failure('Failed to load categories');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Upload product image
  Future<ApiResult<String>> uploadImage(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.upload(
        ApiEndpoints.uploadImage,
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final imageUrl = response.data['data']['url'] ?? response.data['url'];
        return ApiResult.success(imageUrl);
      } else {
        return ApiResult.failure('Failed to upload image');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }
}

class ProductListResponse {
  final List<ProductModel> products;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ProductListResponse({
    required this.products,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productsJson = json['data'] ?? json['products'] ?? [];
    final products = productsJson.map((json) => ProductModel.fromJson(json)).toList();

    return ProductListResponse(
      products: products,
      totalCount: json['totalCount'] ?? json['total'] ?? 0,
      currentPage: json['currentPage'] ?? json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  const ApiResult({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory ApiResult.success(T data) {
    return ApiResult(isSuccess: true, data: data);
  }

  factory ApiResult.failure(String error) {
    return ApiResult(isSuccess: false, error: error);
  }
}
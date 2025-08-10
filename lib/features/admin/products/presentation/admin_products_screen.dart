import 'package:cosmetic_ecommerce_app/core/utils/responsive_breakpoints.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product_model.dart';
import '../controllers/product_controller.dart';
import 'product_form_screen.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize product controller
    Get.put(ProductController());
    final productController = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, productController),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
            
            // Filters
            _buildFilters(context, productController),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 16.0)),
            
            // Products table
            Expanded(
              child: _buildProductsTable(context, productController),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(context, productController),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProductController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Management',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: 4),
            Obx(() => Text(
              '${controller.products.length} products',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            )),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: controller.refreshProducts,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _showProductForm(context, controller),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Product'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, ProductController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Search field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: controller.searchProducts,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Category filter
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedCategory.isEmpty 
                        ? null 
                        : controller.selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('All Categories'),
                      ),
                      ...controller.categories.map((category) =>
                        DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => controller.filterByCategory(value ?? ''),
                  )),
                ),
                
                SizedBox(width: 16),
                
                // Sort dropdown
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: '${controller.sortBy}-${controller.sortOrder}',
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'name-asc',
                        child: Text('Name A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'name-desc',
                        child: Text('Name Z-A'),
                      ),
                      DropdownMenuItem(
                        value: 'price-asc',
                        child: Text('Price Low-High'),
                      ),
                      DropdownMenuItem(
                        value: 'price-desc',
                        child: Text('Price High-Low'),
                      ),
                      DropdownMenuItem(
                        value: 'createdAt-desc',
                        child: Text('Newest First'),
                      ),
                      DropdownMenuItem(
                        value: 'createdAt-asc',
                        child: Text('Oldest First'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        final parts = value.split('-');
                        controller.sortProducts(parts[0], parts[1]);
                      }
                    },
                  )),
                ),
                
                SizedBox(width: 16),
                
                // Clear filters button
                TextButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTable(BuildContext context, ProductController controller) {
    return Obx(() {
      if (controller.isLoading && controller.products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppTheme.textLight,
              ),
              SizedBox(height: 16),
              Text(
                'No products found',
                style: AppTextStyles.heading4.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your first product to get started',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        );
      }

      return Card(
        child: Column(
          children: [
            Expanded(
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 800,
                columns: const [
                  DataColumn2(
                    label: Text('Product'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Category'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Price'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Stock'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Status'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Actions'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: controller.products.map((product) {
                  return DataRow2(
                    cells: [
                      DataCell(_buildProductCell(product)),
                      DataCell(Text(product.category)),
                      DataCell(_buildPriceCell(product)),
                      DataCell(_buildStockCell(product)),
                      DataCell(_buildStatusCell(product)),
                      DataCell(_buildActionsCell(context, product, controller)),
                    ],
                  );
                }).toList(),
              ),
            ),
            
            // Pagination
            if (controller.totalPages > 1)
              _buildPagination(controller),
          ],
        ),
      );
    });
  }

  Widget _buildProductCell(ProductModel product) {
    return Row(
      children: [
        // Product image
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.backgroundColor,
          ),
          child: product.imageUrl != null && product.imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag,
                        color: AppTheme.textSecondary,
                        size: 20,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.shopping_bag,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
        ),
        SizedBox(width: 12),
        
        // Product name and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (product.brand != null && product.brand!.isNotEmpty) ...[
                SizedBox(height: 2),
                Text(
                  product.brand!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCell(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.priceText,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (product.hasDiscount) ...[
          SizedBox(height: 2),
          Text(
            product.originalPriceText,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStockCell(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.stockQuantity.toString(),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2),
        Text(
          product.stockStatus,
          style: AppTextStyles.bodySmall.copyWith(
            color: product.isInStock ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCell(ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: product.isActive ? Colors.green.withAlpha(51) : Colors.red.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        product.isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.bodySmall.copyWith(
          color: product.isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, ProductModel product, ProductController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _showProductForm(context, controller, product: product),
          icon: Icon(Icons.edit, size: 18),
          tooltip: 'Edit',
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          onPressed: () => _confirmDelete(context, product, controller),
          icon: Icon(Icons.delete, size: 18, color: Colors.red),
          tooltip: 'Delete',
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildPagination(ProductController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${controller.currentPage} of ${controller.totalPages}',
            style: AppTextStyles.bodyMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: controller.currentPage > 1
                    ? () => controller.loadProducts(refresh: true)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: controller.hasNextPage
                    ? controller.loadMoreProducts
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductForm(BuildContext context, ProductController controller, {ProductModel? product}) {
    Get.to(() => ProductFormScreen(product: product));
  }

  void _confirmDelete(BuildContext context, ProductModel product, ProductController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(product.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
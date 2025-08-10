import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../shared/models/order_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
            
            // Filters
            _buildFilters(context),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 16.0)),
            
            // Orders table
            Expanded(
              child: _buildOrdersTable(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Management',
              style: context.headlineLarge,
            ),
            SizedBox(height: 4),
            Text(
              'Manage and track customer orders',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
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
                      hintText: 'Search orders...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Status filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text('All Status'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'confirmed',
                        child: Text('Confirmed'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'processing',
                        child: Text('Processing'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'shipped',
                        child: Text('Shipped'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'delivered',
                        child: Text('Delivered'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'cancelled',
                        child: Text('Cancelled'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Date range
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.date_range),
                    label: Text('Date Range'),
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Clear filters button
                TextButton.icon(
                  onPressed: () {},
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

  Widget _buildOrdersTable(BuildContext context) {
    // Sample data - replace with actual data from controller
    final sampleOrders = _generateSampleOrders();

    return Card(
      child: Column(
        children: [
          Expanded(
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 1000,
              columns: const [
                DataColumn2(
                  label: Text('Order ID'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Customer'),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Items'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Total'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Status'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Payment'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Date'),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('Actions'),
                  size: ColumnSize.S,
                ),
              ],
              rows: sampleOrders.map((order) {
                return DataRow2(
                  cells: [
                    DataCell(_buildOrderIdCell(order)),
                    DataCell(_buildCustomerCell(order)),
                    DataCell(_buildItemsCell(order)),
                    DataCell(_buildTotalCell(order)),
                    DataCell(_buildStatusCell(order)),
                    DataCell(_buildPaymentCell(order)),
                    DataCell(_buildDateCell(order)),
                    DataCell(_buildActionsCell(context, order)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderIdCell(OrderModel order) {
    return Text(
      '#${order.id.substring(0, 8)}',
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildCustomerCell(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          order.customerName,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2),
        Text(
          order.customerEmail,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildItemsCell(OrderModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${order.itemCount} items',
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTotalCell(OrderModel order) {
    return Text(
      '\$${order.totalAmount.toStringAsFixed(2)}',
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildStatusCell(OrderModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(order.status).withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        order.statusDisplayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: _getStatusColor(order.status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentCell(OrderModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPaymentStatusColor(order.paymentStatus).withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        order.paymentStatusDisplayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: _getPaymentStatusColor(order.paymentStatus),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDateCell(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('MMM dd, yyyy').format(order.createdAt),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          DateFormat('HH:mm').format(order.createdAt),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCell(BuildContext context, OrderModel order) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 18),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.visibility, size: 16),
            title: Text('View Details'),
            dense: true,
          ),
        ),
        PopupMenuItem<String>(
          value: 'update',
          child: ListTile(
            leading: Icon(Icons.edit, size: 16),
            title: Text('Update Status'),
            dense: true,
          ),
        ),
        if (order.status != 'cancelled' && order.status != 'delivered')
          PopupMenuItem<String>(
            value: 'cancel',
            child: ListTile(
              leading: Icon(Icons.cancel, size: 16, color: Colors.red),
              title: Text('Cancel Order', style: TextStyle(color: Colors.red)),
              dense: true,
            ),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showOrderDetails(context, order);
            break;
          case 'update':
            _showUpdateStatusDialog(context, order);
            break;
          case 'cancel':
            _confirmCancelOrder(context, order);
            break;
        }
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.indigo;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.brown;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.brown;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    Get.showSnackbar(GetSnackBar(
      message: 'Order Details - Coming Soon',
      backgroundColor: AppTheme.primaryColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    ));
  }

  void _showUpdateStatusDialog(BuildContext context, OrderModel order) {
    Get.showSnackbar(GetSnackBar(
      message: 'Update Status - Coming Soon',
      backgroundColor: AppTheme.primaryColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    ));
  }

  void _confirmCancelOrder(BuildContext context, OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order #${order.id.substring(0, 8)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.showSnackbar(const GetSnackBar(
                message: 'Order cancelled successfully',
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  List<OrderModel> _generateSampleOrders() {
    // Sample order data for demonstration
    return [
      OrderModel(
        id: '12345678-1234-1234-1234-123456789012',
        customerId: 'cust-001',
        customerName: 'John Doe',
        customerEmail: 'john.doe@example.com',
        totalAmount: 89.99,
        taxAmount: 7.20,
        shippingAmount: 9.99,
        status: 'pending',
        paymentMethod: 'Credit Card',
        paymentStatus: 'paid',
        items: [],
        shippingAddress: AddressModel(
          firstName: 'John',
          lastName: 'Doe',
          street: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
        ),
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      OrderModel(
        id: '12345678-1234-1234-1234-123456789013',
        customerId: 'cust-002',
        customerName: 'Jane Smith',
        customerEmail: 'jane.smith@example.com',
        totalAmount: 125.50,
        taxAmount: 10.04,
        shippingAmount: 12.99,
        status: 'shipped',
        paymentMethod: 'PayPal',
        paymentStatus: 'paid',
        items: [],
        shippingAddress: AddressModel(
          firstName: 'Jane',
          lastName: 'Smith',
          street: '456 Oak Ave',
          city: 'Los Angeles',
          state: 'CA',
          zipCode: '90210',
          country: 'USA',
        ),
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(hours: 6)),
        shippedAt: DateTime.now().subtract(Duration(hours: 6)),
        trackingNumber: 'TRK123456789',
      ),
      OrderModel(
        id: '12345678-1234-1234-1234-123456789014',
        customerId: 'cust-003',
        customerName: 'Bob Johnson',
        customerEmail: 'bob.johnson@example.com',
        totalAmount: 199.99,
        taxAmount: 16.00,
        shippingAmount: 0.00,
        status: 'delivered',
        paymentMethod: 'Credit Card',
        paymentStatus: 'paid',
        items: [],
        shippingAddress: AddressModel(
          firstName: 'Bob',
          lastName: 'Johnson',
          street: '789 Pine Rd',
          city: 'Chicago',
          state: 'IL',
          zipCode: '60601',
          country: 'USA',
        ),
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        shippedAt: DateTime.now().subtract(Duration(days: 2)),
        deliveredAt: DateTime.now().subtract(Duration(days: 1)),
        trackingNumber: 'TRK987654321',
      ),
    ];
  }
}
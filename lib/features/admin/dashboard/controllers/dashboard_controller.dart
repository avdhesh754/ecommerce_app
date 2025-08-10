import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_stats.dart';
import '../../../../core/services/websocket_service.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final DashboardRepository _repository = DashboardRepository();
  late WebSocketService _webSocketService;
  
  // Stream subscriptions
  StreamSubscription<Map<String, dynamic>>? _dashboardUpdateSubscription;
  StreamSubscription<Map<String, dynamic>>? _orderUpdateSubscription;

  // Observable variables
  final Rx<DashboardStats> dashboardStats = const DashboardStats(
    totalUsers: 0,
    totalProducts: 0,
    totalOrders: 0,
    totalRevenue: 0.0,
    newUsersToday: 0,
    ordersToday: 0,
    revenueToday: 0.0,
    growthPercentage: 0.0,
  ).obs;
  final Rx<DashboardStats?> _stats = Rx<DashboardStats?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxList<RecentOrder> _recentOrders = <RecentOrder>[].obs;
  final RxList<TopProduct> _topProducts = <TopProduct>[].obs;
  final RxList<RevenueData> _revenueChart = <RevenueData>[].obs;
  
  // Real-time data
  final RxInt _pendingOrders = 0.obs;
  final RxInt _lowStockProducts = 0.obs;
  final RxDouble _totalRevenue = 0.0.obs;
  final RxList<Map<String, dynamic>> _realtimeNotifications = <Map<String, dynamic>>[].obs;

  // Getters
  DashboardStats? get stats => _stats.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  List<RecentOrder> get recentOrders => _recentOrders;
  List<TopProduct> get topProducts => _topProducts;
  List<RevenueData> get revenueChart => _revenueChart;
  
  // Real-time getters
  int get pendingOrders => _pendingOrders.value;
  int get lowStockProducts => _lowStockProducts.value;
  double get totalRevenue => _totalRevenue.value;
  List<Map<String, dynamic>> get realtimeNotifications => _realtimeNotifications;

  @override
  void onInit() {
    super.onInit();
    _webSocketService = Get.find<WebSocketService>();
    _setupWebSocketListeners();
    loadDashboardData();
  }

  @override
  void onClose() {
    _dashboardUpdateSubscription?.cancel();
    _orderUpdateSubscription?.cancel();
    super.onClose();
  }

  void _setupWebSocketListeners() {
    // Listen to dashboard updates
    _dashboardUpdateSubscription = _webSocketService.dashboardUpdates.listen((data) {
      _handleDashboardUpdate(data);
    });

    // Listen to order updates
    _orderUpdateSubscription = _webSocketService.orderUpdates.listen((data) {
      _handleOrderUpdate(data);
    });
  }

  void _handleDashboardUpdate(Map<String, dynamic> data) {
    try {
      if (data['type'] == 'stats_update') {
        final statsData = data['data'] as Map<String, dynamic>?;
        if (statsData != null) {
          _totalRevenue.value = (statsData['totalRevenue'] ?? 0.0).toDouble();
          _pendingOrders.value = statsData['pendingOrders'] ?? 0;
          _lowStockProducts.value = statsData['lowStockProducts'] ?? 0;
        }
      } else if (data['type'] == 'notification') {
        _realtimeNotifications.add(data);
        _showNotification(data['message'] ?? 'New notification');
      }
    } catch (e) {
      print('Error handling dashboard update: $e');
    }
  }

  void _handleOrderUpdate(Map<String, dynamic> data) {
    try {
      if (data['type'] == 'new_order') {
        _pendingOrders.value++;
        _showNotification('New order received: ${data['orderId']}');
        // Refresh recent orders
        loadRecentOrders();
      } else if (data['type'] == 'order_status_changed') {
        // Update specific order in the list
        _updateOrderInList(data);
      }
    } catch (e) {
      print('Error handling order update: $e');
    }
  }

  void _updateOrderInList(Map<String, dynamic> data) {
    final orderId = data['orderId'];
    final newStatus = data['status'];
    
    final index = _recentOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      // Create updated order (since RecentOrder is immutable)
      final oldOrder = _recentOrders[index];
      final updatedOrder = RecentOrder(
        id: oldOrder.id,
        customerName: oldOrder.customerName,
        customerEmail: oldOrder.customerEmail,
        amount: oldOrder.amount,
        status: newStatus,
        createdAt: oldOrder.createdAt,
        itemCount: oldOrder.itemCount,
      );
      _recentOrders[index] = updatedOrder;
    }
  }

  void _showNotification(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    ));
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.wait([
        loadOverviewStats(),
        loadRecentOrders(),
        loadTopProducts(),
        loadRevenueChart(),
      ]);
      
      // Update real-time values from loaded stats
      if (_stats.value != null) {
        _totalRevenue.value = _stats.value!.totalRevenue;
        _pendingOrders.value = _stats.value!.totalOrders;
      }
      
      // Request real-time updates via WebSocket
      _webSocketService.requestDashboardUpdate();
      
    } catch (e) {
      _setError('Failed to load dashboard data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load overview statistics
  Future<void> loadOverviewStats() async {
    try {
      final result = await _repository.getOverviewStats();
      if (result.isSuccess && result.data != null) {
        _stats.value = result.data;
        dashboardStats.value = result.data!;
      } else {
        _setError(result.error ?? 'Failed to load overview stats');
      }
    } catch (e) {
      _setError('Error loading overview stats: $e');
    }
  }

  // Load recent orders
  Future<void> loadRecentOrders() async {
    try {
      final result = await _repository.getRecentOrders();
      if (result.isSuccess && result.data != null) {
        _recentOrders.value = result.data!;
      } else {
        _setError(result.error ?? 'Failed to load recent orders');
      }
    } catch (e) {
      _setError('Error loading recent orders: $e');
    }
  }

  // Load top products
  Future<void> loadTopProducts() async {
    try {
      final result = await _repository.getTopProducts();
      if (result.isSuccess && result.data != null) {
        _topProducts.value = result.data!;
      } else {
        _setError(result.error ?? 'Failed to load top products');
      }
    } catch (e) {
      _setError('Error loading top products: $e');
    }
  }

  // Load revenue chart data
  Future<void> loadRevenueChart() async {
    try {
      final result = await _repository.getRevenueChart();
      if (result.isSuccess && result.data != null) {
        _revenueChart.value = result.data!;
      } else {
        _setError(result.error ?? 'Failed to load revenue chart');
      }
    } catch (e) {
      _setError('Error loading revenue chart: $e');
    }
  }

  // Refresh all data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
    Get.showSnackbar(const GetSnackBar(
      message: 'Dashboard refreshed',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    ));
  }

  // WebSocket-specific methods
  void requestRealTimeUpdate() {
    _webSocketService.requestDashboardUpdate();
  }

  void broadcastNotification(String message, {String? type}) {
    _webSocketService.broadcastNotification(message, type: type);
  }

  void updateOrderStatus(String orderId, String status) {
    _webSocketService.updateOrderStatus(orderId, status);
  }

  // Clear notifications
  void clearNotifications() {
    _realtimeNotifications.clear();
  }

  void removeNotification(int index) {
    if (index >= 0 && index < _realtimeNotifications.length) {
      _realtimeNotifications.removeAt(index);
    }
  }

  // System health check
  Future<void> checkSystemHealth() async {
    _webSocketService.requestSystemHealth();
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
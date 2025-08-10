class DashboardStats {
  final int totalUsers;
  final int totalProducts;
  final int totalOrders;
  final double totalRevenue;
  final int newUsersToday;
  final int ordersToday;
  final double revenueToday;
  final double growthPercentage;
  final int activeUsers;
  final int pendingOrders;
  final double monthlyRevenue;
  final int lowStockProducts;
  final int activeAdmins;
  final int totalCustomers;
  final double userGrowth;
  final double orderGrowth;
  final double revenueGrowth;
  final Map<String, dynamic> systemHealth;

  const DashboardStats({
    required this.totalUsers,
    required this.totalProducts,
    required this.totalOrders,
    required this.totalRevenue,
    required this.newUsersToday,
    required this.ordersToday,
    required this.revenueToday,
    required this.growthPercentage,
    this.activeUsers = 0,
    this.pendingOrders = 0,
    this.monthlyRevenue = 0.0,
    this.lowStockProducts = 0,
    this.activeAdmins = 0,
    this.totalCustomers = 0,
    this.userGrowth = 0.0,
    this.orderGrowth = 0.0,
    this.revenueGrowth = 0.0,
    this.systemHealth = const {},
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      newUsersToday: json['newUsersToday'] ?? 0,
      ordersToday: json['ordersToday'] ?? 0,
      revenueToday: (json['revenueToday'] ?? 0.0).toDouble(),
      growthPercentage: (json['growthPercentage'] ?? 0.0).toDouble(),
      activeUsers: json['activeUsers'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] ?? 0.0).toDouble(),
      lowStockProducts: json['lowStockProducts'] ?? 0,
      activeAdmins: json['activeAdmins'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      userGrowth: (json['userGrowth'] ?? 0.0).toDouble(),
      orderGrowth: (json['orderGrowth'] ?? 0.0).toDouble(),
      revenueGrowth: (json['revenueGrowth'] ?? 0.0).toDouble(),
      systemHealth: json['systemHealth'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'newUsersToday': newUsersToday,
      'ordersToday': ordersToday,
      'revenueToday': revenueToday,
      'growthPercentage': growthPercentage,
      'activeUsers': activeUsers,
      'pendingOrders': pendingOrders,
      'monthlyRevenue': monthlyRevenue,
      'lowStockProducts': lowStockProducts,
      'activeAdmins': activeAdmins,
      'totalCustomers': totalCustomers,
      'userGrowth': userGrowth,
      'orderGrowth': orderGrowth,
      'revenueGrowth': revenueGrowth,
      'systemHealth': systemHealth,
    };
  }
}

class RecentOrder {
  final String id;
  final String customerName;
  final String customerEmail;
  final double amount;
  final String status;
  final DateTime createdAt;
  final int itemCount;

  const RecentOrder({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.itemCount,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      itemCount: json['itemCount'] ?? 0,
    );
  }

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'confirmed':
        return 'blue';
      case 'shipped':
        return 'purple';
      case 'delivered':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }
}

class TopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int salesCount;
  final double revenue;
  final String category;

  const TopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.salesCount,
    required this.revenue,
    required this.category,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      salesCount: json['salesCount'] ?? 0,
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
    );
  }
}

class RevenueData {
  final DateTime date;
  final double revenue;
  final int orders;

  const RevenueData({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }

  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[date.month - 1];
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
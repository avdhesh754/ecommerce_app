class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    required this.isRead,
    this.imageUrl,
    this.actionUrl,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] ?? false,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      readAt: json['readAt'] != null 
          ? DateTime.tryParse(json['readAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'data': data,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    Map<String, dynamic>? data,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readAt: readAt ?? this.readAt,
    );
  }

  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'order':
        return 'Order Update';
      case 'promotion':
        return 'Promotion';
      case 'system':
        return 'System';
      case 'security':
        return 'Security';
      case 'welcome':
        return 'Welcome';
      case 'info':
        return 'Information';
      case 'warning':
        return 'Warning';
      case 'error':
        return 'Error';
      default:
        return type;
    }
  }

  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;
}

class CouponModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String type; // 'percentage' or 'fixed'
  final double value;
  final double? minimumAmount;
  final double? maximumDiscount;
  final int? usageLimit;
  final int usedCount;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final List<String>? applicableCategories;
  final List<String>? applicableProducts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CouponModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    this.minimumAmount,
    this.maximumDiscount,
    this.usageLimit,
    required this.usedCount,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.applicableCategories,
    this.applicableProducts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'percentage',
      value: (json['value'] ?? 0.0).toDouble(),
      minimumAmount: json['minimumAmount'] != null
          ? (json['minimumAmount'] as num).toDouble()
          : null,
      maximumDiscount: json['maximumDiscount'] != null
          ? (json['maximumDiscount'] as num).toDouble()
          : null,
      usageLimit: json['usageLimit'] as int?,
      usedCount: json['usedCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      applicableCategories: json['applicableCategories'] != null
          ? List<String>.from(json['applicableCategories'])
          : null,
      applicableProducts: json['applicableProducts'] != null
          ? List<String>.from(json['applicableProducts'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'type': type,
      'value': value,
      'minimumAmount': minimumAmount,
      'maximumDiscount': maximumDiscount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'applicableCategories': applicableCategories,
      'applicableProducts': applicableProducts,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate) &&
           (usageLimit == null || usedCount < usageLimit!);
  }

  bool get isExpired => DateTime.now().isAfter(endDate);

  String get discountText {
    if (type == 'percentage') {
      return '${value.toStringAsFixed(0)}% OFF';
    } else {
      return '\$${value.toStringAsFixed(2)} OFF';
    }
  }

  double calculateDiscount(double amount) {
    if (!isValid) return 0.0;
    
    if (minimumAmount != null && amount < minimumAmount!) {
      return 0.0;
    }

    double discount;
    if (type == 'percentage') {
      discount = amount * (value / 100);
    } else {
      discount = value;
    }

    if (maximumDiscount != null && discount > maximumDiscount!) {
      discount = maximumDiscount!;
    }

    return discount;
  }
}

class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? actionUrl;
  final String? actionText;
  final String type; // 'hero', 'promotional', 'info'
  final int priority;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.actionUrl,
    this.actionText,
    required this.type,
    required this.priority,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] ?? '',
      actionUrl: json['actionUrl'] as String?,
      actionText: json['actionText'] as String?,
      type: json['type'] ?? 'promotional',
      priority: json['priority'] ?? 0,
      isActive: json['isActive'] ?? true,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'actionText': actionText,
      'type': type,
      'priority': priority,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate);
  }

  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;
}

class PromoModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String type; // 'discount', 'bogo', 'free_shipping'
  final Map<String, dynamic> conditions;
  final Map<String, dynamic> rewards;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final int? usageLimit;
  final int usedCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PromoModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    required this.conditions,
    required this.rewards,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.usageLimit,
    required this.usedCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] ?? 'discount',
      conditions: json['conditions'] as Map<String, dynamic>? ?? {},
      rewards: json['rewards'] as Map<String, dynamic>? ?? {},
      isActive: json['isActive'] ?? true,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      usageLimit: json['usageLimit'] as int?,
      usedCount: json['usedCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'conditions': conditions,
      'rewards': rewards,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate) &&
           (usageLimit == null || usedCount < usageLimit!);
  }

  String get typeDisplayName {
    switch (type) {
      case 'discount':
        return 'Discount';
      case 'bogo':
        return 'Buy One Get One';
      case 'free_shipping':
        return 'Free Shipping';
      default:
        return type;
    }
  }
}
class AdminActivity {
  final String id;
  final String type;
  final String description;
  final String userEmail;
  final String? userId;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final bool isImportant;
  final String? targetResource;
  final String? targetResourceId;

  AdminActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.userEmail,
    this.userId,
    required this.timestamp,
    this.metadata = const {},
    this.isImportant = false,
    this.targetResource,
    this.targetResourceId,
  });

  factory AdminActivity.fromJson(Map<String, dynamic> json) {
    return AdminActivity(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userId: json['userId']?.toString(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'] ?? {},
      isImportant: json['isImportant'] ?? false,
      targetResource: json['targetResource'],
      targetResourceId: json['targetResourceId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'userEmail': userEmail,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'isImportant': isImportant,
      'targetResource': targetResource,
      'targetResourceId': targetResourceId,
    };
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String get categoryName {
    switch (type) {
      case 'user_created':
        return 'User Management';
      case 'admin_created':
        return 'Admin Management';
      case 'permission_changed':
        return 'Security';
      case 'product_created':
      case 'product_updated':
      case 'product_deleted':
        return 'Product Management';
      case 'order_updated':
        return 'Order Management';
      case 'system_alert':
        return 'System';
      default:
        return 'General';
    }
  }
}
import '../../core/enums/permissions.dart';

class PermissionModel {
  final String id;
  final String name;
  final String description;
  final String resource;
  final String action;
  final DateTime createdAt;
  final DateTime updatedAt;

  PermissionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.resource,
    required this.action,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      resource: json['resource'] ?? '',
      action: json['action'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'resource': resource,
      'action': action,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Permission? get permissionEnum => Permission.fromString(name);

  String get displayName => '$resource:$action';
}

class RoleModel {
  final String id;
  final String name;
  final String description;
  final List<PermissionModel> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((p) => PermissionModel.fromJson(p))
          .toList() ?? [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool hasPermission(Permission permission) {
    return permissions.any((p) => p.name == permission.value);
  }

  List<String> get permissionNames => permissions.map((p) => p.name).toList();
}
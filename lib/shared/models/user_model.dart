import '../../core/enums/user_role.dart';
import '../../core/enums/permissions.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import 'permission_model.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isActive;
  final bool emailVerified;
  final String? avatarUrl;
  final DateTime? lastLogin;
  final List<UserRole> roles;
  final List<PermissionModel> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    required this.isActive,
    required this.emailVerified,
    this.avatarUrl,
    this.lastLogin,
    required this.roles,
    this.permissions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      emailVerified: json['emailVerified'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => UserRole.fromString(role['name'] as String))
              .toList() ??
          [UserRole.customer],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((p) => PermissionModel.fromJson(p))
              .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'isActive': isActive,
      'emailVerified': emailVerified,
      'avatarUrl': avatarUrl,
      'lastLogin': lastLogin?.toIso8601String(),
      'roles': roles.map((role) => {'name': role.value}).toList(),
      'permissions': permissions.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isSuperAdmin => roles.contains(UserRole.superAdmin);
  bool get isAdmin => roles.contains(UserRole.admin);
  bool get isCustomer => roles.contains(UserRole.customer) || roles.isEmpty;

  UserRole get primaryRole {
    if (roles.contains(UserRole.superAdmin)) return UserRole.superAdmin;
    if (roles.contains(UserRole.admin)) return UserRole.admin;
    return UserRole.customer;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    bool? isActive,
    bool? emailVerified,
    String? avatarUrl,
    DateTime? lastLogin,
    List<UserRole>? roles,
    List<PermissionModel>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastLogin: lastLogin ?? this.lastLogin,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  bool hasPermission(Permission permission) {
    // Super admin has all permissions
    if (isSuperAdmin) return true;
    
    // Check direct permissions
    return permissions.any((p) => p.name == permission.value);
  }

  List<String> get permissionNames => permissions.map((p) => p.name).toList();

  bool canAccess(String resource, String action) {
    if (isSuperAdmin) return true;
    return permissions.any((p) => p.resource == resource && p.action == action);
  }

  // Convert UserModel to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      roles: roles.map((role) => role.value).toList(),
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
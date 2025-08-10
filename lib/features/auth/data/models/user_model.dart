// lib/features/auth/data/models/user_model.dart
// Add more debugging to your UserModel.fromJson method

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phone,
    super.dateOfBirth,
    super.gender,
    required super.roles,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Add comprehensive debugging
    print('=== UserModel.fromJson DEBUG ===');
    print('Full JSON: $json');
    print('Roles field exists: ${json.containsKey('roles')}');
    print('Roles value: ${json['roles']}');
    print('Roles type: ${json['roles'].runtimeType}');

    final parsedRoles = _parseRoles(json['roles']);
    print('Parsed roles result: $parsedRoles');
    print('=== End UserModel.fromJson DEBUG ===');

    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      roles: parsedRoles,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '')
          ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? DateTime.tryParse(json['updatedAt'] ?? json['updated_at'])
          : null,
    );
  }

  // ENHANCED: More robust role parsing with debugging
  static List<dynamic> _parseRoles(dynamic rolesData) {
    print('=== _parseRoles DEBUG ===');
    print('Input rolesData: $rolesData');
    print('Input type: ${rolesData.runtimeType}');

    if (rolesData == null) {
      print('Roles data is null, returning [customer]');
      return ['customer'];
    }

    if (rolesData is List) {
      print('Roles is a List with ${rolesData.length} items');
      final parsedRoles = rolesData.map((role) {
        print('Processing role: $role (type: ${role.runtimeType})');

        if (role is String) {
          print('Found string role: $role');
          return role;
        } else if (role is Map<String, dynamic>) {
          // Check all possible keys for role name
          String? roleName;

          if (role.containsKey('name')) {
            roleName = role['name'] as String?;
            print('Found role object with name: $roleName');
          } else if (role.containsKey('role')) {
            roleName = role['role'] as String?;
            print('Found role object with role key: $roleName');
          } else if (role.containsKey('roleName')) {
            roleName = role['roleName'] as String?;
            print('Found role object with roleName key: $roleName');
          } else {
            print('Role object keys: ${role.keys.toList()}');
            // Try to find any key that might contain the role name
            for (String key in role.keys) {
              if (key.toLowerCase().contains('name') || key.toLowerCase().contains('role')) {
                roleName = role[key] as String?;
                print('Found role name in key "$key": $roleName');
                break;
              }
            }
          }

          return roleName ?? 'unknown_role';
        } else {
          print('Unknown role format, converting to string: ${role.toString()}');
          return role.toString();
        }
      }).toList();

      print('Final parsed roles: $parsedRoles');
      return parsedRoles;
    } else if (rolesData is String) {
      print('Single string role: $rolesData');
      return [rolesData];
    } else {
      print('Unknown roles format (${rolesData.runtimeType}), returning [customer]');
      return ['customer'];
    }
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
      'roles': roles,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    List<dynamic>? roles,
    bool? isActive,
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
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
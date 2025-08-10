import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../constants/app_constants.dart';
import '../storage/storage_service.dart';

class WebSocketService extends GetxService {
  static WebSocketService get to => Get.find();

  late io.Socket _socket;
  final StorageService _storageService = Get.find<StorageService>();

  // Connection state
  final RxBool _isConnected = false.obs;
  final RxBool _isConnecting = false.obs;
  final RxString _connectionError = ''.obs;

  // Event streams
  final StreamController<Map<String, dynamic>> _orderUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationsController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _dashboardUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _inventoryUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Getters
  bool get isConnected => _isConnected.value;

  bool get isConnecting => _isConnecting.value;

  String get connectionError => _connectionError.value;

  // Stream getters
  Stream<Map<String, dynamic>> get orderUpdates =>
      _orderUpdatesController.stream;

  Stream<Map<String, dynamic>> get notifications =>
      _notificationsController.stream;

  Stream<Map<String, dynamic>> get dashboardUpdates =>
      _dashboardUpdatesController.stream;

  Stream<Map<String, dynamic>> get inventoryUpdates =>
      _inventoryUpdatesController.stream;

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  @override
  void onClose() {
    _disconnectSocket();
    _orderUpdatesController.close();
    _notificationsController.close();
    _dashboardUpdatesController.close();
    _inventoryUpdatesController.close();
    super.onClose();
  }

  void _initializeSocket() {
    try {
      _isConnecting.value = true;
      _connectionError.value = '';

      // Use WebSocket URL for connection
      String wsUrl = AppConstants.websocketUrl;

      // Socket.IO connection options
      final options = io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            'Authorization': 'Bearer ${_storageService.getToken() ?? ''}',
          })
          .build();

      _socket = io.io(wsUrl, options);

      _setupEventListeners();
      _socket.connect();

      debugPrint('🔌 WebSocket connecting to: $wsUrl');
    } catch (e) {
      debugPrint('❌ WebSocket initialization error: $e');
      _connectionError.value = 'Failed to initialize WebSocket: $e';
      _isConnecting.value = false;
    }
  }

  void _setupEventListeners() {
    // Connection events
    _socket.onConnect((_) {
      debugPrint('✅ WebSocket connected');
      _isConnected.value = true;
      _isConnecting.value = false;
      _connectionError.value = '';
      _joinRooms();
    });

    _socket.onDisconnect((_) {
      debugPrint('❌ WebSocket disconnected');
      _isConnected.value = false;
      _isConnecting.value = false;
    });

    _socket.onConnectError((error) {
      debugPrint('❌ WebSocket connection error: $error');
      _connectionError.value = 'Connection failed: $error';
      _isConnected.value = false;
      _isConnecting.value = false;
    });

    _socket.onError((error) {
      debugPrint('❌ WebSocket error: $error');
      _connectionError.value = 'Socket error: $error';
    });

    // Business events
    _socket.on('order_update', (data) {
      debugPrint('📦 Order update received: $data');
      if (data is Map<String, dynamic>) {
        _orderUpdatesController.add(data);
      }
    });

    _socket.on('notification', (data) {
      debugPrint('🔔 Notification received: $data');
      if (data is Map<String, dynamic>) {
        _notificationsController.add(data);
      }
    });

    _socket.on('dashboard_update', (data) {
      debugPrint('📊 Dashboard update received: $data');
      if (data is Map<String, dynamic>) {
        _dashboardUpdatesController.add(data);
      }
    });

    _socket.on('inventory_update', (data) {
      debugPrint('📦 Inventory update received: $data');
      if (data is Map<String, dynamic>) {
        _inventoryUpdatesController.add(data);
      }
    });

    _socket.on('user_activity', (data) {
      debugPrint('👤 User activity: $data');
      // Handle user activity if needed
    });

    _socket.on('system_alert', (data) {
      debugPrint('⚠️ System alert: $data');
      if (data is Map<String, dynamic>) {
        Get.snackbar(
          'System Alert',
          data['message'] ?? 'System notification',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  void _joinRooms() {
    final user = _storageService.getUser();
    if (user != null) {
      // Join user-specific room
      _socket.emit('join_room', {'room': 'user_${user.id}'});

      // Join role-specific rooms
      if (user.isAdmin) {
        _socket.emit('join_room', {'room': 'admin_dashboard'});
        _socket.emit('join_room', {'room': 'admin_orders'});
        _socket.emit('join_room', {'room': 'admin_inventory'});
      }

      if (user.isSuperAdmin) {
        _socket.emit('join_room', {'room': 'super_admin'});
        _socket.emit('join_room', {'room': 'system_alerts'});
      }

      debugPrint('🏠 Joined WebSocket rooms for user: ${user.id}');
    }
  }

  // Public methods
  void connect() {
    if (!_isConnected.value && !_isConnecting.value) {
      _socket.connect();
    }
  }

  void disconnect() {
    _disconnectSocket();
  }

  void _disconnectSocket() {
    if (_socket.connected) {
      _socket.disconnect();
    }
    _isConnected.value = false;
    _isConnecting.value = false;
  }

  void reconnect() {
    _disconnectSocket();
    Future.delayed(const Duration(seconds: 2), () {
      _initializeSocket();
    });
  }

  // Emit events
  void emitEvent(String event, Map<String, dynamic> data) {
    if (_isConnected.value) {
      _socket.emit(event, data);
      debugPrint('📤 Emitted event: $event with data: $data');
    } else {
      debugPrint('❌ Cannot emit event $event: WebSocket not connected');
    }
  }

  // Specific business methods
  void updateOrderStatus(String orderId, String status) {
    emitEvent('update_order_status', {
      'orderId': orderId,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void markNotificationAsRead(String notificationId) {
    emitEvent('mark_notification_read', {
      'notificationId': notificationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void requestDashboardUpdate() {
    emitEvent('request_dashboard_update', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void updateInventoryLevel(String productId, int newLevel) {
    emitEvent('update_inventory', {
      'productId': productId,
      'level': newLevel,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void sendMessage(String to, String message, {String? type}) {
    emitEvent('send_message', {
      'to': to,
      'message': message,
      'type': type ?? 'text',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Admin-specific methods
  void broadcastNotification(
    String message, {
    String? type,
    List<String>? roles,
  }) {
    emitEvent('broadcast_notification', {
      'message': message,
      'type': type ?? 'info',
      'roles': roles,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void requestSystemHealth() {
    emitEvent('request_system_health', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Connection status methods
  void updateAuthToken(String token) {
    if (_socket.connected) {
      _socket.emit('update_auth', {'token': token});
    }
  }

  // Handle authentication changes
  void onAuthStateChanged(bool isLoggedIn) {
    if (isLoggedIn) {
      if (!_isConnected.value && !_isConnecting.value) {
        _initializeSocket();
      } else if (_isConnected.value) {
        _joinRooms();
      }
    } else {
      _disconnectSocket();
    }
  }

}

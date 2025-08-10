import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../shared/models/user_model.dart';
import '../constants/storage_keys.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Authentication
  Future<bool> saveToken(String token) async {
    return await prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    return await prefs.setString(AppConstants.refreshTokenKey, refreshToken);
  }

  String? getRefreshToken() {
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  Future<bool> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    return await prefs.setString(AppConstants.userKey, userJson);
  }

  UserModel? getUser() {
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> clearAuthData() async {
    final results = await Future.wait([
      prefs.remove(AppConstants.tokenKey),
      prefs.remove(AppConstants.refreshTokenKey),
      prefs.remove(AppConstants.userKey),
    ]);
    return results.every((result) => result);
  }

  bool get isLoggedIn {
    final token = getToken();
    final user = getUser();
    return token != null && user != null;
  }

  // Theme
  Future<bool> saveThemeMode(String themeMode) async {
    return await prefs.setString(StorageKeys.themeMode, themeMode);
  }

  String? getThemeMode() {
    return prefs.getString(StorageKeys.themeMode);
  }

  // Language
  Future<bool> saveLanguage(String language) async {
    return await prefs.setString(StorageKeys.language, language);
  }

  String? getLanguage() {
    return prefs.getString(StorageKeys.language);
  }

  // Onboarding
  Future<bool> setOnboardingCompleted() async {
    return await prefs.setBool(StorageKeys.onboardingCompleted, true);
  }

  bool get isOnboardingCompleted {
    return prefs.getBool(StorageKeys.onboardingCompleted) ?? false;
  }

  // Cart Items (offline storage)
  Future<bool> saveCartItems(List<Map<String, dynamic>> items) async {
    final itemsJson = jsonEncode(items);
    return await prefs.setString(StorageKeys.cartItems, itemsJson);
  }

  List<Map<String, dynamic>> getCartItems() {
    final itemsJson = prefs.getString(StorageKeys.cartItems);
    if (itemsJson != null) {
      try {
        final itemsList = jsonDecode(itemsJson) as List<dynamic>;
        return itemsList.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // Wishlist Items (offline storage)
  Future<bool> saveWishlistItems(List<Map<String, dynamic>> items) async {
    final itemsJson = jsonEncode(items);
    return await prefs.setString(StorageKeys.wishlistItems, itemsJson);
  }

  List<Map<String, dynamic>> getWishlistItems() {
    final itemsJson = prefs.getString(StorageKeys.wishlistItems);
    if (itemsJson != null) {
      try {
        final itemsList = jsonDecode(itemsJson) as List<dynamic>;
        return itemsList.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // Search History
  Future<bool> saveSearchHistory(List<String> searchTerms) async {
    final historyJson = jsonEncode(searchTerms);
    return await prefs.setString(StorageKeys.searchHistory, historyJson);
  }

  List<String> getSearchHistory() {
    final historyJson = prefs.getString(StorageKeys.searchHistory);
    if (historyJson != null) {
      try {
        final historyList = jsonDecode(historyJson) as List<dynamic>;
        return historyList.cast<String>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<bool> addSearchTerm(String term) async {
    final history = getSearchHistory();
    history.remove(term); // Remove if exists
    history.insert(0, term); // Add to beginning
    if (history.length > 20) {
      history.removeLast(); // Keep only 20 recent searches
    }
    return await saveSearchHistory(history);
  }

  // Clear all data
  Future<bool> clearAllData() async {
    return await prefs.clear();
  }

  // Generic methods
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  bool containsKey(String key) {
    return prefs.containsKey(key);
  }
}
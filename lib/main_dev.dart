import 'package:flutter/material.dart';
import 'core/config/environment.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set development environment
  EnvironmentConfig.setEnvironment(Environment.development);
  
  // Run the app with development configuration
  await runAppWithEnvironment();
}
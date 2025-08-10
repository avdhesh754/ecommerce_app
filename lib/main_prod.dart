import 'package:flutter/material.dart';
import 'core/config/environment.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set production environment
  EnvironmentConfig.setEnvironment(Environment.production);
  
  // Run the app with production configuration
  await runAppWithEnvironment();
}
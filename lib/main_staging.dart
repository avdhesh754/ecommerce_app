import 'package:flutter/material.dart';
import 'core/config/environment.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set staging environment
  EnvironmentConfig.setEnvironment(Environment.staging);
  
  // Run the app with staging configuration
  await runAppWithEnvironment();
}
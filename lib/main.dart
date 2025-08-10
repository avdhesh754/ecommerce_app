import 'package:flutter/material.dart';
import 'core/config/environment.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set development environment by default
  EnvironmentConfig.setEnvironment(Environment.development);
  
  // Run the app with environment configuration
  await runAppWithEnvironment();
}





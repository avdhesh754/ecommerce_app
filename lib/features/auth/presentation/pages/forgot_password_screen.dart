import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => LoadingOverlay(
        isLoading: _authController.isLoading,
        child: _buildBody(),
      )),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(height: 40),
            
            // Icon
            Icon(
              Icons.lock_reset,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            
            SizedBox(height: 32),
            
            // Title
            Text(
              'Reset Your Password',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            Text(
              'Enter your email address and we\'ll send you a link to reset your password',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 48),

            // Email field
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: 32),

            // Send reset link button
            CustomButton(
              text: 'Send Reset Link',
              onPressed: _handleForgotPassword,
            ),

            SizedBox(height: 24),

            // Back to login link
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Back to Sign In',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      _authController.forgotPassword(_emailController.text.trim(),context);
    }
  }

}
import 'package:flutter/material.dart';
import '../../core/utils/responsive_breakpoints.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonType type;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.type = ButtonType.primary,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? ResponsiveBreakpoints.getValue(
        context: context,
        mobile: 48,
        tablet: 52,
        desktop: 52,
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: _getButtonStyle(context),
        child: isLoading ? _buildLoadingWidget() : _buildButtonContent(),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    Color bgColor;
    Color fgColor;

    switch (type) {
      case ButtonType.primary:
        bgColor = backgroundColor ?? const Color(0xFF0A0A0A);
        fgColor = textColor ?? Colors.white;
        break;
      case ButtonType.secondary:
        bgColor = backgroundColor ?? Colors.transparent;
        fgColor = textColor ?? const Color(0xFF0A0A0A);
        break;
      case ButtonType.outline:
        bgColor = backgroundColor ?? Colors.transparent;
        fgColor = textColor ?? const Color(0xFF0A0A0A);
        break;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: type == ButtonType.primary ? 0 : 0,
      side: type == ButtonType.outline
          ? const BorderSide(color: Color(0xFF0A0A0A))
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: TextStyle(
        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          type == ButtonType.primary ? Colors.white : const Color(0xFF0A0A0A),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}

enum ButtonType { primary, secondary, outline }

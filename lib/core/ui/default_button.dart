import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final IconData? icon; 
  final Color? backgroundColor;
  final Color? textColor;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final TextStyle? style;
  final double? radius;
  final double? iconSize;

  const DefaultButton({
    super.key,
    this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.padding,
    this.height,
    this.width,
    this.style,
    this.radius,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56,
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.disabled)) {
              return backgroundColor?.withOpacity(.5);
            }
            return backgroundColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.disabled)) {
              return textColor?.withOpacity(.5);
            }
            return textColor;
          }),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: iconSize ?? 20),

            if (icon != null && text != null) const SizedBox(width: 6),

            if (text != null)
              Text(
                text!,
                style: style ?? Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

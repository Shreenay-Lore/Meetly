import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget child;

  const FormSection({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

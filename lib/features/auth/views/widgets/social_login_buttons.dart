import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final bool isLoading;

  const SocialLoginButtons({
    Key? key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("OR", style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SocialButton(
              icon: Icons.g_mobiledata, // Placeholder for Google Logo
              label: 'Google',
              color: Colors.red,
              onPressed: isLoading ? null : onGooglePressed,
            ),
            _SocialButton(
              icon: Icons.apple,
              label: 'Apple',
              color: Colors.black,
              onPressed: isLoading ? null : onApplePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, color: color),
      label: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}

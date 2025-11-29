import 'package:flutter/material.dart';

/// HiddenScreen is no longer used - all initialization logic moved to MyHomePage
/// Kept for backward compatibility
class HiddenScreen extends StatelessWidget {
  const HiddenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
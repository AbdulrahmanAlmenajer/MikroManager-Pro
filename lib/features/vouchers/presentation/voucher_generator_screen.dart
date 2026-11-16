import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoucherGeneratorScreen extends ConsumerWidget {
  const VoucherGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('توليد الكروت')),
      body: const Center(child: Text('محرك توليد الكروت - المرحلة الرابعة')),
    );
  }
}

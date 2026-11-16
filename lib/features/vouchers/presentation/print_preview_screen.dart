import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintPreviewScreen extends ConsumerWidget {
  const PrintPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('معاينة الطباعة')),
      body: const Center(child: Text('معاينة الكروت - المرحلة الرابعة')),
    );
  }
}

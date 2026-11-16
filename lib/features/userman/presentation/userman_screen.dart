import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class UsermanScreen extends ConsumerWidget {
  const UsermanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة اليوزر منجر'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المستخدمون'),
              Tab(text: 'الجلسات'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('مستخدمو User Manager - المرحلة الثالثة')),
            Center(child: Text('الجلسات الحية - المرحلة الثالثة')),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.cyanAccent,
          icon: const Icon(Icons.add),
          label: const Text('إضافة مستخدم'),
        ),
      ),
    );
  }
}

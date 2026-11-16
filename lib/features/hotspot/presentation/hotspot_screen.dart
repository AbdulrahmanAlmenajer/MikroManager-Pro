import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class HotspotScreen extends ConsumerWidget {
  const HotspotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الهوتس بوت'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المتصلون'),
              Tab(text: 'المستخدمون'),
              Tab(text: 'البروفايلات'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('قائمة المتصلين - المرحلة الثالثة')),
            Center(child: Text('قائمة المستخدمين - المرحلة الثالثة')),
            Center(child: Text('البروفايلات - المرحلة الثالثة')),
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

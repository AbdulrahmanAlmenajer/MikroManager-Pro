import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HotspotLoginPreviewScreen extends StatefulWidget {
  const HotspotLoginPreviewScreen({super.key});

  @override
  State<HotspotLoginPreviewScreen> createState() =>
      _HotspotLoginPreviewScreenState();
}

class _HotspotLoginPreviewScreenState extends State<HotspotLoginPreviewScreen> {
  String _networkName = 'شبكة النور اللاسلكية';
  String _supportPhone = '777 000 000';
  Color _brandColor = AppColors.cyanAccent;
  double _previewWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة صفحة تسجيل الدخول (Hotspot)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android),
            tooltip: 'حجم الهاتف (Mobile)',
            onPressed: () => setState(() => _previewWidth = 360),
          ),
          IconButton(
            icon: const Icon(Icons.tablet_mac),
            tooltip: 'حجم اللوحي (Tablet)',
            onPressed: () => setState(() => _previewWidth = 550),
          ),
          IconButton(
            icon: const Icon(Icons.desktop_windows),
            tooltip: 'ملء الشاشة',
            onPressed: () => setState(() => _previewWidth = double.infinity),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left/Center: The Live Responsive Frame
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: _previewWidth,
                  height: 640,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius:
                        BorderRadius.circular(_previewWidth < 600 ? 28 : 12),
                    border: Border.all(color: Colors.white24, width: 4),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: 20,
                          spreadRadius: 4),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(_previewWidth < 600 ? 24 : 8),
                    child: _buildCaptivePortalPage(),
                  ),
                ),
              ),
            ),
          ),

          // Right: Customizer Sidebar
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(right: BorderSide(color: Colors.white12)),
            ),
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Row(
                  children: [
                    Icon(Icons.palette_outlined, color: AppColors.cyanAccent),
                    SizedBox(width: 8),
                    Text('تخصيص الصفحة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Divider(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'اسم الشبكة'),
                  controller: TextEditingController(text: _networkName),
                  onChanged: (val) => setState(() => _networkName = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'رقم هاتف الدعم الفني'),
                  controller: TextEditingController(text: _supportPhone),
                  onChanged: (val) => setState(() => _supportPhone = val),
                ),
                const SizedBox(height: 16),
                const Text('لون الهوية الرئيسي:',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildColorDot(AppColors.cyanAccent),
                    _buildColorDot(Colors.teal),
                    _buildColorDot(Colors.deepPurpleAccent),
                    _buildColorDot(Colors.orangeAccent),
                    _buildColorDot(Colors.green),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تم حفظ تفضيلات مظهر صفحة الهوتسبوت!')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('حفظ التفضيلات'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    final isSelected = _brandColor == color;
    return GestureDetector(
      onTap: () => setState(() => _brandColor = color),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  Widget _buildCaptivePortalPage() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: _brandColor.withValues(alpha: 0.2),
                child: Icon(Icons.wifi, size: 38, color: _brandColor),
              ),
              const SizedBox(height: 12),
              Text(
                _networkName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'أهلاً بك، يرجى إدخال رمز الكرت لتسجيل الدخول للإنترنت',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, letterSpacing: 2, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'رمز الكرت (PIN)',
                  hintStyle:
                      const TextStyle(color: Colors.white30, letterSpacing: 0),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _brandColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: const Text('اتصال بالإنترنت',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent,
                      size: 16, color: Colors.white38),
                  const SizedBox(width: 6),
                  Text(
                    'خدمة العملاء: $_supportPhone',
                    style: const TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

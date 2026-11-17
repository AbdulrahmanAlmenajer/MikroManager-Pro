import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/session/session_controller.dart';

class WireguardHelperScreen extends ConsumerStatefulWidget {
  const WireguardHelperScreen({super.key});

  @override
  ConsumerState<WireguardHelperScreen> createState() => _WireguardHelperScreenState();
}

class _WireguardHelperScreenState extends ConsumerState<WireguardHelperScreen> {
  final _portCtrl = TextEditingController(text: '13231');
  final _subnetCtrl = TextEditingController(text: '10.10.10.1/24');
  final _clientIpCtrl = TextEditingController(text: '10.10.10.2/32');
  final _endpointCtrl = TextEditingController(text: '');
  final _clientNameCtrl = TextEditingController(text: 'AdminPhone');

  String _generatedRouterScript = '';
  String _generatedClientConf = '';

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionControllerProvider).session;
    if (session != null) {
      _endpointCtrl.text = session.host;
    }
  }

  @override
  void dispose() {
    _portCtrl.dispose();
    _subnetCtrl.dispose();
    _clientIpCtrl.dispose();
    _endpointCtrl.dispose();
    _clientNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider).session;
    final isV7 = session != null && session.majorVersion >= 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مساعد إعداد WireGuard VPN'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // RouterOS Version Notice
            if (!isV7)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.warning, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ملاحظة: بروتوكول WireGuard متاح رسمياً في RouterOS v7 فما فوق. الراوتر المتصل يعمل بنظام v6، يمكنك توليد السكربت لاستخدامه عند الترقية إلى v7.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            // Form Inputs Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.vpn_lock, color: AppColors.cyanAccent),
                        SizedBox(width: 8),
                        Text('بيانات شبكة WireGuard',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _portCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'منفذ السيرفر (Port)',
                              prefixIcon: Icon(Icons.numbers),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _subnetCtrl,
                            decoration: const InputDecoration(
                              labelText: 'IP السيرفر بالشبكة',
                              prefixIcon: Icon(Icons.network_check),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _clientNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'اسم الجهاز العميل',
                              prefixIcon: Icon(Icons.phone_android),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _clientIpCtrl,
                            decoration: const InputDecoration(
                              labelText: 'IP الجهاز العميل',
                              prefixIcon: Icon(Icons.lan),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _endpointCtrl,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الراوتر الخارجي (Public IP / DDNS)',
                        hintText: 'مثال: 185.120.x.x أو xxx.sn.mynetname.net',
                        prefixIcon: Icon(Icons.public),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyanAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                      ),
                      onPressed: _generateConfigs,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('توليد سكربت الراوتر وملف العميل'),
                    ),
                  ],
                ),
              ),
            ),

            if (_generatedRouterScript.isNotEmpty) ...[
              const SizedBox(height: 20),
              // Router Script Box
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.terminal, color: AppColors.cyanAccent),
                          SizedBox(width: 8),
                          Text('أوامر RouterOS v7 (Terminal)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _generatedRouterScript,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: _generatedRouterScript));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ سكربت الراوتر للحافظة!')),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('نسخ سكربت الراوتر'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Client Conf & QR Code Box
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.qr_code_2, color: AppColors.success),
                          SizedBox(width: 8),
                          Text('إعداد العميل (ملف أو مسح QR في تطبيق WireGuard)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: QrImageView(
                            data: _generatedClientConf,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _generatedClientConf,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 11, color: Colors.cyanAccent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: _generatedClientConf));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ إعدادات العميل للحافظة!')),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('نسخ إعدادات العميل (.conf)'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _generateConfigs() {
    final port = _portCtrl.text.trim();
    final subnet = _subnetCtrl.text.trim();
    final clientIp = _clientIpCtrl.text.trim();
    final endpoint = _endpointCtrl.text.trim().isEmpty ? 'YOUR_PUBLIC_IP' : _endpointCtrl.text.trim();
    final clientName = _clientNameCtrl.text.trim();

    final routerScript = '''
# 1. Add WireGuard Interface
/interface wireguard add name=wg0 listen-port=$port comment="MMPro_WireGuard"

# 2. Assign IP to WireGuard Interface
/ip address add address=$subnet interface=wg0

# 3. Add Peer for Client ($clientName)
/interface wireguard peers add interface=wg0 allowed-address=$clientIp comment="$clientName"

# 4. Open UDP Port in Firewall
/ip firewall filter add chain=input action=accept protocol=udp dst-port=$port place-before=0 comment="Allow WireGuard VPN"
''';

    final clientConf = '''
[Interface]
Address = $clientIp
DNS = 1.1.1.1, 8.8.8.8

[Peer]
Endpoint = $endpoint:$port
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
''';

    setState(() {
      _generatedRouterScript = routerScript;
      _generatedClientConf = clientConf;
    });
  }
}

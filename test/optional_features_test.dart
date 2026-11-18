import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/utils/feature_flags.dart';

void main() {
  group('Optional Features & Feature Flags Tests (Phase U10)', () {
    test(
        'FeatureFlags starts with expected defaults and can be toggled dynamically',
        () {
      final notifier = FeatureFlagsNotifier();

      expect(notifier.state.enableWireguardHelper, isTrue);
      expect(notifier.state.enableHotspotPreview, isTrue);
      expect(notifier.state.enableInteractiveTopology, isTrue);
      expect(notifier.state.enableRogueDhcpAlerts, isTrue);

      // Toggle WireGuard
      notifier.toggleWireguard(false);
      expect(notifier.state.enableWireguardHelper, isFalse);

      // Toggle Hotspot Preview
      notifier.toggleHotspotPreview(false);
      expect(notifier.state.enableHotspotPreview, isFalse);

      // Re-enable
      notifier.toggleWireguard(true);
      expect(notifier.state.enableWireguardHelper, isTrue);
    });
  });
}

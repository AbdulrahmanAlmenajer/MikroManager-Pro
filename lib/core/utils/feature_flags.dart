import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureFlags {
  final bool enableWireguardHelper;
  final bool enableHotspotPreview;
  final bool enableInteractiveTopology;
  final bool enableRogueDhcpAlerts;
  final bool enablePdfArchive;

  const FeatureFlags({
    this.enableWireguardHelper = true,
    this.enableHotspotPreview = true,
    this.enableInteractiveTopology = true,
    this.enableRogueDhcpAlerts = true,
    this.enablePdfArchive = true,
  });

  FeatureFlags copyWith({
    bool? enableWireguardHelper,
    bool? enableHotspotPreview,
    bool? enableInteractiveTopology,
    bool? enableRogueDhcpAlerts,
    bool? enablePdfArchive,
  }) {
    return FeatureFlags(
      enableWireguardHelper: enableWireguardHelper ?? this.enableWireguardHelper,
      enableHotspotPreview: enableHotspotPreview ?? this.enableHotspotPreview,
      enableInteractiveTopology: enableInteractiveTopology ?? this.enableInteractiveTopology,
      enableRogueDhcpAlerts: enableRogueDhcpAlerts ?? this.enableRogueDhcpAlerts,
      enablePdfArchive: enablePdfArchive ?? this.enablePdfArchive,
    );
  }
}

class FeatureFlagsNotifier extends StateNotifier<FeatureFlags> {
  FeatureFlagsNotifier() : super(const FeatureFlags());

  void toggleWireguard(bool value) =>
      state = state.copyWith(enableWireguardHelper: value);

  void toggleHotspotPreview(bool value) =>
      state = state.copyWith(enableHotspotPreview: value);

  void toggleInteractiveTopology(bool value) =>
      state = state.copyWith(enableInteractiveTopology: value);

  void toggleRogueDhcp(bool value) =>
      state = state.copyWith(enableRogueDhcpAlerts: value);

  void togglePdfArchive(bool value) =>
      state = state.copyWith(enablePdfArchive: value);
}

final featureFlagsProvider =
    StateNotifierProvider<FeatureFlagsNotifier, FeatureFlags>((ref) {
  return FeatureFlagsNotifier();
});

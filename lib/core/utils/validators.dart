class AppValidators {
  /// Validates IPv4 or hostname
  static bool isValidHost(String host) {
    if (host.trim().isEmpty) return false;
    final trimmed = host.trim();

    // Check if valid IPv4
    final ipMatch = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$')
        .firstMatch(trimmed);
    if (ipMatch != null) {
      for (int i = 1; i <= 4; i++) {
        final octet = int.tryParse(ipMatch.group(i)!);
        if (octet == null || octet < 0 || octet > 255) return false;
      }
      return true;
    }

    // Check if localhost
    if (trimmed.toLowerCase() == 'localhost') return true;

    // Check if valid hostname / domain
    final hostMatch = RegExp(
            r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$')
        .hasMatch(trimmed);
    if (hostMatch) return true;

    // Simple single-label hostname (e.g. router, mikrotik)
    final simpleNameMatch = RegExp(r'^[a-zA-Z0-9\-]{1,63}$').hasMatch(trimmed);
    return simpleNameMatch;
  }

  /// Checks if the IP/host is private (RFC 1918), loopback, or link-local.
  /// If false, connecting over unencrypted port 8728 presents severe security risk.
  static bool isPrivateOrLoopbackHost(String host) {
    final trimmed = host.trim().toLowerCase();
    if (trimmed == 'localhost' || trimmed == '127.0.0.1' || trimmed == '::1') {
      return true;
    }

    final ipMatch = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$')
        .firstMatch(trimmed);
    if (ipMatch != null) {
      final o1 = int.tryParse(ipMatch.group(1)!) ?? 0;
      final o2 = int.tryParse(ipMatch.group(2)!) ?? 0;

      // 10.0.0.0/8 (10.0.0.0 - 10.255.255.255)
      if (o1 == 10) return true;

      // 172.16.0.0/12 (172.16.0.0 - 172.31.255.255)
      if (o1 == 172 && (o2 >= 16 && o2 <= 31)) return true;

      // 192.168.0.0/16 (192.168.0.0 - 192.168.255.255)
      if (o1 == 192 && o2 == 168) return true;

      // 127.0.0.0/8 (Loopback)
      if (o1 == 127) return true;

      // 169.254.0.0/16 (Link-local)
      if (o1 == 169 && o2 == 254) return true;

      // Public IPv4
      return false;
    }

    // Hostname that ends with local / lan / home / internal
    if (trimmed.endsWith('.local') ||
        trimmed.endsWith('.lan') ||
        trimmed.endsWith('.home') ||
        trimmed.endsWith('.internal')) {
      return true;
    }

    // Default to false for external domains / unknown hostnames
    return false;
  }
}

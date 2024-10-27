class VpnConfig {
  VpnConfig({
    required this.country,
    required this.username,
    required this.password,
    required this.config,
    // required this.remoteAddress,
    // required this.remotePort,
  });

  final String country;
  final String username;
  final String password;
  final String config;
  // final String remoteAddress;
  // final int remotePort;
}

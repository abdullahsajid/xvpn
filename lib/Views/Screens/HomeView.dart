import 'package:flutter/material.dart';
import 'package:xvpn/main.dart';
// import '../../models/vpn_config.dart';
import '../../services/vpn_engine.dart';
// import "../../models/vpn_status.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xvpn/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'dart:async';
import 'dart:io';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService _authService = AuthService();
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool _granted = false;
  bool isConnected = false;
  String selectedCountry = "Select Country";
  String selectedFlag = "🌐";
  String _vpnState = VpnEngine.vpnDisconnected;
  // List<VpnConfig> _listVpn = [];
  // VpnConfig? _selectedVpn;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   VpnEngine.vpnStageSnapshot().listen((event) {
  //     setState(() => _vpnState = event);
  //   });
  //
  //   initVpn();
  // }

  @override
  void initState() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = raw;
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
      "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          this.stage = stage.name;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    super.initState();
  }

  Future<void> initPlatformState() async {
    try {
      // Load config file content
      String configContent = await rootBundle.loadString('assets/vpn/profile-test.ovpn');

      // Check if permission is granted before connecting
      if (Platform.isAndroid && !_granted) {
        _granted = await engine.requestPermissionAndroid();
        if (!_granted) {
          print("VPN permission not granted");
          return;
        }
      }

      await engine.connect(
        configContent,
        "us-east-1",
        username: "openvpn",
        password: "Abdullah@321",
        certIsRequired: true,
      );
    } catch (e) {
      print("VPN connection error: $e");
    }

    if (!mounted) return;
  }

  // void initVpn() async {
  //   //sample vpn config file (you can get more from https://www.vpngate.net/)
  //   _listVpn.add(VpnConfig(
  //       config: await rootBundle.loadString('assets/vpn/profile-test.ovpn'),
  //       country: 'us-east-1',
  //       username: 'openvpn',
  //       password: 'Abdullah@321'));
  //
  //   _listVpn.add(VpnConfig(
  //       config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
  //       country: 'Japan',
  //       username: 'vpn',
  //       password: 'vpn'));
  //
  //
  //   SchedulerBinding.instance.addPostFrameCallback(
  //           (t) => setState(() => _selectedVpn = _listVpn.first));
  //   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF181E31),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section - Map and Connect Button
              Expanded(
                child: Column(
                  children: [
                    // Premium Badge
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                // const Icon(
                                //   Icons.star,
                                //   color: Colors.white,
                                //   size: 16,
                                // ),
                                // const SizedBox(width: 4),
                                // const Text(
                                //   'Premium',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 12,
                                //   ),
                                // ),
                                TextButton(
                                    onPressed: () async {
                                      // await _authService.logoutUser();
                                      // if(res){
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.remove('xvpn');
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomeScreen()),
                                        );
                                      // }
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                ),
                                TextButton(
                                    onPressed: () {

                                    },
                                    child:Text('Google')
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // World Map Placeholder
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Map background - Replace with actual map
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2234),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),

                              // Connection Status and Speed
                              // if (isConnected) ...[
                              //   Positioned(
                              //     top: 20,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         StreamBuilder<VpnStatus?>(
                              //           initialData: VpnStatus(),
                              //           stream: VpnEngine.vpnStatusSnapshot(),
                              //           builder: (context, snapshot) => Text(
                              //               "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
                              //               style:TextStyle(
                              //                 color: Color(0xFFFFFFFF),
                              //               ),
                              //               textAlign: TextAlign.center),
                              //         ),
                              //         // _buildSpeedIndicator("Download", "59.3", "mb/s"),
                              //         // const SizedBox(width: 20),
                              //         // _buildSpeedIndicator("Upload", "12.5", "mb/s"),
                              //       ],
                              //     ),
                              //   ),
                              // ],

                              // Connect Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isConnected = !isConnected;
                                  });
                                  initPlatformState();
                                },
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isConnected ? Colors.green : Colors.blue,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isConnected ? Colors.green : Colors.blue).withOpacity(0.3),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child:
                                      Text(stage?.toString() ?? VPNStage.disconnected.toString()),
                                      // Text(status?.toJson().toString() ?? ""),

                                    // child: Text(
                                    //   _vpnState == VpnEngine.vpnDisconnected
                                    //       ? 'Connect VPN'
                                    //       : _vpnState.replaceAll("_", " ").toUpperCase(),
                                    //   style: TextStyle(color: Colors.white),
                                    //   textAlign: TextAlign.center,
                                    // ),






                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Section - Country Selector
              // GestureDetector(
              //   onTap: () => _showCountrySelector(context),
              //   child: Container(
              //     margin: const EdgeInsets.all(16),
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF1F2234),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Row(
              //       children: [
              //         Text(
              //           selectedFlag,
              //           style: const TextStyle(fontSize: 24),
              //         ),
              //         const SizedBox(width: 12),
              //         Text(
              //           selectedCountry,
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 16,
              //           ),
              //         ),
              //         const Spacer(),
              //         const Icon(
              //           Icons.arrow_drop_down,
              //           color: Colors.white,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Column(
              //     children: _listVpn
              //         .map(
              //           (e) => ListTile(
              //         title: Text(e.country,
              //         style: TextStyle(color: Color(0xFFFFFFFF)),),
              //         leading: SizedBox(
              //           height: 20,
              //           width: 20,
              //           child: Center(
              //               child: _selectedVpn == e
              //                   ? CircleAvatar(
              //                   backgroundColor: Colors.green)
              //                   : CircleAvatar(
              //                   backgroundColor: Colors.grey)),
              //         ),
              //         onTap: () {
              //           // log("${e.country} is selected");
              //           setState(() => _selectedVpn = e);
              //         },
              //       ),
              //     )
              //         .toList())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedIndicator(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCountrySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1F2234),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Country list will go here
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: 2, // Replace with actual country list
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Text("🇬🇧"),
                        title: const Text(
                          "United Kingdom",
                          style: TextStyle(color: Colors.white),
                        ),
                        // subtitle: const Text(
                        //   "25,078 Online",
                        //   style: TextStyle(color: Colors.grey),
                        // ),
                        onTap: () {
                          setState(() {
                            selectedCountry = "United Kingdom";
                            selectedFlag = "🇬🇧";
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // void _connectClick() {
  //   ///Stop right here if user not select a vpn
  //   if (_selectedVpn == null) return;
  //
  //   if (_vpnState == VpnEngine.vpnDisconnected) {
  //     ///Start if stage is disconnected
  //     VpnEngine.startVpn(_selectedVpn!);
  //   } else {
  //     ///Stop if stage is "not" disconnected
  //     VpnEngine.stopVpn();
  //   }
  // }

}
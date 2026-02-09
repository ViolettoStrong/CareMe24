import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:careme24/api/api.dart';
import 'package:careme24/features/chat/presentation/chat_page_with_group.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/custom_icon_button.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TrackingScreen extends StatefulWidget {
  final Map<String, dynamic> latestCalls;
  final bool hasCar;
  const TrackingScreen({
    super.key,
    required this.latestCalls,
    required this.hasCar,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Timer? _locationTimer;
  double? _distanceKm;
  String? _estimatedTime;
  String? _mapHtml;

  @override
  void initState() {
    super.initState();
    _loadGroupLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _loadGroupLocation();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getRouteData(
      double lat1, double lon1, double lat2, double lon2) async {
    lat2 = 40.555;
    lon2 = 49.867;
    final url =
        'https://router.project-osrm.org/route/v1/driving/$lon1,$lat1;$lon2,$lat2?overview=false';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // return whole JSON
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _buildMapHtml(
      double myLat, double myLon, double targetLat, double targetLon) {
    return """
  <!DOCTYPE html>
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Route Map</title>

    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>

    <style>
      html, body { height: 100%; margin: 0; padding: 0; }
      #map { height: 100%; width: 100%; }
      .leaflet-routing-container { display: none !important; }
    </style>
  </head>

  <body>
    <div id="map"></div>

    <script>
      var map = L.map('map').setView([$myLat, $myLon], 13);

      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
      }).addTo(map);

      L.Routing.control({
        router: L.Routing.osrmv1({
          serviceUrl: 'https://router.project-osrm.org/route/v1'
        }),
        waypoints: [
          L.latLng($myLat, $myLon),
          L.latLng($targetLat, $targetLon)
        ],
        lineOptions: {
          styles: [{color: 'red', opacity: 0.8, weight: 5}]
        },
        addWaypoints: false,
        routeWhileDragging: false
      }).addTo(map);
    </script>

  </body>
  </html>
  """;
  }

  Future<void> _loadGroupLocation() async {
    Map<String, dynamic>? result;
    if (widget.hasCar) {
      result = await Api.getLocation(
          widget.latestCalls.values.first['car']['id'], widget.hasCar);
    } else {
      result = await Api.getLocation(
        widget.latestCalls.values.first['group']['id'],
        widget.hasCar,
      );
    }

    if (result != null && result['lon'] != null && result['lat'] != null) {
      final double lon = result['lon'];
      final double lat = result['lat'];
      final myCoords =
          widget.latestCalls.values.first['location']['coordinates'];
      final myLat = myCoords[1];
      final myLon = myCoords[0];

      final json = await getRouteData(myLat, myLon, lat, lon);

      final distance = json?['routes']?[0]?['distance'] ?? 0; // meters
      final duration = json?['routes']?[0]?['duration'] ?? 0; // seconds

      final distanceKm = distance / 1000;
      final durationMinutes = (duration / 60).round();

      final estimatedTimeText =
          '${durationMinutes ~/ 60} ч ${durationMinutes % 60} м';
      final html = _buildMapHtml(myLat, myLon, lat, lon);

      setState(() {
        _distanceKm = distanceKm;
        _estimatedTime = estimatedTimeText;
        _mapHtml = html;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(text: "Отследить"),
          styleType: Style.bgFillBlue60001,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Քարտեզը WebView-ում
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.grey.shade200,
                  child: _mapHtml == null
                      ? const Center(child: CircularProgressIndicator())
                      : InAppWebView(
                          initialData: InAppWebViewInitialData(data: _mapHtml!),
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              javaScriptEnabled: true,
                              transparentBackground: true,
                            ),
                          ),
                        ),
                ),
              ),
              // Տվյալների քարտը ներքևում
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: getPadding(left: 30, top: 16, right: 30, bottom: 16),
                  decoration: AppDecoration.fillWhiteA700,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Данные о вызове",
                          style: AppStyle.txtUbuntuMedium18),
                      Padding(
                        padding: getPadding(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Дистанция: ",
                                style:
                                    AppStyle.txtMontserratMedium15Bluegray800),
                            Text(
                              _distanceKm != null
                                  ? "${_distanceKm!.toStringAsFixed(2)} км"
                                  : "–",
                              style: AppStyle.txtH1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CustomIconButton(
                                height: 58,
                                width: 58,
                                padding: IconButtonPadding.PaddingAll15,
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () async {
                                      final phone = widget.hasCar
                                          ? widget.latestCalls.values
                                              .first['car']['phone']
                                          : widget.latestCalls.values
                                                  .first['group']['specialists']
                                              [0]['phone'];
                                      if (phone != null) {
                                        final uri = Uri.parse('tel:+$phone');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      }
                                    },
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgCall,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text("Телефон"),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 61,
                                width: 61,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4252FF),
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconButton(
                                  height: 59,
                                  width: 59,
                                  padding: IconButtonPadding.PaddingAll15,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatWithGroupPage(
                                              groupId: widget.hasCar
                                                  ? widget.latestCalls.values
                                                      .first['car']['id']
                                                  : widget.latestCalls.values
                                                      .first['group']['id'],
                                              groupName: widget.hasCar
                                                  ? "Чат со спецмашиной"
                                                  : "Чат с бригадой",
                                              hasCar: widget.hasCar,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CustomImageView(
                                        svgPath: ImageConstant.message,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.hasCar
                                    ? "Чат со спецмашиной"
                                    : "Чат с бригадой",
                                style: AppStyle.txtUbuntuMedium12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Future<double?> {
  operator /(int other) {}
}

class TrackingScreenContact extends StatelessWidget {
  final double lat;
  final double lng;

  const TrackingScreenContact({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    final html = _buildSimpleMapHtml(lat, lng);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Отследить"),
          backgroundColor: Colors.blue,
        ),
        body: InAppWebView(
          initialData: InAppWebViewInitialData(data: html),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              transparentBackground: true,
            ),
          ),
        ),
      ),
    );
  }

  String _buildSimpleMapHtml(double lat, double lng) {
    return """
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Simple Map</title>

      <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
      <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

      <style>
        html, body { height: 100%; margin: 0; padding: 0; }
        #map { height: 100%; width: 100%; }
      </style>
    </head>

    <body>
      <div id="map"></div>

      <script>
        var map = L.map('map').setView([$lat, $lng], 16);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        L.marker([$lat, $lng]).addTo(map);
      </script>
    </body>
    </html>
    """;
  }
}

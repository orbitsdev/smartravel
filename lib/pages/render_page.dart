import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smarttravel/components/web_view.dart';
import 'package:smarttravel/pages/location_page.dart';

class RenderPage extends StatefulWidget {
  const RenderPage({Key? key}) : super(key: key);

  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: WebViewWidget(
              url: "https://smart-travelkorea.com/",
              title: "Smart Travel Korea",
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const LocationPage(), transition: Transition.cupertino);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xfffa1b1b),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: HeroIcon(
                  HeroIcons.mapPin, // Using HeroIcons for the map icon
                  color: Colors.white,
                  size: 32,
                  style: HeroIconStyle.solid, // Use solid style for better visibility
                ),
              )
                  .animate()
                  .fade(duration: 500.ms) // Fade-in effect
                  .scale(delay: 300.ms, duration: 600.ms), // Scale animation
             // Scale animation
            ),
          ),
        ],
      ),
    );
  }
}

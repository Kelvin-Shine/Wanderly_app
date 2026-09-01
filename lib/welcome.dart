import 'package:flutter/material.dart';

/// Screen 1: Welcome / splash screen.
///
/// [onGetStarted] is called when the user taps the black arrow button.
/// In main.dart this is wired to `AppRouterDelegate.goToDiscover`, which is
/// how navigation happens under Navigator 2.0 (this widget never calls
/// Navigator.push itself — it just reports the user's intent upward).
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(flex: 6, child: _buildHeroIllustration()),
          Expanded(flex: 5, child: _buildBottomSheet()),
        ],
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Orange -> yellow gradient sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF8A50), Color(0xFFFFC93C)],
            ),
          ),
        ),
        // Sun
        Positioned(
          top: 60,
          left: 40,
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE082),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Rolling dune / wave shape
        Positioned(
          bottom: -20,
          left: -40,
          right: -40,
          child: ClipPath(
            clipper: _WaveClipper(),
            child: Container(height: 130, color: const Color(0xFFFFA94D)),
          ),
        ),
        // Blue corner shape (bottom right)
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipPath(
            clipper: _CornerTriangleClipper(),
            child: Container(
              width: 150,
              height: 150,
              color: const Color(0xFF3A6EA5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Wanderly',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore the World with Ease',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3F5EDB),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onGetStarted,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.8, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CornerTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
import 'package:flutter/material.dart';
import 'discover.dart';

/// Screen 3: Destination detail.
///
/// [onBack] is called by both the back button and the Navigator's own
/// system-back handling (via main.dart's onPopPage). It's wired to
/// `AppRouterDelegate.goBack`, which pops this page off the Navigator 2.0
/// page stack and returns to Discover.
class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;
  final VoidCallback onBack;

  const DestinationDetailScreen({
    super.key,
    required this.destination,
    required this.onBack,
  });

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  bool _showDetails = true;

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(d),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabs(),
                    const SizedBox(height: 16),
                    _buildInfoRow(d),
                    const SizedBox(height: 16),
                    Text(
                      d.description,
                      style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(d),
    );
  }

  Widget _buildHeroImage(Destination d) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: buildDestinationImage(d.imageAsset, height: 320),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _circleIconButton(
              icon: Icons.arrow_back,
              onTap: widget.onBack,
              bg: Colors.white,
              iconColor: Colors.black,
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _circleIconButton(
              icon: Icons.bookmark_border,
              onTap: () {},
              bg: const Color(0xFFFFC107),
              iconColor: Colors.white,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 60,
            child: Text(
              d.name,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: buildDestinationImage(d.imageAsset, height: 44, width: 44),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color bg,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showDetails = true),
          child: Column(
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _showDetails ? Colors.black : Colors.grey,
                ),
              ),
              if (_showDetails)
                Container(margin: const EdgeInsets.only(top: 4), width: 40, height: 2, color: Colors.black),
            ],
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => setState(() => _showDetails = false),
          child: Text(
            'Reviews (2)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: !_showDetails ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(Destination d) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoItem(Icons.location_on_outlined, d.location, 'Location'),
        _infoItem(Icons.people_outline, d.visitors.toString(), 'Visitors'),
        _infoItem(Icons.star_border, '${d.rating}/10', 'Rating'),
      ],
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBottomBar(Destination d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Trip Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('\$${d.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
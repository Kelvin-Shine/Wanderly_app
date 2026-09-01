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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Color(0xFFFFC107)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(d),
              const SizedBox(height: 16),
              Text(
                d.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 16),
              _buildInfoRow(d),
              const SizedBox(height: 16),
              Text(
                d.description,
                style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
              ),
              // Extra space so content never sits under the bottom price bar.
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(d),
    );
  }

  Widget _buildHeroImage(Destination d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDestinationImage(d.imageAsset, height: 200, width: double.infinity),
        const SizedBox(height: 10),
        Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: buildDestinationImage(d.imageAsset, height: 50, width: 50),
            );
          }),
        ),
      ],
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
        // A plain top border instead of a blurred BoxShadow - much cheaper
        // to composite on lower-end GPUs.
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
              elevation: 0,
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
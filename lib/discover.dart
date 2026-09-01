import 'package:flutter/material.dart';

/// A single place the user can browse / book.
class Destination {
  final String id;
  final String name;
  final String location;
  final String imageAsset;
  final double rating;
  final List<String> tags;
  final int visitors;
  final double price;
  final String description;

  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.imageAsset,
    required this.rating,
    required this.tags,
    required this.visitors,
    required this.price,
    required this.description,
  });
}

/// A short "featured trip" entry shown lower on the Discover screen.
class Trip {
  final String name;
  final String location;
  final String imageAsset;

  const Trip({
    required this.name,
    required this.location,
    required this.imageAsset,
  });
}

/// Sample data standing in for a real backend/API.
/// Drop matching images into assets/images/ (see pubspec.yaml note below)
/// and update these asset paths — the UI falls back to a gradient
/// placeholder automatically if an asset is missing, so the app still runs.
final List<Destination> sampleDestinations = [
  const Destination(
    id: 'kungliga-slottet',
    name: 'Kungliga Slottet',
    location: 'Stockholm, Sweden',
    imageAsset: 'assets/images/kungliga Slottet_main.webp',
    rating: 9.5,
    tags: ['City', 'Food', 'Asia'],
    visitors: 2428,
    price: 428.00,
    description:
        "Embark on a majestic journey to Stockholm's Kungliga Slottet, a "
        "true gem of Swedish history and culture. As one of Europe's "
        "largest palaces, the Royal Palace stands proudly at the heart of "
        "the city, captivating visitors with its grandeur and timeless "
        "beauty. Step into the footsteps of royalty as you explore the "
        "opulent halls, adorned with magnificent architecture, intricate "
        "details, and priceless treasures.",
  ),
  const Destination(
    id: 'colosseum',
    name: 'Colosseum',
    location: 'Rome, Italy',
    imageAsset: 'assets/images/Colosseum_main.webp',
    rating: 9.2,
    tags: ['City', 'History'],
    visitors: 5210,
    price: 210.00,
    description:
        "Step into the ancient world at the Colosseum, Rome's legendary "
        "amphitheatre. Wander the arena floor where gladiators once "
        "fought and imagine the roar of the crowd echoing through its "
        "ancient stone arches.",
  ),
  const Destination(
    id: 'cyclades',
    name: 'Cyclades',
    location: 'Mykonos, Greece',
    imageAsset: 'assets/images/Cyclades_main.webp',
    rating: 9.0,
    tags: ['Islands', 'Beach'],
    visitors: 3120,
    price: 350.00,
    description:
        "Drift through the whitewashed streets and turquoise waters of "
        "the Cyclades, where every corner of Mykonos offers a "
        "postcard-perfect view of the Aegean Sea.",
  ),
  const Destination(
    id: 'wawel-castle',
    name: 'Wawel Castle',
    location: 'Krakow, Poland',
    imageAsset: 'assets/images/Wawel Castle_main.webp',
    rating: 8.9,
    tags: ['City', 'History'],
    visitors: 1875,
    price: 180.00,
    description:
        "Perched above the Vistula River, Wawel Castle has watched over "
        "Krakow for centuries, its Gothic towers and royal chambers "
        "holding the story of Polish kings.",
  ),
  const Destination(
    id: 'miroir-deau',
    name: "Miroir d'Eau",
    location: 'Bordeaux, France',
    imageAsset: "assets/images/Miroir d'Eau_main.webp",
    rating: 9.1,
    tags: ['City', 'Landmark'],
    visitors: 2650,
    price: 260.00,
    description:
        "The world's largest reflecting pool, Miroir d'Eau turns "
        "Bordeaux's Place de la Bourse into a shimmering mirror by day "
        "and a playful mist by evening.",
  ),
];

final List<Trip> sampleTrips = [
  const Trip(
    name: 'Vespa Tour',
    location: 'Rome, Italy',
    imageAsset: 'assets/images/Vespa Tour.webp',
  ),
  const Trip(
    name: 'Yoga retreat',
    location: 'Bali, Indonesia',
    imageAsset: 'assets/images/Yoga Retreat.webp',
  ),
  const Trip(
    name: 'Oktoberfest',
    location: 'Munich, Germany',
    imageAsset: 'assets/images/Oktoberfest.webp',
  ),
  const Trip(
    name: 'Brooklyn Bridge',
    location: 'New York City, USA',
    imageAsset: 'assets/images/Brooklyn Bridge.webp',
  ),
];

/// Screen 2: Discover.
///
/// [onSelectDestination] is called whenever the user taps the featured
/// card or a hot-places tile. In main.dart this is wired to
/// `AppRouterDelegate.goToDetail`, which pushes the detail page onto the
/// Navigator 2.0 page stack.
class DiscoverScreen extends StatefulWidget {
  final ValueChanged<Destination> onSelectDestination;

  const DiscoverScreen({super.key, required this.onSelectDestination});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<String> _categories = const [
    'Suggested',
    'Cities',
    'Mountains',
    'Beaches',
  ];
  String _selectedCategory = 'Suggested';
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final featured = sampleDestinations.first;
    final hotPlaces = sampleDestinations.sublist(1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategoryTabs(),
              const SizedBox(height: 20),
              _buildFeaturedCard(featured),
              const SizedBox(height: 24),
              _buildSectionHeader('Hot places 🔥'),
              const SizedBox(height: 12),
              _buildHotPlacesGrid(hotPlaces),
              const SizedBox(height: 24),
              _buildSectionHeader('Featured trips'),
              const SizedBox(height: 12),
              _buildTripsList(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Discover\nnew places',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: Color(0xFF1A1A1A),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? Colors.black : const Color(0xFFF2F2F5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCard(Destination destination) {
    return GestureDetector(
      onTap: () => widget.onSelectDestination(destination),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildDestinationImage(destination.imageAsset, height: 180),
              Positioned(top: 12, right: 12, child: _ratingBadge(destination.rating)),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: destination.tags
                          .map((tag) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
          const SizedBox(width: 4),
          Text(rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('See all',
            style: TextStyle(color: Color(0xFFFFA000), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildHotPlacesGrid(List<Destination> places) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final place = places[index];
        return GestureDetector(
          onTap: () => widget.onSelectDestination(place),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: buildDestinationImage(place.imageAsset, height: double.infinity),
                ),
              ),
              const SizedBox(height: 6),
              Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(place.location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTripsList() {
    return Column(
      children: sampleTrips
          .map((trip) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: buildDestinationImage(trip.imageAsset, height: 56, width: 56),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(trip.location,
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration:
                          const BoxDecoration(color: Color(0xFFFFC107), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildBottomNav() {
    final icons = [
      Icons.home_filled,
      Icons.search,
      Icons.confirmation_number_outlined,
      Icons.person_outline,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final selected = index == _navIndex;
          return GestureDetector(
            onTap: () => setState(() => _navIndex = index),
            child: Icon(icons[index], color: selected ? const Color(0xFFFFC107) : Colors.grey, size: 26),
          );
        }),
      ),
    );
  }
}

/// Shared helper (used by discover.dart and destinationDetail.dart).
/// Loads an asset image and falls back to a gradient placeholder if the
/// asset hasn't been added yet, so the app never crashes on a missing file.
Widget buildDestinationImage(String assetPath, {double height = 100, double? width}) {
  return Image.asset(
    assetPath,
    height: height,
    width: width,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFF8A50), Color(0xFFFFC93C)]),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: Colors.white70),
      );
    },
  );
}
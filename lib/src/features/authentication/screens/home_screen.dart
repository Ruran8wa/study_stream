import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:study_stream/src/features/authentication/screens/programming_screen.dart';
import 'package:study_stream/src/features/authentication/screens/business_screen.dart';
import 'package:study_stream/src/features/authentication/screens/statistics_screen.dart';
import 'package:study_stream/src/features/authentication/screens/time_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _videos = [
    {
      "title": "Flutter Tutorial",
      "url": "https://www.youtube.com/watch?v=1ukSR1GRtMU"
    },
    {
      "title": "Dart Basics",
      "url": "https://www.youtube.com/watch?v=Ej_Pcr4uC2Q"
    },
    {
      "title": "Machine Learning Intro",
      "url": "https://www.youtube.com/watch?v=Gv9_4yMHFhI"
    },
  ];

  List<Map<String, String>> _filteredVideos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredVideos = List.from(_videos);
  }

  void _searchVideos(String query) {
    setState(() {
      _filteredVideos = _videos
          .where((video) =>
              video["title"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchVideos('');
  }

  // Fetching YouTube video thumbnail
  Future<String> _getVideoThumbnail(String url) async {
    try {
      var yt = YoutubeExplode();
      var videoId = url.split('v=')[1].split('&')[0]; // Extract video ID
      var video = await yt.videos.get(VideoId(videoId)); // Get video details
      return video.thumbnails.highResUrl; // Return the high-res thumbnail
    } catch (e) {
      print('Error fetching thumbnail: $e');
      return ''; // Return empty string in case of error
    }
  }

  Future<void> _openVideo(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD32F2F), // Deep red at top
              Color(0xFFFCE4EC), // Light pink at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Top Tutorials'),
                  const SizedBox(height: 16),
                  _buildVideoList(),
                  const SizedBox(height: 16),
                  _buildCategoryButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Handwerker!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Find Your Tutorial',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/women/mosh.jpeg',
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: _searchVideos,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: _clearSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredVideos.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future: _getVideoThumbnail(_filteredVideos[index]["url"]!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const ListTile(
                title: Text('Error loading thumbnail'),
              );
            }

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    snapshot.data!,
                    width: 60, // Set a fixed width
                    height: 60, // Set a fixed height
                    fit: BoxFit.cover, // Ensure the image fits within the box
                  ),
                ),
                title: Text(
                  _filteredVideos[index]["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Tap to watch',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new, color: Colors.blue),
                  onPressed: () => _openVideo(_filteredVideos[index]["url"]!),
                ),
                onTap: () => _openVideo(_filteredVideos[index]["url"]!),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProgrammingScreen()),
            );
          },
          child: _buildCategoryButton(
            color: Colors.green,
            icon: Icons.code,
            label: 'Programming',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusinessScreen()),
            );
          },
          child: _buildCategoryButton(
            color: Colors.blue,
            icon: Icons.monetization_on,
            label: 'Business',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
            );
          },
          child: _buildCategoryButton(
            color: Colors.orange,
            icon: Icons.add_chart,
            label: 'Statistics',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimeScreen()),
            );
          },
          child: _buildCategoryButton(
            color: Colors.red,
            icon: Icons.timer,
            label: 'Time Management',
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:study_stream/src/features/authentication/screens/upload_course_screen.dart'; // Import the new screen

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  // New method to extract video ID without extra parameters
  String? extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.host != 'www.youtube.com' && uri.host != 'youtube.com') return null;
    final videoId = uri.queryParameters['v'];
    return videoId;
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 255, 255, 255),
                thickness: 1,
              ),
              const SizedBox(height: 16),
              const Text(
                'Explore our diverse range of courses designed to help you acquire new skills, advance your career, and achieve your personal goals.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the UploadCourseScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadCourseScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 211, 47, 47),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Add Course'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> courses = [
                      {
                        'title':
                            'think like a business analyst in tech (3 core skills + solving case study)',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=9CGYmmHZq9Q',
                        'category': 'Analyst',
                        'videoCount': '1 Video',
                        'students': 4,
                        'duration': '12:19',
                      },
                      {
                        'title':
                            'What Is Business Analytics? | Business: Explained',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=9fFQA-JOXA0',
                        'category': 'Business Analysis',
                        'videoCount': '1 Video',
                        'students': 4,
                        'duration': '2:18',
                      },
                      {
                        'title':
                            'The Basics of Business Education - What Business Students Should Study',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=69dLyztc-As',
                        'category': 'Marketing',
                        'videoCount': '1 Video',
                        'students': 8,
                        'duration': '57:06',
                      },
                    ];
                    return _buildCourseCard(
                      context,
                      courses[index]['title'],
                      courses[index]['youtubeUrl'],
                      courses[index]['category'],
                      courses[index]['videoCount'],
                      courses[index]['students'],
                      courses[index]['duration'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, String youtubeUrl,
      String category, String videoCount, int students, String duration) {
    // Get YouTube video ID from URL
    String? videoId = extractVideoId(youtubeUrl); // Use the new method

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: YouTubeThumbnail(
                  videoId: videoId ?? '',
                  height: 100,
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    onTap: () {
                      if (videoId != null) {
                        _openYoutubeVideo(context, videoId);
                      }
                    },
                    child: const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 25,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        AssetImage('assets/images/instructor.webp'),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.play_circle_outline, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      videoCount,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(Icons.people_outline, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$students Students',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openYoutubeVideo(BuildContext context, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubeVideoPlayer(videoId: videoId),
      ),
    );
  }
}

// Widget to display YouTube thumbnails
class YouTubeThumbnail extends StatelessWidget {
  final String videoId;
  final double height;

  const YouTubeThumbnail({
    Key? key,
    required this.videoId,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoId.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Video not available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // YouTube thumbnail URL format
    String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';

    return Image.network(
      thumbnailUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.grey[300],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'Thumbnail not available',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.black12,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

// Screen to play YouTube videos
class YoutubeVideoPlayer extends StatefulWidget {
  final String videoId;

  const YoutubeVideoPlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Course Video', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
          onReady: () {
            _controller.addListener(() {});
          },
        ),
      ),
    );
  }
}

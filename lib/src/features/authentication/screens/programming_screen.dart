import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:study_stream/src/features/authentication/screens/upload_course_screen.dart';

class ProgrammingScreen extends StatelessWidget {
  const ProgrammingScreen({Key? key}) : super(key: key);

  // Clean method to extract video ID without extra parameters
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
                'Programming',
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
              // Fix for overflow: Use Expanded with a Container to constrain GridView
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Adjust the child aspect ratio to better fit content
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> courses = [
                      {
                        'title':
                            'Python for Beginners - Learn Python in 1 Hour',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=kqtD5dpn9C8',
                        'category': 'Development',
                        'videoCount': '1 Video',
                        'students': 4,
                        'duration': '1:00:15',
                      },
                      {
                        'title': 'Learn JavaScript: Full Course for Beginners',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=PkZNo7MFNFg',
                        'category': 'Development',
                        'videoCount': '1 Video',
                        'students': 4,
                        'duration': '3:26:43',
                      },
                      {
                        'title': 'Learn HTML: Full Tutorial for Beginners',
                        'youtubeUrl':
                            'https://www.youtube.com/watch?v=pQN-pnXPaVg',
                        'category': 'Development',
                        'videoCount': '1 Video',
                        'students': 8,
                        'duration': '2:19:37',
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
    String? videoId = extractVideoId(youtubeUrl);

    // Fixed card with proper constraints
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias, // This prevents children from overflowing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed height for thumbnail container
          SizedBox(
            height: 100, // Reduced height for thumbnail
            child: Stack(
              fit: StackFit.expand,
              children: [
                YouTubeThumbnail(
                  videoId: videoId ?? '',
                  height: 100, // Match container height
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (videoId != null && videoId.isNotEmpty) {
                          _openYoutubeVideo(context, videoId);
                        }
                      },
                      child: const Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 20, // Smaller play button
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Smaller instructor avatar
                const Positioned(
                  bottom: 5,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          AssetImage('assets/images/instructor.webp'),
                    ),
                  ),
                ),
                // Smaller duration indicator
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          duration,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content container with fixed padding and font sizing
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Stats row at bottom
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        videoCount,
                        style: const TextStyle(fontSize: 10),
                      ),
                      const Spacer(),
                      const Icon(Icons.people_outline, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '$students Students',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library,
              size: height * 0.3, // Scale icon size based on container height
              color: Colors.grey,
            ),
            SizedBox(height: height * 0.05), // Proportional spacing
            const Text(
              'Video not available',
              style: TextStyle(color: Colors.grey, fontSize: 10),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: height * 0.3,
                color: Colors.grey,
              ),
              SizedBox(height: height * 0.05),
              const Text(
                'Thumbnail not available',
                style: TextStyle(color: Colors.grey, fontSize: 10),
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
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
      },
    );
  }
}

// Fixed YoutubeVideoPlayer class
class YoutubeVideoPlayer extends StatefulWidget {
  final String videoId;

  const YoutubeVideoPlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    // Create controller with proper initialization
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        hideControls: false,
        hideThumbnail: false,
        disableDragSeek: false,
        forceHD: false,
        loop: false,
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          setState(() {
            _isReady = true;
          });
          _controller.play();
        },
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Course Video',
                style: TextStyle(color: Colors.white)),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                player,
                if (!_isReady)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:study_stream/src/features/authentication/screens/programming_screen.dart';
import 'package:study_stream/src/features/authentication/screens/business_screen.dart';
import 'package:study_stream/src/features/authentication/screens/statistics_screen.dart';
import 'package:study_stream/src/features/authentication/screens/time_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  _buildVideoThumbnails(),
                  const SizedBox(height: 16),
                  _buildCategoryButtons(context),
                  const SizedBox(height: 24),
                  _buildPopularTutorialsHeader(),
                  const SizedBox(height: 16),
                  _buildPopularTutorials(),
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
            'https://randomuser.me/api/portraits/women/44.jpg',
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
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {},
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

  Widget _buildVideoThumbnails() {
    // Add context parameter here
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildVideoThumbnail('assets/images/tut1.jpeg',
              'Doctor Consultation'), // Pass context as first parameter
          _buildVideoThumbnail(
            'assets/images/tut2.jpeg',
            'Surgery Procedure',
          ), // Pass context as first parameter
          _buildVideoThumbnail(
            'assets/images/tut3.jpeg',
            'Dental Procedure',
          ), // Pass context as first parameter
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(
    String imagePath,
    String title,
  ) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildPopularTutorialsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Popular Tutorials'),
        TextButton(
          onPressed: () {},
          child: const Row(
            children: [
              Text(
                'See all',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularTutorials() {
    return Row(
      children: [
        Expanded(
          child: _buildPopularTutorialCard(
            'assets/images/mosh.jpeg',
            'Mosh',
            'Programming Trainer',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPopularTutorialCard(
            'assets/images/KyleCook.webp',
            'Kyle',
            'Web simplified',
          ),
        ),
      ],
    );
  }

  Widget _buildPopularTutorialCard(
      String imagePath, String name, String speciality) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  speciality,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

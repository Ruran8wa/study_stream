import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UploadCourseScreen extends StatefulWidget {
  const UploadCourseScreen({Key? key}) : super(key: key);

  @override
  State<UploadCourseScreen> createState() => _UploadCourseScreenState();
}

class _UploadCourseScreenState extends State<UploadCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _youtubeUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool _isUploading = false;
  String? _videoIdError;

  @override
  void dispose() {
    _titleController.dispose();
    _youtubeUrlController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Extract YouTube video ID from URL
  String? extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Handle youtube.com URLs
    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      return uri.queryParameters['v'];
    }

    // Handle youtu.be URLs
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    return null;
  }

  // Validate YouTube URL format
  bool isValidYoutubeUrl(String url) {
    return extractVideoId(url) != null;
  }

  // Save course to local storage (using SharedPreferences)
  Future<void> saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing courses or create empty list
      List<String> coursesJson = prefs.getStringList('courses') ?? [];
      List<Map<String, dynamic>> courses = coursesJson
          .map((course) => json.decode(course) as Map<String, dynamic>)
          .toList();

      // Extract video ID
      final videoId = extractVideoId(_youtubeUrlController.text);

      // Create new course object
      final newCourse = {
        'title': _titleController.text,
        'youtubeUrl': _youtubeUrlController.text,
        'videoId': videoId,
        'category': _categoryController.text,
        'videoCount': '1 Video',
        'students': 0,
        'duration': _durationController.text,
        'uploadDate': DateTime.now().toIso8601String(),
      };

      // Add to courses list
      courses.add(newCourse);

      // Save updated list
      await prefs.setStringList(
          'courses', courses.map((course) => json.encode(course)).toList());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _titleController.clear();
        _youtubeUrlController.clear();
        _categoryController.clear();
        _durationController.clear();
        setState(() {
          _videoIdError = null;
        });

        // Pop back after successful upload
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context, true);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading course: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Course'),
        backgroundColor: const Color(0xFFD32F2F),
      ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload a New Course',
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
                    'Fill in the details below to upload your new course.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Course Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Course Title',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a course title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // YouTube URL Field
                  TextFormField(
                    controller: _youtubeUrlController,
                    decoration: InputDecoration(
                      labelText: 'YouTube Video URL',
                      labelStyle: const TextStyle(color: Colors.white),
                      hintText: 'https://www.youtube.com/watch?v=...',
                      hintStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorText: _videoIdError,
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a YouTube URL';
                      }
                      if (!isValidYoutubeUrl(value)) {
                        return 'Please enter a valid YouTube URL';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Clear error when user types
                      if (_videoIdError != null) {
                        setState(() {
                          _videoIdError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Category Field
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Duration Field
                  TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (e.g., 1:23:45)',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the course duration';
                      }
                      // Simple validation for time format (H:MM:SS)
                      final timePattern = RegExp(r'^\d+:\d{2}:\d{2}$');
                      if (!timePattern.hasMatch(value)) {
                        return 'Please use format: H:MM:SS';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  // Upload Button
                  Center(
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: saveCourse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor:
                                  const Color.fromARGB(255, 211, 47, 47),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text(
                              'Upload Course',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

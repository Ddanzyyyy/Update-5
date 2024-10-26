import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:to_do_list_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
    reverseCurve: const Interval(0.0, 0.8),
  ),
);


    _controller.forward();
    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 8));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ToDoListScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  Widget _buildNetworkImage(String url, double height, double width) {
    return Image.network(
      url,
      height: height,
      width: width,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFF636E72),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: height,
          width: width,
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildNetworkImage(
                            'https://img.freepik.com/free-vector/online-wishes-list-concept-illustration_114360-3055.jpg',
                            180,
                            180,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    DefaultTextStyle(
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3436),
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          FadeAnimatedText(
                            'To Do List App',
                            duration: const Duration(seconds: 4),
                            fadeOutBegin: 0.9,
                            fadeInEnd: 0.7,
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kelompok 3',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF636E72),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildNetworkImage(
                            'https://1.bp.blogspot.com/-j4TSpuiugjA/X4lyFe4lrEI/AAAAAAAAJoM/KJuAMh9i7yApLp0yeTdPqZjMUVNBvGrFQCLcBGAsYHQ/w1200-h630-p-k-no-nu/Unpak.png',
                            40,
                            40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Version 1.1 Beta',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF636E72),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
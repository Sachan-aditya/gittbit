import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gitbit/pag1.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GithubUserPage()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Lottie.asset(
                        'image/Animation - 1714039422210.json',
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Gitbit',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.1, // 10% of screen width
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1 / 1, // Adjust as needed
                            child: Image.asset(
                                'assets/image.png'), // Replace with your image file
                          ),
                          const SizedBox(height: 20),
                          ShimmerText(
                            text: "Welcome to Gitbit",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ShimmerText(
                            text: "Your one stop for all things Git",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class ShimmerText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

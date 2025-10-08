import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Alignment alignment;
  final double width;
  final double height;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    this.alignment = Alignment.center,
    this.width = 300,
    this.height = 300,
  });
}

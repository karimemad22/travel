import 'package:flutter/material.dart';

class TripScreen extends StatelessWidget {
  static const String routeName = 'trip';

  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip'),
      ),
      body: const Center(
        child: Text('Trip Screen'),
      ),
    );
  }
}

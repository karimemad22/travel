import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/for_you_section.dart';
import 'widgets/start_journey_button.dart';
import 'widgets/travel_stories_section.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF9F9F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  ForYouSection(),
                  SizedBox(height: 30),
                  StartJourneyButton(),
                  SizedBox(height: 30),
                  TravelStoriesSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

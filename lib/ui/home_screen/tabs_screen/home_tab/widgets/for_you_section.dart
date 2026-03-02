import 'package:flutter/material.dart';
import 'travel_card.dart';

class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 10),
        _buildCardsList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'For You',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsList() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          TravelCard(
            title: 'Pyramids of Giza',
            desc: 'Ancient wonders & sunset views',
            price: '1,200 EGP',
            duration: 'Full Day',
            match: '94% match',
          ),
          SizedBox(width: 15),
          TravelCard(
            title: 'Siwa Oasis',
            desc: 'Desert paradise & salt lakes',
            price: '3,500 EGP',
            duration: '3 Days',
            match: '88% match',
          ),
        ],
      ),
    );
  }
}

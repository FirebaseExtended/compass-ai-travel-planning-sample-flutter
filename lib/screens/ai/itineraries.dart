import 'package:flutter/material.dart';
import '../components/app_bar.dart';

import 'dart:math';

class Itineraries extends StatefulWidget {
  const Itineraries({super.key});

  @override
  State<Itineraries> createState() => _ItinerariesState();
}

class _ItinerariesState extends State<Itineraries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: brandedAppBar,
      body: Column(
        children: [
          SizedBox(
            height: 650,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ItineraryCard(),
                ItineraryCard(),
                ItineraryCard(),
                ItineraryCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItineraryCard extends StatelessWidget {
  const ItineraryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          height: 650,
          width: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/paris.png'),
            ),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 650,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors: [
                        Color.fromARGB(150, 49, 49, 49),
                        Colors.transparent
                      ],
                      stops: [
                        0.0,
                        0.75
                      ]),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Romantic Parisian Getaway',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      )),
                  Text('14th May - 21st May, 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  Row(
                    children: [
                      BrandChip(icon: Icons.location_city, title: 'City'),
                      BrandChip(icon: Icons.favorite, title: 'Couples'),
                    ],
                  ),
                  Text(
                    'From the Eiffel Tower to Montmartre\'s streets, every corner invites exploration. Wander along the Seine, savor pastries, and uncover hidden courtyards steeped in history.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}

class BrandChip extends StatelessWidget {
  const BrandChip({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 4,
        ),
        child: Chip(
          //color: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
          shape: const StadiumBorder(side: BorderSide.none),
          avatar:
              Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          label: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

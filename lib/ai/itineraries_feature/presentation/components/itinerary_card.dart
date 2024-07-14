import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../../../common/utilties.dart';
import './components.dart';

class ItineraryCard extends StatelessWidget {
  const ItineraryCard({
    required this.itinerary,
    required this.onTap,
    super.key,
  });

  final Itinerary itinerary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var mqWidth = MediaQuery.sizeOf(context).width;
    var isLarge = mqWidth >= 1024;

    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLarge ? mqWidth * .5 : 800,
              minWidth: 350,
              maxHeight: 800,
            ),
            child: Container(
                width: mqWidth * .8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(itinerary.heroUrl),
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
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itinerary.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            )),
                        const SizedBox.square(
                          dimension: 8,
                        ),
                        Text(
                            '${prettyDate(itinerary.startDate)} - ${prettyDate(itinerary.endDate)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                        const SizedBox.square(
                          dimension: 8,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: List.generate(
                              itinerary.tags.length <= 5
                                  ? itinerary.tags.length
                                  : 5, (index) {
                            return BrandChip(
                              title: itinerary.tags[index],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
        ));
  }
}

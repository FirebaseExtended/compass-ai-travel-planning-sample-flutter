import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/ai/detailed_itinerary.dart';
import 'package:tripedia/utilties.dart';
import '../components/app_bar.dart';
import '../../data/models/itinerary.dart';
import '../../view_models/intineraries_viewmodel.dart';

class Itineraries extends StatefulWidget {
  const Itineraries({super.key});

  @override
  State<Itineraries> createState() => _ItinerariesState();
}

Widget buildSmallItineraries(BuildContext context, ItinerariesViewModel model) {
  var itineraries = model.itineraries;

  if (itineraries == null) {
    return const Placeholder();
  }

  return Scaffold(
    appBar: brandedAppBar,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 650,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: itineraries.length,
                  itemBuilder: (context, index) {
                    return ItineraryCard(
                      itinerary: itineraries[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedItinerary(
                                itinerary: itineraries[index]),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ]),
        ),
      ],
    ),
  );
}

class _ItinerariesState extends State<Itineraries> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    var model = context.watch<ItinerariesViewModel>();

    if (model.itineraries != null) {
      return buildSmallItineraries(context, model);
    } else {
      return const Placeholder();
    }
  }
}

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
    //const colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
                height: 650,
                width: MediaQuery.sizeOf(context).width * .85,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(itinerary.heroUrl),
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
                    padding: EdgeInsets.all(24),
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
                        Text(
                            '${prettyDate(itinerary.startDate)} - ${prettyDate(itinerary.endDate)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                List.generate(itinerary.tags.length, (index) {
                              return BrandChip(
                                title: itinerary.tags[index],
                              );
                            }),
                          ),
                        ),
                        /*const Text(
                    'From the Eiffel Tower to Montmartre\'s streets, every corner invites exploration. Wander along the Seine, savor pastries, and uncover hidden courtyards steeped in history.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),*/
                      ],
                    ),
                  ),
                ])),
          ),
        ));
  }
}

class BrandChip extends StatelessWidget {
  const BrandChip({
    required this.title,
    this.icon,
    super.key,
  });

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 4,
        ),
        child: Chip(
          //color: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
          shape: const StadiumBorder(side: BorderSide.none),
          avatar: (icon != null)
              ? Icon(icon,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)
              : null,
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

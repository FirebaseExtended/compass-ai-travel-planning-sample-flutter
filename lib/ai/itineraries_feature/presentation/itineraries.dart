import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/itineraries_feature/presentation/detailed_itinerary.dart';
import 'package:tripedia/common/utilties.dart';
import '../../common/components.dart';
import '../models/itinerary.dart';
import '../view_models/intineraries_viewmodel.dart';

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

  var mqHeight = MediaQuery.sizeOf(context).height -
      brandedAppBar.preferredSize.height -
      MediaQuery.paddingOf(context).top -
      MediaQuery.paddingOf(context).bottom;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actionsIconTheme: const IconThemeData(color: Colors.black12),
      actions: const [HomeButton()],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: mqHeight * .90,
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
                        SizedBox(
                          height: 100,
                          child: Wrap(
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
                        ),
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

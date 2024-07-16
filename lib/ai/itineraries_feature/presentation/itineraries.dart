import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:compass/ai/itineraries_feature/presentation/detailed_itinerary.dart';
import '../../common/components.dart';
import '../view_models/intineraries_viewmodel.dart';

import './components/components.dart';
import '../models/models.dart';

class ItinerariesScreen extends StatefulWidget {
  const ItinerariesScreen({super.key});

  @override
  State<ItinerariesScreen> createState() => _ItinerariesScreenState();
}

class _ItinerariesScreenState extends State<ItinerariesScreen> {
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actionsIconTheme: const IconThemeData(color: Colors.black12),
      actions: const [HomeButton()],
    );
  }

  void openDetailedItinerary(Itinerary itinerary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedItineraryScreen(itinerary: itinerary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<ItinerariesViewModel>();

    var itineraries = model.itineraries;

    var availableHeight = MediaQuery.sizeOf(context).height -
        kToolbarHeight -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: availableHeight * .90,
            child: itineraries == null
                ? const NoItinerariesMessage()
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: itineraries.length,
                          itemBuilder: (context, index) {
                            return ItineraryCard(
                              itinerary: itineraries[index],
                              onTap: () => openDetailedItinerary(
                                itineraries[index],
                              ),
                            );
                          }),
                    ),
                  ]),
          ),
        ],
      ),
    );
  }
}

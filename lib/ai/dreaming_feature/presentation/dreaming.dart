import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../itineraries_feature/view_models/intineraries_viewmodel.dart';

import '../../itineraries_feature/presentation/itineraries.dart';
import './components/components.dart';

class DreamingScreen extends StatefulWidget {
  const DreamingScreen({super.key});

  @override
  State<DreamingScreen> createState() => _DreamingScreenState();
}

class _DreamingScreenState extends State<DreamingScreen> {
  late final itinerariesVM = context.read<ItinerariesViewModel>();

  @override
  void initState() {
    itinerariesVM.addListener(_waitForItineraries);
    super.initState();
  }

  @override
  void dispose() {
    itinerariesVM.removeListener(_waitForItineraries);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var itineraries = context.read<ItinerariesViewModel>().itineraries;

    if (itineraries == null) return;

    for (var itinerary in itineraries) {
      precacheImage(CachedNetworkImageProvider(itinerary.heroUrl), context);
      for (var day in itinerary.dayPlans) {
        for (var activity in day.planForDay) {
          precacheImage(CachedNetworkImageProvider(activity.imageUrl), context);
        }
      }
    }

    super.didChangeDependencies();
  }

  void _waitForItineraries() {
    var vm = context.read<ItinerariesViewModel>();
    var errorMessage = vm.errorMessage;
    var itineraries = vm.itineraries;

    if (errorMessage != null) {
      _showError(errorMessage, () {
        vm.clearError();
        context.pop();
        Navigator.pop(context);
      });
    } else if (itineraries != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ItinerariesScreen(),
        ),
      );
    }
  }

  void _showError(String errorMessage, VoidCallback onDismissed) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          errorMessage,
        ),
        content: const Text('Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: onDismissed,
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff352F34),
      appBar: buildTransparentAppBar(context),
      body: Stack(children: [
        ...buildRotatingPhotos(context),
        const DreamingTitleWidget(),
      ]),
    );
  }
}

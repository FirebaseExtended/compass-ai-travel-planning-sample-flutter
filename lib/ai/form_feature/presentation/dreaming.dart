import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../common/components.dart';
import 'dart:math';
import 'dart:ui';
import '../../itineraries_feature/view_models/intineraries_viewmodel.dart';

import '../../itineraries_feature/presentation/itineraries.dart';

class DreamingScreen extends StatefulWidget {
  const DreamingScreen({super.key});

  @override
  State<DreamingScreen> createState() => _DreamingScreenState();
}

class Pair<S, T> {
  late S first;
  late T second;

  Pair(this.first, this.second);
}

final smallDeviceDimens = <Pair<EdgeInsets, double>>[
  Pair(const EdgeInsets.only(top: -100, right: -100), 400),
  Pair(const EdgeInsets.only(top: 300, left: -100), 200),
  Pair(const EdgeInsets.only(right: 40, bottom: 250), 100),
  Pair(const EdgeInsets.only(right: -100, bottom: -100), 400)
];
final largeDeviceDimens = <Pair<EdgeInsets, double>>[
  Pair(const EdgeInsets.only(top: -85, right: 100), 400),
  Pair(const EdgeInsets.only(top: 300, left: 150), 250),
  Pair(const EdgeInsets.only(right: 370, bottom: 370), 100),
  Pair(const EdgeInsets.only(right: 100, bottom: -50), 400)
];

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
          debugPrint('cache-ing ${activity.imageUrl}');
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
        Navigator.of(context).pop();
        context.go('/ai');
      });
    } else if (itineraries != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Itineraries(),
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
    return buildDreamScreen(context);
  }
}

List<Widget> _buildRotatedWidgets(List<Pair<EdgeInsets, double>> dimens) {
  return <Widget>[
    Positioned(
      top: dimens[0].first.top,
      right: dimens[0].first.right,
      child: RotatingWidget(
        width: dimens[0].second,
        child: CachedNetworkImage(
            width: dimens[0].second,
            imageUrl: 'https://rstr.in/google/tripedia/x9b8ZmlQhod'),
      ),
    ),
    Positioned(
      top: dimens[1].first.top,
      left: dimens[1].first.left,
      child: RotatingWidget(
        width: dimens[1].second,
        child: CachedNetworkImage(
            width: dimens[1].second,
            imageUrl: 'https://rstr.in/google/tripedia/llRpA9RuvTy'),
      ),
    ),
    Positioned(
      bottom: dimens[2].first.bottom,
      right: dimens[2].first.right,
      child: RotatingWidget(
        width: dimens[2].second,
        child: CachedNetworkImage(
            width: dimens[2].second,
            imageUrl: 'https://rstr.in/google/tripedia/ANNOvZaekFJ'),
      ),
    ),
    Positioned(
      bottom: dimens[3].first.bottom,
      right: dimens[3].first.right,
      child: RotatingWidget(
        width: dimens[3].second,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: CachedNetworkImage(
              width: dimens[3].second,
              imageUrl: 'https://rstr.in/google/tripedia/Y292jg7Wr69'),
        ),
      ),
    ),
  ];
}

Widget buildDreamScreen(BuildContext context) {
  var isTablet = MediaQuery.sizeOf(context).shortestSide < 800;
  var dimens = isTablet ? smallDeviceDimens : largeDeviceDimens;

  return Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: const Color(0xff352F34),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actionsIconTheme: const IconThemeData(color: Colors.black12),
      actions: const [HomeButton()],
    ),
    body: Stack(children: [
      ..._buildRotatedWidgets(dimens),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppLogo(dimension: 38),
              Text(
                'Dreaming',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox.square(
                dimension: 8,
              ),
              const SizedBox(
                width: 150,
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ],
      ),
    ]),
  );
}

class RotatingWidget extends StatefulWidget {
  const RotatingWidget({required this.width, required this.child, super.key});

  final double width;
  final Widget child;

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 13),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: -pi / 24, end: pi / 24).animate(_controller),
      child: SizedBox(
        width: widget.width,
        child: widget.child,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 2.seconds)
        .then()
        .scale(
            begin: const Offset(.5, .5),
            end: const Offset(1, 1),
            duration: 10.seconds)
        .then()
        .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 1.seconds)
        .fadeOut(duration: 3.seconds);
  }
}

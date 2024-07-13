import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/ai/form_feature/presentation/dreaming.dart';
import 'package:tripedia/ai/services/image_handling.dart';
import 'package:tripedia/ai/itineraries_feature/view_models/intineraries_viewmodel.dart';

import '../../common/components.dart';
import './components/components.dart';
import '../services.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<UserSelectedImage>? selectedImages;
  bool useVoice = true;
  bool _processing = false;

  void generateItineraries() async {
    setState(() {
      _processing = true;
    });

    try {
      var query = _queryController.text.trim();
      if (query.isEmpty) {
        _showAlert();
        return;
      }

      // Validate necessary info

      var details = await checkQueryDetails(query);
      debugPrint('details: $details');

      if (mounted && details.containsValue(false)) {
        Map<String, dynamic> clarifyingAnswers = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return MoreInfoSheet(details: details);
          },
        );

        debugPrint('Clarifying Answers: $clarifyingAnswers');

        query += QueryClient.generateRefinements(clarifyingAnswers);
      }

      if (mounted) {
        precacheImage(
            const CachedNetworkImageProvider(
                'https://rstr.in/google/tripedia/x9b8ZmlQhod'),
            context);
        precacheImage(
            const CachedNetworkImageProvider(
                'https://rstr.in/google/tripedia/llRpA9RuvTy'),
            context);
        precacheImage(
            const CachedNetworkImageProvider(
                'https://rstr.in/google/tripedia/ANNOvZaekFJ'),
            context);
        precacheImage(
            const CachedNetworkImageProvider(
                'https://rstr.in/google/tripedia/Y292jg7Wr69'),
            context);
        context
            .read<ItinerariesViewModel>()
            .loadItineraries(query, selectedImages);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DreamingScreen()));
      }
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  Future<Map<String, Object?>> checkQueryDetails(String query) async {
    var hasNeededInfo = await QueryClient.hasRequiredInfo(query);

    return hasNeededInfo;
  }

  _showAlert() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Please tell us about your dream vacation!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void setImages(List<UserSelectedImage> selectedImagesList) {
    setState(() {
      selectedImages = selectedImagesList;
    });
  }

  Widget _buildSmallForm(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const AppLogo(dimension: 38),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
              ),
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.home_outlined,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrandGradient(
                child: Text(
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
              'Dream Your\nVacation',
            )),
            const SizedBox.square(
              dimension: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  useVoice
                      ? Center(
                          child: TalkToMe(
                            onVoiceInput: (String input) {
                              setState(() {
                                _queryController.text = input;
                              });
                            },
                          ),
                        ).animate().scale()
                      : Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: TextField(
                                controller: _queryController,
                                keyboardType: TextInputType.multiline,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Write anything',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ).animate().scale(),
                        ),
                  const SizedBox.square(
                    dimension: 4,
                  ),
                  TextButton.icon(
                    label: useVoice
                        ? const Text(
                            'Type instead',
                          )
                        : const Text('Talk'),
                    onPressed: () {
                      setState(() {
                        useVoice = !useVoice;
                      });
                    },
                    icon: useVoice
                        ? const Icon(Icons.keyboard)
                        : const Icon(Icons.mic),
                  ).animate().shimmer()
                ],
              ),
            ),
            const SizedBox.square(dimension: 16),
            ImageSelector(
              onSelect: setImages,
            ),
            const SizedBox.square(dimension: 16),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: generateItineraries,
                  child: _processing
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          'Plan my dream trip',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ]),
            const SizedBox.square(dimension: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayXLTextTheme = GoogleFonts.rubikTextTheme()
        .displayLarge
        ?.copyWith(
            fontSize: 90, fontWeight: FontWeight.w900, fontFamily: "Rubik");

    const assetURI = 'assets/images/compass-icon.svg';
    final iconColor = Theme.of(context).colorScheme.primary;
    Widget compassIcon = SvgPicture.asset(
      assetURI,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          NavigationRail(
              useIndicator: false,
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                    icon: compassIcon, label: const Text('Home')),
                // NavRail requires minimum two destinations, so this is a phantom one
                const NavigationRailDestination(
                    icon: Icon(null), label: Text(''), disabled: true)
              ],
              selectedIndex: 0),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const AppLogo(dimension: 72),
                  BrandGradient(
                    child: Text(
                        textAlign: TextAlign.left,
                        "Dream Your Vacation",
                        style: displayXLTextTheme),
                  )
                ],
              )),
          const SizedBox(
            width: 32,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 48, right: 32),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLowest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: _buildInputBox(context)),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  List<Widget> _buildInputBox(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            useVoice
                ? Center(
                    child: TalkToMe(
                      onVoiceInput: (String input) {
                        setState(() {
                          _queryController.text = input;
                        });
                      },
                    ),
                  ).animate().scale()
                : Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: TextField(
                          controller: _queryController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Write anything',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ).animate().scale(),
                  ),
            const SizedBox.square(
              dimension: 4,
            ),
            TextButton.icon(
              label: useVoice
                  ? const Text(
                      'Type instead',
                    )
                  : const Text('Talk'),
              onPressed: () {
                setState(() {
                  useVoice = !useVoice;
                });
              },
              icon:
                  useVoice ? const Icon(Icons.keyboard) : const Icon(Icons.mic),
            ).animate().shimmer(),
          ],
        ),
      ),
      const SizedBox.square(dimension: 8),
      ImageSelector(
        onSelect: setImages,
      ),
      const SizedBox.square(dimension: 16),
      Row(children: [
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: generateItineraries,
            child: _processing
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(
                    'Plan my dream trip',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ]),
      const SizedBox.square(dimension: 32),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 1024) {
        return _buildSmallForm(context);
      } else {
        return _buildLargeForm(context);
      }
    });
  }
}

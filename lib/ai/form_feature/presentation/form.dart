import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:compass/ai/dreaming_feature/presentation/dreaming.dart';
import 'package:compass/ai/services/image_handling.dart';
import 'package:compass/ai/itineraries_feature/view_models/intineraries_viewmodel.dart';
import 'package:compass/ai/styles.dart';

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
      // Make sure there's a user-inputed prompt
      var query = _queryController.text.trim();
      if (query.isEmpty) {
        _showNeedPromptDialog();
        return;
      }

      // Validate necessary info is in prompt, otherwise ask refinement questions
      var details = await QueryClient.hasRequiredInfo(query);

      if (mounted && details.containsValue(false)) {
        Map<String, dynamic> refinementAnswers = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return MoreInfoSheet(details: details);
          },
        );
        query += QueryClient.generateRefinements(refinementAnswers);
      }

      if (mounted) {
        precacheDreamingImages();
        // Load itineraries with user prompt
        context
            .read<ItinerariesViewModel>()
            .loadItineraries(query, selectedImages);
        // Show "dreaming" screen
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DreamingScreen()));
      }
    } finally {
      setState(() {
        _processing = false;
      });
    }
  }

  void precacheDreamingImages() {
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
  }

  _showNeedPromptDialog() {
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

  void setImages(List<UserSelectedImage> userSelectedImages) {
    setState(() {
      selectedImages = userSelectedImages;
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  List<Widget> _buildUserInputFields(BuildContext context) {
    return <Widget>[
      VoiceOrTextInput(
        promptController: _queryController,
        onUserVoiceInput: (String input) {
          setState(() {
            _queryController.text = input;
          });
        },
      ),
      const SizedBox.square(dimension: 16),
      ImageSelector(
        onSelect: setImages,
      ),
      const SizedBox.square(dimension: 16),
      PlanTripButton(
        loading: _processing,
        onPressed: generateItineraries,
      ),
      const SizedBox.square(dimension: 32),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return (constraints.maxWidth < Breakpoints.expanded)
          ? SmallFormLayout(
              appBar: _buildAppBar(context),
              children: _buildUserInputFields(context),
            )
          : LargeFormLayout(
              appBar: _buildAppBar(context),
              children: _buildUserInputFields(context),
            );
    });
  }
}

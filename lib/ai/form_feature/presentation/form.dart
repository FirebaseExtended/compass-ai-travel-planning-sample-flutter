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
import 'package:tripedia/ai/styles.dart';

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
      if (constraints.maxWidth < 1024) {
        return SmallFormLayout(
          appBar: _buildAppBar(context),
          children: _buildUserInputFields(context),
        );
      }

      return LargeFormLayout(
        appBar: _buildAppBar(context),
        children: _buildUserInputFields(context),
      );
    });
  }
}

class SmallFormLayout extends StatelessWidget {
  const SmallFormLayout(
      {required this.appBar, required this.children, super.key});

  final AppBar appBar;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GradientTitle('Dream Your\nVacation'),
            const SizedBox.square(
              dimension: 16,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class LargeFormLayout extends StatelessWidget {
  const LargeFormLayout(
      {required this.appBar, required this.children, super.key});

  final AppBar appBar;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayXLTextTheme = GoogleFonts.rubikTextTheme()
        .displayLarge
        ?.copyWith(
            fontSize: 90, fontWeight: FontWeight.w900, fontFamily: "Rubik");

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const AppLogo(dimension: 72),
                    GradientTitle(
                      "Dream Your Vacation",
                      textStyle: displayXLTextTheme,
                      textAlign: TextAlign.center,
                    ),
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
                    child: Column(children: children),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientTitle extends StatelessWidget {
  const GradientTitle(this.title, {this.textStyle, this.textAlign, super.key});

  final String title;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return BrandGradient(
      child: Text(
        textAlign: textAlign ?? TextAlign.left,
        style: (textStyle != null)
            ? textStyle
            : TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
        title,
      ),
    );
  }
}

class VoiceOrTextInput extends StatefulWidget {
  const VoiceOrTextInput(
      {required this.promptController,
      required this.onUserVoiceInput,
      super.key});

  final TextEditingController promptController;
  final void Function(String) onUserVoiceInput;

  @override
  State<VoiceOrTextInput> createState() => _VoiceOrTextInputState();
}

class _VoiceOrTextInputState extends State<VoiceOrTextInput> {
  bool useVoice = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          useVoice
              ? Center(
                  child: TalkToMe(onVoiceInput: widget.onUserVoiceInput),
                ).animate().scale()
              : Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: TextField(
                        controller: widget.promptController,
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
            icon: useVoice ? const Icon(Icons.keyboard) : const Icon(Icons.mic),
          ).animate().shimmer()
        ],
      ),
    );
  }
}

class PlanTripButton extends StatelessWidget {
  const PlanTripButton(
      {required this.loading, required this.onPressed, super.key});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
          onPressed: onPressed,
          child: loading
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
    ]);
  }
}

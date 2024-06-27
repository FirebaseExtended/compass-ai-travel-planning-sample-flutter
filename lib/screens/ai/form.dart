import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/image_handling.dart';
import 'package:tripedia/screens/components/basics.dart';
import 'package:tripedia/view_models/intineraries_viewmodel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';

import '../branding.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<UserSelectedImage>? selectedImages;

  void generateItineraries() async {
    var query = _queryController.text.trim();
    if (query.isEmpty) {
      _showAlert();
      return;
    }

    // Validate necessary info

    var details = checkQueryDetails(query);

    if (details.containsValue(null)) {
      var clarifyingAnswers = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return MoreInfoSheet(details: details);
        },
      );

      print(clarifyingAnswers);
    }

    if (mounted) {
      context
          .read<ItinerariesViewModel>()
          .loadItineraries(query, selectedImages);
      context.go('/dreaming');
    }
  }

  Map<String, Object?> checkQueryDetails(String query) {
    // make a network call to Nohe's endpoint

    return {
      'kids': null,
      'date': null,
      'budget': null,
    };
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () => {},
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
                    height: 0),
                'Dream Your\nVacation',
              ),
            ),
            Expanded(
              child: PageView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TalkToMe(onVoiceInput: (String input) {
                      setState(() {
                        _queryController.text = input;
                      });
                    }),
                    const SizedBox.square(
                      dimension: 24,
                    ),
                    const Text('← Swipe to type instead.').animate().shimmer()
                  ],
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .4,
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
                  ),
                )
              ]),
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
                  child: Text(
                    'Plan my dream trip',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox.square(dimension: 32),
          ],
        ),
      ),
    );
  }
}

class BrandGradient extends StatelessWidget {
  BrandGradient({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(colors: [
        Color(0xff59B7EC),
        Color(0xff9A62E1),
        Color(0xffE66CF9),
      ], stops: [
        0.0,
        0.05,
        0.9,
      ]).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}

class TalkToMe extends StatefulWidget {
  const TalkToMe({required this.onVoiceInput, super.key});

  final void Function(String words) onVoiceInput;

  @override
  State<TalkToMe> createState() => _TalkToMeState();
}

class _TalkToMeState extends State<TalkToMe> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    setState(() {
      isListening = true;
    });
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    widget.onVoiceInput(result.recognizedWords);

    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _stopListening() async {
    setState(() {
      isListening = false;
    });
    await _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 150,
        child: IconButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              isListening ? Colors.redAccent : Theme.of(context).primaryColor,
            ),
            iconColor: const WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            isListening ? _stopListening() : _startListening();
          },
          icon: isListening
              ? const Icon(
                  Icons.mic,
                  size: 48,
                )
              : const Icon(
                  Icons.mic_off,
                  size: 48,
                ),
        ));
  }
}

class ImageSelector extends StatefulWidget {
  const ImageSelector({required this.onSelect, super.key});

  final Function(List<UserSelectedImage>) onSelect;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  List<UserSelectedImage>? imagesList;

  void selectImages() async {
    // TODO: Only allow JPEG and PNG images.
    var picked = await _picker.pickMultiImage();

    List<UserSelectedImage> userSelectedImages = [];

    for (var image in picked) {
      userSelectedImages.add(
        UserSelectedImage(
          image.path,
          await image.readAsBytes(),
        ),
      );
    }

    setState(() {
      _selectedImages = picked;
      imagesList = userSelectedImages;
      if (imagesList != null) {
        widget.onSelect(userSelectedImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var images = imagesList;

    if (_selectedImages == null || images == null) {
      return GestureDetector(
        onTap: selectImages,
        child: const ImageSelectorEmpty(),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                images.length,
                (idx) => Thumbnail(
                  imageBytes: images[idx].bytes,
                ),
              )
                  .animate(interval: 200.ms)
                  .scaleXY(begin: 1.1, end: 1, duration: 200.ms),
            ),
          ),
        )
      ],
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({required this.imageBytes, super.key});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: MemoryImage(imageBytes),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ImageSelectorEmpty extends StatelessWidget {
  const ImageSelectorEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandGradient(
                  child: const Icon(
                Icons.image_outlined,
                size: 32,
              )),
              const SizedBox.square(dimension: 16),
              const Text('Add images for inspiration'),
            ],
          ),
        ),
      )
    ]);
  }
}

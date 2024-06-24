import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  Map<String, Uint8List>? selectedImages;

  void generateItineraries() {
    var query = _queryController.text.trim();
    if (query.isEmpty) {
      _showAlert();
      return;
    }

    context.read<ItinerariesViewModel>().loadItineraries(query, selectedImages);
    context.go('/dreaming');
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

  void setImages(Map<String, Uint8List> selectedImagesMap) {
    setState(() {
      selectedImages = selectedImagesMap;
    });
  }

  Widget _buildSmallForm(BuildContext context) {
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
                  Icons.home,
                ),
              )),
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
            const SizedBox.square(dimension: 8),
            ..._buildInputBox(context)
          ],
        ),
      ),
    );
  }

  Widget _buildLargeForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
                          style: displayXLTextTheme))
                ],
              )),
          const SizedBox(
            width: 32,
          ),
          Expanded(
              flex: 5,
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 48, bottom: 48, right: 32),
                  child: Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerLowest,
                      child: Padding(padding: const EdgeInsets.all(16), child:Column(
                        children: _buildInputBox(context, showTalkIcon: false))),
                      ))),
        ],
      )),
    );
  }

  List<Widget> _buildInputBox(BuildContext context, { showTalkIcon = true}) {
    return <Widget>[
      Expanded(
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
      if (showTalkIcon == true)TalkToMe(onVoiceInput: (String input) {
        setState(() {
          _queryController.text = input;
        });
      }),
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
        )
      ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    var h = MediaQuery.sizeOf(context).height;
    print(w);
    print(h);
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

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    widget.onVoiceInput(result.recognizedWords);

    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          _speechToText.isListening
              ? Colors.red
              : Theme.of(context).primaryColor,
        ),
        iconColor: const WidgetStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        _speechToText.isNotListening ? _startListening() : _stopListening();
      },
      icon: _speechToText.isListening
          ? const Icon(Icons.mic)
          : const Icon(Icons.mic_off),
    );
  }
}

class ImageSelector extends StatefulWidget {
  const ImageSelector({required this.onSelect, super.key});

  final Function(Map<String, Uint8List>) onSelect;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  Map<String, Uint8List>? imagesList;

  void selectImages() async {
    // TODO: Only allow JPEG and PNG images.
    var picked = await _picker.pickMultiImage();

    Map<String, Uint8List> listAsBytes = {};

    for (var image in picked) {
      listAsBytes[image.path] = await image.readAsBytes();
    }

    setState(() {
      _selectedImages = picked;
      imagesList = listAsBytes;
      if (imagesList != null) {
        widget.onSelect(listAsBytes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedImages == null || imagesList == null) {
      return GestureDetector(
        onTap: selectImages,
        child: const ImageSelectorEmpty(),
      );
    }

    var images = imagesList!.values.toList();

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
                  imageBytes: images[idx],
                ),
              ),
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

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/image_handling.dart';
import 'package:tripedia/screens/components/basics.dart';
import 'package:tripedia/view_models/intineraries_viewmodel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../branding.dart';
import '../components/thumbnail.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<UserSelectedImage>? selectedImages;
  bool useVoice = true;

  void generateItineraries() async {
    var query = _queryController.text.trim();
    if (query.isEmpty) {
      _showAlert();
      return;
    }

    // Validate necessary info

    var details = await checkQueryDetails(query);
    print('details: $details');

    if (mounted && details.containsValue(false)) {
      Map<String, dynamic> clarifyingAnswers = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return MoreInfoSheet(details: details);
        },
      );

      print('Clarifying Answers: $clarifyingAnswers');

      query += QueryClient.generateRefinements(clarifyingAnswers);
    }

    if (mounted) {
      context
          .read<ItinerariesViewModel>()
          .loadItineraries(query, selectedImages);
      context.go('/ai/dreaming');
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
                  height: 0),
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
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            children:
                                _buildInputBox(context, showTalkIcon: false))),
                  ))),
        ],
      )),
    );
  }

  // Conditionally builds the pageview on small screens the textfield is in an
  // elevated card, in large, it's on surfaceContainerLow
  Widget _buildPageView(BuildContext context, {paginate = true}) {
    if (paginate) {
      return PageView(
          scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
          }),
          children: [
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
                const Text('Swipe to type instead →').animate().shimmer()
              ],
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .4,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          ]);
    } else {
      return TextField(
        controller: _queryController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Write anything',
          border: InputBorder.none,
        ),
      );
    }
  }

  List<Widget> _buildInputBox(BuildContext context, {showTalkIcon = true}) {
    return <Widget>[
      Expanded(
        child: _buildPageView(context, paginate: showTalkIcon),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    var h = MediaQuery.sizeOf(context).height;
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

class QueryClient {
  static Future<Map<String, bool>> hasRequiredInfo(String query) async {
    var endpoint = Uri.https(
      'tripedia-genkit-exp-hovwuqnpzq-uc.a.run.app',
      '/textRefinement',
    );

    var jsonBody = jsonEncode(
      {
        'data': query,
      },
    );

    try {
      var response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      Map<String, dynamic> hasRequiredData = jsonDecode(response.body);

      print('data: $hasRequiredData');
      Map<String, dynamic> result =
          hasRequiredData['result'] as Map<String, dynamic>;
      print('result: $result');
      bool cost, kids, date;

      {
        'cost': cost as bool,
        'kids': kids as bool,
        'date': date as bool,
      } = result;

      return {'cost': cost, 'kids': kids, 'date': date};
    } catch (e) {
      debugPrint(e.toString());
      throw ("Error validating required info.");
    }
  }

  static String generateRefinements(Map<String, dynamic> refinedDetails) {
    Map<String, String> refinementPrompts = {
      'kids': 'Is it family friendly?',
      'cost': 'How much are you willing to spend (1 is low 5 is high):',
      'date': 'Start date:',
    };
    String refinementSpec = '\nRefinements:\n';

    for (var key in refinedDetails.keys) {
      refinementSpec += '${refinementPrompts[key]} ${refinedDetails[key]}\n';
    }

    return refinementSpec;
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
    _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      isListening = true;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    widget.onVoiceInput(result.recognizedWords);

    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _stopListening() async {
    _speechToText.stop();
    setState(() {
      isListening = false;
    });
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
                  image: MemoryImage(images[idx].bytes), width: 120, height: 120,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/ai/load_itineraries.dart';
import 'package:tripedia/view_models/intineraries_viewmodel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../branding.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController _queryController = TextEditingController();

  void generateItineraries() {
    var query = _queryController.text.trim();
    if (query.isEmpty) {
      _showAlert();
      return;
    }

    context.read<ItinerariesViewModel>().loadItineraries(query);
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
            SizedBox.square(dimension: 8),
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
            TalkToMe(onVoiceInput: (String input) {
              setState(() {
                _queryController.text = input;
              });
            }),
            Row(children: [
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
                      /*const Image(
                        width: 38,
                        height: 38,
                        image: AssetImage('assets/images/image.png'),
                      ),*/
                      const Text('Add images for inspiration'),
                    ],
                  ),
                ),
              )
            ]),
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

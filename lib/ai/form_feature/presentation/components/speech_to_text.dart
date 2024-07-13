import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class TalkToMe extends StatefulWidget {
  const TalkToMe({required this.onVoiceInput, super.key});

  final void Function(String words) onVoiceInput;

  @override
  State<TalkToMe> createState() => _TalkToMeState();
}

class _TalkToMeState extends State<TalkToMe> {
  final SpeechToText _speechToText = SpeechToText();
  String mostRecentWords = '';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    mostRecentWords = '';
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
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
      mostRecentWords = mostRecent6Words(result.recognizedWords);
    });
  }

  void _stopListening() async {
    _speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  String mostRecent6Words(String str) {
    var words = str.split(' ');

    debugPrint(words.toString());

    if (words.length < 6) {
      return str;
    } else {
      return words.getRange(words.length - 6, words.length).join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(
          mostRecentWords,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      SizedBox(
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
          ))
    ]);
  }
}

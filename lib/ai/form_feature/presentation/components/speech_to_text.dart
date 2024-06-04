import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

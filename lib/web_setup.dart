import 'package:flutter/foundation.dart';
import "package:universal_html/html.dart" as html;

// Load Pica for flutter_image_compress on web
// See: https://pub.dev/packages/flutter_image_compress#web
// and example code from this issue: https://github.com/flutter/flutter/issues/126131
Future<void> loadPicaScript() async {
  final head = html.window.document.getElementsByTagName('head').first;
  final scriptElement = html.ScriptElement();
  scriptElement.src =
      'https://cdn.jsdelivr.net/npm/pica@9.0.1/dist/pica.min.js';
  scriptElement.onLoad.listen((event) {
    debugPrint('Pica loaded');
  });
  head.append(scriptElement);
}

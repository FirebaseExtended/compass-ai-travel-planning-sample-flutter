import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/view_models/intineraries_viewmodel.dart';

import '../branding.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  void generateItineraries() {
    context.read<ItinerariesViewModel>().loadItineraries();
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
            const Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write anything',
                  border: InputBorder.none,
                ),
              ),
            ),
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

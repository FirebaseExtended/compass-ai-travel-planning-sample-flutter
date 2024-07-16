import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/presentation/components/thumbnail.dart';
import 'package:compass/ai/services/image_handling.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../common/components.dart';

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
    var picked = await _picker.pickMultiImage(
      imageQuality: 20,
      limit: 4,
    );

    if (picked.isEmpty) return;

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
                  image: MemoryImage(images[idx].bytes),
                  width: 120,
                  height: 120,
                ),
              )
                  .animate(interval: 200.ms)
                  .fadeIn(duration: 1000.ms)
                  .scaleXY(begin: 1.1, end: 1, duration: 1000.ms),
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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandGradientShaderMask(
                  child: Icon(
                Icons.image_outlined,
                size: 32,
              )),
              SizedBox.square(dimension: 16),
              Text('Add images for inspiration'),
            ],
          ),
        ),
      )
    ]);
  }
}

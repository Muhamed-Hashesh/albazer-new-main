import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotosSection extends StatelessWidget {
  final List<File> images;
  final ValueChanged<List<File>>? onImagesUpload;
  const UploadPhotosSection({
    super.key,
    this.images = const [],
    this.onImagesUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'تحميل الصور',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).hoverColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Text(
              '5 صور على الأقل',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xff8C8C8C),
                fontSize: 12,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 9.4,
          children: [
            GestureDetector(
              onTap: () async {
                final newImages = await _pickImage();
                log("newImage ${newImages.toString()}");
                onImagesUpload?.call(newImages);
              },
              child: Container(
                width: 78,
                height: 73,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //       color: Theme.of(context).hoverColor, width: 1.5),
                //   borderRadius: BorderRadius.circular(8),
                //   color: Theme.of(context).cardColor,
                // ),
                child: Center(
                  child: Image.asset('assets/images/selecet.png'),
                ),
              ),
            ),
            ...List.generate(images.length, (index) {
              return Container(
                width: 55,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).highlightColor,
                  image: index < images.length
                      ? DecorationImage(
                          image: FileImage(images[index]), fit: BoxFit.cover)
                      : null,
                ),
                // child: index < images.length
                //     ? null
                //     : SvgPicture.asset(
                //         AppIcons.cameraPlus,
                //         fit: BoxFit.scaleDown,
                //         color: const Color(0xff8C8C8C),
                //       ),
              );
            })
          ],
        ),
      ],
    );
  }

  Future<List<File>> _pickImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage(limit: 11);
    if (pickedFiles.isEmpty) return [];
    log("image path${pickedFiles.map((e) => File(e.path)).toList()}");
    return pickedFiles.map((e) => File(e.path)).toList();
  }
}

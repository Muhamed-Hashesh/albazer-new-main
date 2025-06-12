import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class CustomWidegtSlider extends StatelessWidget {
  const CustomWidegtSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity, // Allow dynamic width
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: const Color(0xFFF6F9FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Ensure full width usage
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              // Make the text section responsive
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سلايدر إعلان مدفوع',
                    textAlign: TextAlign.right,
                    style: Styles.style18.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    'لكن لا بد أن أوضح لك أن كل هذه الأفكار المغلوطة حول استنكار النشوة وتمجيد الألم نشأت بالفعل...',
                    textAlign: TextAlign.right,
                    style: Styles.style8,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFED00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'اتصل  الان',
                          textAlign: TextAlign.center,
                          style: Styles.style14.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.phone, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10), // Add spacing between text and image
            SizedBox(
              width: 120, // Set a responsive width for the image
              height: 120,
              child: Image.asset(
                "assets/images/image1.png",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

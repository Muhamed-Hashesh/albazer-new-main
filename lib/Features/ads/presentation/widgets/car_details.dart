import 'package:albazar_app/Features/ads/data/models/details_model.dart';
import 'package:flutter/material.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key, required this.detailsList});
  final List<DetailsModel> detailsList;

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  @override
  Widget build(BuildContext context) {
    // Calculate grid height based on number of items
    int itemCount = widget.detailsList.length;
    int rowCount = (itemCount / 2).ceil(); // Calculate number of rows needed
    double gridHeight = rowCount * 55.0; // Each row height is 55px

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التفاصيل',
            style: TextStyle(
              color: Theme.of(context).hoverColor,
              fontSize: 18,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: gridHeight,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of columns
                crossAxisSpacing: 5,
                mainAxisSpacing: 2,
                childAspectRatio: 3.2, // Adjusted for better proportions
              ),
              itemCount: widget.detailsList.length,
              itemBuilder: (context, index) {
                return DetailsCard(model: widget.detailsList[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.model});
  final DetailsModel model;

  // Helper method to format text for better display
  Widget _buildFormattedText(String text, TextStyle style) {
    List<String> words = text.trim().split(' ');

    if (words.length == 1) {
      // Single word - display in one line
      return Text(
        text,
        style: style,
        textAlign: TextAlign.center,
        // overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    } else if (words.length == 2) {
      // Two words - display each in separate line
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            words[0],
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            words[1],
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    } else {
      // More than two words - display with proper wrapping
      return Text(
        text,
        style: style,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Row(
        children: [
          // Title container with flexible width
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _buildFormattedText(
                  model.tilte ?? '',
                  TextStyle(
                    color: Theme.of(context).hoverColor,
                    fontSize: 12,
                    // fontFamily: 'Noor',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Value container with flexible width
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Center(
                child: _buildFormattedText(
                  model.value ?? "",
                  TextStyle(
                    color: Theme.of(context).hoverColor,
                    fontSize: 12,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

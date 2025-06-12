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
    int index = widget.detailsList.length;
    if (index % 2 == 0) {
      setState(() {
        index = index - 1;
      });
    } else {
      setState(() {
        index = index;
      });
    }
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
            height: widget.detailsList.length == 2
                ? 50
                : widget.detailsList.length == 4
                    ? 100
                    //     ? 200
                    : index * 26.toDouble(),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of columns
                crossAxisSpacing: 5,
                mainAxisSpacing: 2,
                childAspectRatio: 3.5,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      // height: 50,
      // color: Colors.black,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(
      //     color: Theme.of(context).highlightColor,
      //     borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 68,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              model.tilte ?? '',
              style: TextStyle(
                color: Theme.of(context).hoverColor,
                fontSize: 13,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: 80,
            child: Text(
              model.value ?? "",
              style: TextStyle(
                color: Theme.of(context).hoverColor,
                fontSize: 13,
                fontFamily: 'Noor',
                // overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

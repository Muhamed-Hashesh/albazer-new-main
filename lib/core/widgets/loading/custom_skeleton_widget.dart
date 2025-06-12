import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonWidget extends StatelessWidget {
  final bool isLoading, ignoreContainers, isLeaf;
  final Widget child;
  const CustomSkeletonWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.ignoreContainers = false,
    this.isLeaf = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLeaf) {
      return Skeleton.leaf(
        enabled: isLoading,
        child: child,
      );
    }
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: ignoreContainers,
      containersColor: Colors.grey,
      child: child,
    );
  }
}

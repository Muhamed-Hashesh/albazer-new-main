import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/rating/rating_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/rating_form_widget.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/review_tile.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/ulr_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ColumnThree extends StatefulWidget {
  final Ad ad;
  const ColumnThree({
    super.key,
    required this.ad,
  });

  @override
  State<ColumnThree> createState() => _ColumnThreeState();
}

class _ColumnThreeState extends State<ColumnThree> {
  late final LatLng _initialPosition;
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // log('*********${widget.ad.long!.toString()}');

    _initialPosition =
        LatLng(widget.ad.lat!.toDouble(), widget.ad.long!.toDouble());
    _addMarker();
  }

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.ad.id ?? 'property_marker'),
          position: _initialPosition,
          infoWindow: InfoWindow(
            title: widget.ad.adTitle,
            snippet: widget.ad.propertyLocation,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'عرض الموقع على الخريطة',
          style: TextStyle(
            color: Theme.of(context).hoverColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15, // Increased zoom for better visibility
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    // Optional: Animate camera to marker with padding
                    controller.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: LatLng(
                            _initialPosition.latitude - 0.01,
                            _initialPosition.longitude - 0.01,
                          ),
                          northeast: LatLng(
                            _initialPosition.latitude + 0.01,
                            _initialPosition.longitude + 0.01,
                          ),
                        ),
                        50, // padding in pixels
                      ),
                    );
                  },
                  markers: _markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  gestureRecognizers: const {},
                ),
              ),
            ),
            InkWell(
              onTap: () => UrlHelper.openMap(
                  widget.ad.lat!.toDouble(), widget.ad.long!.toDouble()),
              child: const SizedBox(
                height: 250,
                width: double.infinity,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<RatingCubit, RatingState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading &&
                !state.showLoadingOverlay) {
              return CustomSkeletonWidget(
                isLoading: true,
                child: ReviewTile(
                  review: Review(
                    id: '',
                    rating: 0,
                    title: '',
                    listing: '',
                    user: UserHelper.user!,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                ),
              );
            }
            if (state.review != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تقييمات هذا الاعلان',
                        style: TextStyle(
                          color: Theme.of(context).hoverColor,
                          fontSize: 16,
                          fontFamily: 'Noor',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          (context).pushNamed(AppRoutes.ratting, arguments: {
                            'ad': widget.ad,
                            'count': widget.ad.ratingQuantity!.toInt(),
                          });
                        },
                        child: Row(
                          children: [
                            const Text(
                              'عرض الكل',
                              style: TextStyle(
                                color: Color(0xFF8C8C8C),
                                fontSize: 13,
                                fontFamily: 'Noor',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            BlocProvider(
                              create: (context) => locator<CategoryAdsCubit>()
                                ..getCategoryAds(
                                  options: PaginationOptions(
                                    queryOptions: AdsQueryOptions(
                                      query: widget.ad.adTitle,
                                    ),
                                  ),
                                ),
                              child: BlocBuilder<CategoryAdsCubit,
                                  CategoryAdsState>(
                                builder: (context, state) {
                                  if (state.status == RequestStatus.loading) {
                                    // AppMessages.showLoading(context);
                                    return const Center(
                                      child: SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: CircularProgressIndicator(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    );
                                  }
                                  if (state.status == RequestStatus.error) {
                                    return Center(
                                      child: Text(state.error),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        context.pushNamed(AppRoutes.ratting,
                                            arguments: {
                                              'ad': widget.ad,
                                              'count': state
                                                  .ads[0].ratingQuantity!
                                                  .toInt(),
                                            });
                                      },
                                      child: Text(
                                        '(${state.ads[0].ratingQuantity})',
                                        style: const TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontSize: 13,
                                          fontFamily: 'Noor',
                                          fontWeight: FontWeight.w400,
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Color(0xFFD2D2D2),
                  ),
                  const SizedBox(height: 10),
                  ReviewTile(
                    ad: widget.ad,
                    review: state.review!,
                  ),
                ],
              );
            }

            return BlocListener<RatingCubit, RatingState>(
              listener: (context, state) {
                if (state.status == RequestStatus.loading &&
                    state.showLoadingOverlay) {
                  AppMessages.showLoading(context);
                } else {
                  AppMessages.hideLoading(context);
                  if (state.status == RequestStatus.success &&
                      state.message.isNotEmpty) {
                    AppMessages.showSuccess(context, state.message);
                  }
                  if (state.status == RequestStatus.error) {
                    AppMessages.showError(context, state.error);
                  }
                }
              },
              child: RatingFormWidget(
                ad: widget.ad,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

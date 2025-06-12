import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/my%20ads/presentation/cubit/my_ads_cubit.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  final List<String> tabs = ["الكل", "منشور", "معلق", "مرفوض"];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SafeArea(
          child: Column(
            children: [
              const FormHeader(
                title: "إعلاناتك",
                image: AppIcons.yourAds,
                isIcon: true,
                toHome: true,
              ),
              const SizedBox(height: 3),
              Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide.none,
                ),
                child: Container(
                  width: double.infinity,

                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(25),
                  //   color: Colors.white,
                  // ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: SizedBox(
                    height: 37,
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dividerColor: Colors.transparent,
                      labelColor: Theme.of(context).cardColor,
                      isScrollable: true,
                      unselectedLabelColor: Theme.of(context).hoverColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabAlignment: TabAlignment.start,
                      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider(
                      create: (context) => locator<MyAdsCubit>()
                        ..getMyAds(
                          options: const AdsQueryOptions(),
                        ),
                      child: const AdsList(),
                    ),
                    BlocProvider(
                      create: (context) => locator<MyAdsCubit>()
                        ..getMyAds(
                          options: const AdsQueryOptions(),
                        ),
                      child: const AdsList(),
                    ),
                    BlocProvider(
                      create: (context) => locator<MyAdsCubit>()
                        ..getMyAds(
                          options: const AdsQueryOptions(pending: true),
                        ),
                      child: const AdsList(),
                    ),
                    BlocProvider(
                      create: (context) => locator<MyAdsCubit>()
                        ..getMyAds(
                          options: const AdsQueryOptions(rejected: true),
                        ),
                      child: const AdsList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdsList extends StatelessWidget {
  const AdsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAdsCubit, MyAdsState>(
      listener: (context, state) {
        if (state.status == RequestStatus.error && state.ads.isNotEmpty) {
          AppMessages.showError(context, state.error);
        }
        if (state.status == RequestStatus.success && state.message.isNotEmpty) {
          AppMessages.showSuccess(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomSkeletonWidget(
          isLoading: state.status == RequestStatus.loading && state.ads.isEmpty,
          child: state.status == RequestStatus.success && state.ads.isEmpty
              ? const Center(child: Text("لا يوجد اعلانات"))
              : state.status == RequestStatus.loading && state.ads.isEmpty
                  ? _buildLoading()
                  : state.status == RequestStatus.error && state.ads.isEmpty
                      ? Center(child: Text(state.error))
                      : _buildList(ads: state.ads),
        );
      },
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => CustomCardMyAds(
        ad: Ad.fromJson(const {}),
      ),
    );
  }

  Widget _buildList({required List<Ad> ads}) {
    if (ads.isEmpty) {
      return const Center(child: Text("لا يوجد اعلانات"));
    }
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) => CustomCardMyAds(
        ad: ads[index],
      ),
    );
  }
}

class CustomCardMyAds extends StatelessWidget {
  final Ad ad;
  const CustomCardMyAds({
    super.key,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Theme.of(context).highlightColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD2D2D2)),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 49,
            height: 49,
            margin: const EdgeInsets.only(left: 15),
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    (ad.images != null && ad.images!.isNotEmpty)
                        ? ad.images!.first.trim()
                        : 'https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.adTitle,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 16,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ad.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Styles.style13
                      .copyWith(color: Theme.of(context).focusColor),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () async {
                final confirm = (await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("حذف الاعلان؟"),
                        content: const Text("هل تريد حذف الاعلان؟"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("لا"),
                          ),
                          TextButton(
                            onPressed: () {
                              // locator<MyAdsCubit>().deleteAd(ad.id);
                              Navigator.pop(context, true);
                            },
                            child: const Text("نعم"),
                          ),
                        ],
                      ),
                    )) ??
                    false;

                if (!context.mounted || !confirm) return;
                context.read<MyAdsCubit>().removeAd(ad: ad);
              },
              icon: const Icon(
                FontAwesomeIcons.solidTrashCan,
                size: 25,
                color: Color(0xffFFED00),
              ))
        ],
      ),
    );
  }
}

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/details_model.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/additional_features.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/car_details.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ad_user/ad_user_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/column_one.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/column_three.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/column_two.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_card_widegt.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_stack_appbar.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/user_details_bar.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/ulr_helper.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/custom_bottom_nav.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Ad ad;
  const CategoryDetailsScreen({super.key, required this.ad});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final List<String> icons = [
    AppIcons.one,
    AppIcons.two,
    AppIcons.three,
    AppIcons.four,
    AppIcons.five,
    AppIcons.six,
  ];
  final List<String> text = [
    "شقة",
    "مقدم",
    "120m ",
    "2 غرفة",
    "1 حمام",
    "نص تشطيب",
  ];

  final List<String> icons2 = [
    AppIcons.icon5,
    AppIcons.icon6,
    AppIcons.icon7,
    AppIcons.icon8,
    AppIcons.icon9,
    AppIcons.icon10,
    AppIcons.icon11,
    AppIcons.icon12,
  ];

  final List<String> luxuries = [
    "حديقة خاصة",
    "أمن",
    "بلكون",
    "موقف سيارات",
    "أجهزة المطبخ",
    "تليفون أرضى",
    "حمام سباحة",
  ];
  @override
  Widget build(BuildContext context) {
    bool isLand = widget.ad.city != null &&
        widget.ad.paymentMethod != null &&
        widget.ad.regulationStatus != null &&
        widget.ad.year == null;
    bool iscar = widget.ad.brand != null &&
        widget.ad.year != null &&
        widget.ad.version != null &&
        widget.ad.doors != null &&
        widget.ad.paymentMethod != null &&
        widget.ad.seats != null &&
        widget.ad.color != null &&
        widget.ad.innerpart != null;
    bool isForRent = widget.ad.furnishing != null &&
        widget.ad.year != null &&
        widget.ad.city != null &&
        widget.ad.regulationStatus != null &&
        widget.ad.floor != null &&
        widget.ad.rentalRate != null &&
        widget.ad.rentalFees != null;
    bool isForSale = widget.ad.furnishing != null &&
        widget.ad.year != null &&
        widget.ad.regulationStatus != null &&
        widget.ad.floor != null &&
        widget.ad.city != null &&
        widget.ad.paymentMethod != null &&
        widget.ad.propertyCondition != null;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            // height: MediaQuery.sizeOf(context).height - 75,
            child: ListView(
              children: [
                CustomStackAppbar(
                  ad: widget.ad,
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: 432,
                  height: 63,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFD2D2D2),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: BlocBuilder<AdUserCubit, AdUserState>(
                    builder: (context, state) {
                      if (state is AdUserError) {
                        return Center(child: Text(state.error));
                      }
                      return CustomSkeletonWidget(
                        isLoading: state is AdUserLoading,
                        child: UserDetailsBar(
                          rent: widget.ad.listingstatus,
                          user: state is! AdUserLoaded
                              ? UserModel.fromJson(const {})
                              : state.user,
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ColumnOne(ad: widget.ad, icons: icons, text: text),
                ),
                if (widget.ad.amenities != null &&
                    widget.ad.amenities!.isNotEmpty) ...[
                  const Divider(
                    color: Color(0xFF9C9C9C),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ColumnTwo(
                      icons2: icons2,
                      text2: luxuries,
                      ad: widget.ad,
                    ),
                  ),
                ],
                const Divider(
                  color: Color(0xFF9C9C9C),
                ),
                iscar
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarDetails(detailsList: [
                            DetailsModel(
                                tilte: 'الماركة', value: widget.ad.brand),
                            DetailsModel(
                                tilte: 'الحالة',
                                value: widget.ad.listingstatus),
                            DetailsModel(
                                tilte: 'كيلومترات',
                                value: widget.ad.kilometers),
                            DetailsModel(tilte: 'موديل', value: widget.ad.year),
                            DetailsModel(
                                tilte: 'سنة الصنع',
                                value: widget.ad.manufacturingYear),
                            DetailsModel(
                                tilte: 'قوة الحصان ',
                                value: widget.ad.horsePower),
                            DetailsModel(
                                tilte: 'سعة المحرك  ',
                                value: widget.ad.engineCapacity),
                            DetailsModel(
                                tilte: 'لون السيارة', value: widget.ad.color),
                            DetailsModel(
                                tilte: 'قوة الدفع',
                                value: widget.ad.drivetrain),
                            DetailsModel(
                                tilte: 'الوارد', value: widget.ad.imported),
                            DetailsModel(
                                tilte: 'عدد المقاعد', value: widget.ad.seats),
                            DetailsModel(
                                tilte: 'نوع السيارة', value: widget.ad.carType),
                            DetailsModel(
                                tilte: 'الدفع', value: widget.ad.paymentMethod),
                            DetailsModel(
                                tilte: 'من قبل', value: widget.ad.publishedVia),
                          ]),
                          widget.ad.additionalFeatures != null &&
                                  widget.ad.additionalFeatures!.isNotEmpty
                              ? AdditionalFeatures(
                                  additionalFeatures:
                                      widget.ad.additionalFeatures!)
                              : Container(),
                        ],
                      )
                    : isForSale
                        ? CarDetails(detailsList: [
                            DetailsModel(
                                tilte: 'نوع العقار',
                                value: widget.ad.propertyType),
                            DetailsModel(
                                tilte: 'حالة العقار',
                                value: widget.ad.propertyCondition),
                            DetailsModel(
                              tilte: 'التنظيم',
                              value: widget.ad.regulationStatus,
                            ),
                            DetailsModel(
                              tilte: 'المساحه',
                              value: "${widget.ad.area}",
                            ),
                            DetailsModel(
                                tilte: 'الطابق', value: widget.ad.floor),
                            DetailsModel(
                                tilte: 'عدد الطوابق',
                                value: widget.ad.floorNumber),
                            DetailsModel(
                                tilte: 'عدد الغرف',
                                value: "${widget.ad.numberOfRooms}"),
                            DetailsModel(
                                tilte: 'عدد الصالونات',
                                value: "${widget.ad.numberOfSalons}"),
                            DetailsModel(
                                tilte: 'عدد الحمامات',
                                value: "${widget.ad.numberOfBathrooms}"),
                            DetailsModel(
                                tilte: 'عمر\n المبنى', value: widget.ad.year),
                            DetailsModel(
                                tilte: 'مفروش',
                                value: widget.ad.furnishing == true
                                    ? 'نعم'
                                    : 'لا '),
                            DetailsModel(
                                tilte: 'حالة\nالمبنى',
                                value: widget.ad.propertyCondition),
                            DetailsModel(
                                tilte: 'الدفع', value: widget.ad.paymentMethod),
                            DetailsModel(
                                tilte: 'أدخل الطابو', value: widget.ad.deed),
                            DetailsModel(
                                tilte: 'المحافظة', value: widget.ad.city),
                          ])
                        : isForRent
                            ? CarDetails(detailsList: [
                                DetailsModel(
                                    tilte: 'نوع العقار',
                                    value: widget.ad.propertyType),
                                DetailsModel(
                                    tilte: 'حالة العقار',
                                    value: widget.ad.propertyCondition),
                                DetailsModel(
                                  tilte: 'التنظيم',
                                  value: widget.ad.regulationStatus,
                                ),
                                DetailsModel(
                                  tilte: 'المساحه',
                                  value: "${widget.ad.area}",
                                ),
                                DetailsModel(
                                    tilte: 'الطابق', value: widget.ad.floor),
                                DetailsModel(
                                    tilte: 'عدد الطوابق',
                                    value: widget.ad.floorNumber),
                                DetailsModel(
                                    tilte: 'عدد الغرف',
                                    value: "${widget.ad.numberOfRooms}"),
                                DetailsModel(
                                    tilte: 'عدد الصالونات',
                                    value: "${widget.ad.numberOfSalons}"),
                                DetailsModel(
                                    tilte: 'عدد الحمامات',
                                    value: "${widget.ad.numberOfBathrooms}"),
                                DetailsModel(
                                    tilte: 'عمر\n المبنى',
                                    value: widget.ad.year),
                                DetailsModel(
                                    tilte: 'مفروش',
                                    value: widget.ad.furnishing == true
                                        ? 'نعم'
                                        : 'لا '),
                                DetailsModel(
                                    tilte: 'حالة\nالمبنى',
                                    value: widget.ad.propertyCondition),
                                DetailsModel(
                                    tilte: 'الدفع',
                                    value: widget.ad.paymentMethod),
                                DetailsModel(
                                    tilte: 'المحافظة', value: widget.ad.city),
                              ])
                            : isLand
                                ? CarDetails(detailsList: [
                                    DetailsModel(
                                        tilte: 'النوع',
                                        value: widget.ad.propertyType),
                                    DetailsModel(
                                        tilte: 'الحالة',
                                        value: widget.ad.listingstatus),
                                    DetailsModel(
                                      tilte: 'التنظيم',
                                      value: widget.ad.regulationStatus,
                                    ),
                                    DetailsModel(
                                      tilte: 'المساحة',
                                      value: "${widget.ad.area}",
                                    ),
                                    DetailsModel(
                                        tilte: 'الدفع',
                                        value: widget.ad.paymentMethod),
                                    DetailsModel(
                                        tilte: 'المحافظة',
                                        value: widget.ad.city),
                                  ])
                                : Container(),
                const Divider(
                  color: Color(0xFF9C9C9C),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ColumnThree(
                    ad: widget.ad,
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async => await UrlHelper.openPhone(
                        number: widget.ad.phoneNumber!,
                      ),
                      child: const CustomCardWidget(
                        icon: Icons.call,
                        text: "اتصال",
                      ),
                    ),
                    BlocBuilder<AdUserCubit, AdUserState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            if (state is! AdUserLoaded) return;
                            final user = state.user;
                            if (user.id.isEmpty) return;
                            context.pushNamed(AppRoutes.chat, arguments: user);
                          },
                          child: const CustomCardWidget(
                            icon: Icons.chat,
                            text: "دردشة",
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () async => await UrlHelper.openWhatsapp(
                        number: widget.ad.phoneNumber!,
                      ),
                      child: const CustomCardWidget(
                        icon: FontAwesomeIcons.whatsapp,
                        text: "واتساب",
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          const CustomBottomNav()
        ],
      ),
    ));
  }
}

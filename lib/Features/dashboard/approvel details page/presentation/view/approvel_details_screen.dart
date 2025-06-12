import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/cubit/approval_cubit.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/custtom_button.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_buildings_and_lands.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_cars.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_rent.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_sale.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/cusrom_appbar_approvel_details.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovelDetailsScreen extends StatefulWidget {
  final Ad ad;
  const ApprovelDetailsScreen({super.key, required this.ad});

  @override
  State<ApprovelDetailsScreen> createState() => _ApprovelDetailsScreenState();
}

class _ApprovelDetailsScreenState extends State<ApprovelDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBarApprovelDetails(
                isHome: false,
                // logoutOnPressed: () =>
                //     Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const UsersScreen(),
                // )),
              ),
              const SizedBox(
                height: 20,
              ),
              //////////////////////////////////////////
              IgnorePointer(
                child: _buildForm(),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocListener<ApprovalCubit, ApprovalState>(
                listener: (context, state) {
                  if (state is ApprovalLoading) {
                    AppMessages.showLoading(context);
                  } else {
                    AppMessages.hideLoading(context);
                    if (state is ApprovalError) {
                      AppMessages.showError(context, state.error);
                    }
                    if (state is ApprovalSuccess) {
                      AppMessages.showSuccess(context, state.message);
                      context.pop(true);
                    }
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onTap: () => context
                          .read<ApprovalCubit>()
                          .accept(id: widget.ad.id!),
                      icon: Icons.done_outline_outlined,
                      text: "موافقة",
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomButton(
                      onTap: () => context
                          .read<ApprovalCubit>()
                          .reject(id: widget.ad.id!),
                      icon: Icons.cancel,
                      text: "رفض",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              IconButton(
                  onPressed: () {
                    log("messages: ${widget.ad.category}");
                  },
                  icon: Icon(Icons.text_snippet))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() => switch (widget.ad.category) {
        '68168126919277fc38d33023' => ApprovelFormRent(
            ad: widget.ad,
          ),
        '681680fb919277fc38d33021' => ApprovelFormSale(
            ad: widget.ad,
          ),
        '68168137919277fc38d33025' => ApprovelFormBuildingsAndLands(
            ad: widget.ad,
          ),
        '6816814c919277fc38d33027' => ApprovelFormCars(
            ad: widget.ad,
          ),
        _ => Text('Unknown category: ${widget.ad.category}'),
      };
}

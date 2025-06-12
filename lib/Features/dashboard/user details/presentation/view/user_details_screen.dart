import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/cusrom_appbar_approvel_details.dart';
import 'package:albazar_app/Features/dashboard/user%20details/presentation/widget/custom_textfield_users.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;
  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final TextEditingController _firstNameController =
      TextEditingController(text: widget.user.firstName);
  late final TextEditingController _lastNameController =
      TextEditingController(text: widget.user.lastName);
  late final TextEditingController _phoneController =
      TextEditingController(text: widget.user.phone);
  late final TextEditingController _emailController =
      TextEditingController(text: widget.user.email);
  late final TextEditingController _birthdayController = TextEditingController(
      text: widget.user.birthday == null
          ? ''
          : DateFormat("yyyy/MM/dd").format(widget.user.birthday!));
  late final TextEditingController _cityController =
      TextEditingController(text: widget.user.city);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Enable scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarApprovelDetails(
                isHome: false,
                logoutOnPressed: () async {
                  await UserHelper.logout();
                  if (!context.mounted) return;
                  context.pushNamedAndRemoveUntil(AppRoutes.login);
                  AppMessages.showSuccess(context, 'تم تسجيل الخروج');
                },
              ),
              const SizedBox(height: 3),
              Container(
                width: double.infinity,
                height: 74.h,
                padding: const EdgeInsets.all(9.63),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFED00),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserAvatar(url: widget.user.profileImage ?? ''),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.user.firstName} ${widget.user.lastName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF1D1D1B),
                            fontSize: 16.sp,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'مشترك منذ ${widget.user.createdAt.year}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xff1D1D1B),
                            fontSize: 10,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                // height: MediaQuery.of(context).size.height * .19,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                ),
                child: Column(
                  children: [
                    // const SizedBox(height: 10),
                    Text(
                      'عدد الإعلانات الخاصة بالحساب',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 16.sp,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'الرصيد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 13.sp,
                                fontFamily: 'Noor',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                '${widget.user.balance}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).hoverColor,
                                  fontSize: 13.sp,
                                  fontFamily: 'Noor',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              'المتبقى',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 13.sp,
                                fontFamily: 'Noor',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                '3',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).hoverColor,
                                  fontSize: 13.sp,
                                  fontFamily: 'Noor',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  // Wrap ListView inside SizedBox to prevent infinite height issue
                  height: 400, // You can adjust this height
                  child: ListView(
                    children: [
                      CustomTextFieldUsers(
                        hintText: "الاسم المدخل",
                        lable: "الاسم الأول",
                        controller: _firstNameController,
                      ),
                      CustomTextFieldUsers(
                        lable: "الاسم الاخير",
                        hintText: "الاسم المدخل",
                        controller: _lastNameController,
                      ),
                      CustomTextFieldUsers(
                        lable: "رقم الموبايل",
                        hintText: "الرقم المدخل",
                        controller: _phoneController,
                      ),
                      CustomTextFieldUsers(
                        lable: "البريد الإلكترونى",
                        hintText: "الايميل المدخل",
                        controller: _emailController,
                      ),
                      CustomTextFieldUsers(
                        lable: "تاريخ الميلاد",
                        hintText: "التاريخ",
                        controller: _birthdayController,
                        icon: SvgPicture.asset(
                          AppIcons.calendar,
                          color: Theme.of(context).hoverColor,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      CustomTextFieldUsers(
                        lable: "المحافظة",
                        hintText: "المحافظة المدخلة",
                        controller: _cityController,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

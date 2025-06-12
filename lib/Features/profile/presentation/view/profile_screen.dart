import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/Features/profile/presentation/cubit/profile_cubit.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/theme_provider.dart';
import 'package:albazar_app/core/helper/ulr_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:albazar_app/core/widgets/dialogs/session_expired_dialog.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> passwordFormKey = GlobalKey();

  File? image;
  String phonenumber = '';
  @override
  void initState() {
    firstNameController.text = UserHelper.user?.firstName ?? '';
    lastNameController.text = UserHelper.user?.lastName ?? '';
    phoneController.text = UserHelper.user?.phone ?? '';
    cityController.text = UserHelper.user?.city ?? '';
    dobController.text = UserHelper.user?.birthday == null
        ? ''
        : DateFormat("yyyy/MM/dd").format(UserHelper.user!.birthday!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

          backgroundColor: Theme.of(context).highlightColor,
          // elevation: 0,
          onPressed: () {
            context.pushNamed(AppRoutes.chatHome);
            // context.pushNamed(AppRoutes.userPage);
          },
          child: SvgPicture.asset(
            "assets/icons/chat.svg",
            color: Theme.of(context).focusColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const FormHeader(
              title: "حسابى",
              image: AppIcons.profile,
              isIcon: true,
              toHome: true,
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // width: 387,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.only(
                              top: 15,
                              // left: 10,
                              right: 15,
                              bottom: 15,
                            ),
                            decoration: ShapeDecoration(
                              color: Theme.of(context).highlightColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).highlightColor),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable:
                                            UserHelper.userNotifier,
                                        builder: (context, user, _) {
                                          return UserAvatar(
                                            radius: 24,
                                            url: user?.profileImage ?? '',
                                            file: image,
                                          );
                                        }),
                                    PositionedDirectional(
                                      bottom: -4,
                                      end: -4,
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: FittedBox(
                                          child: IconButton.filled(
                                            color: Colors.black,
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  AppColor.coverPageColor,
                                            ),
                                            onPressed: () async =>
                                                await _pickImage(context),
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const Icon(Icons.person_2_sharp),
                                const SizedBox(
                                  width: 8,
                                ),
                                ValueListenableBuilder(
                                    valueListenable: UserHelper.userNotifier,
                                    builder: (context, user, _) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${user?.firstName} ${user?.lastName}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hoverColor,
                                              fontSize: 18,
                                              fontFamily: 'Noor',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'مشترك منذ ${user?.createdAt.year}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hoverColor,
                                              fontSize: 13,
                                              fontFamily: 'Noor',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRoutes.myAds);
                            },
                            child: Container(
                              width: double.infinity,
                              // margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 15,
                                right: 15,
                                bottom: 15,
                              ),
                              decoration: ShapeDecoration(
                                color: Theme.of(context).highlightColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).highlightColor),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'إعلاناتى',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).focusColor,
                                      fontSize: 18,
                                      fontFamily: 'Noor',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'اسم الحساب',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 16,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'هذا الاسم سوف يظهر علي الحساب',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 13,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomTextField(
                                labelText: "الاسم الأول",
                                controller: firstNameController,
                                validator: ValidationHelper.validateFirstName,
                              )),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                  child: CustomTextField(
                                labelText: "الاسم الأخير",
                                controller: lastNameController,
                                validator: ValidationHelper.validateLastName,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'تغيير كلمة مرور جديدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 16,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Form(
                            key: passwordFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  labelText: "كلمه المرور الحاليه",
                                  controller: currentPasswordController,
                                  obscureText: true,
                                  validator: ValidationHelper.validatePassword,
                                ),
                                CustomTextField(
                                  labelText: "كلمه مرور جديده",
                                  controller: newPasswordController,
                                  validator: ValidationHelper.validatePassword,
                                  obscureText: true,
                                ),
                                CustomTextField(
                                  labelText: "تاكيد كلمه المرور ",
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  validator: (value) =>
                                      ValidationHelper.validateConfirmPassword(
                                          newPasswordController.text, value!),
                                ),
                                BlocProvider(
                                  create: (context) => locator<ProfileCubit>(),
                                  child: Builder(builder: (context) {
                                    return BlocListener<ProfileCubit,
                                        ProfileState>(
                                      listener: (context, state) {
                                        if (state is ProfileLoading) {
                                          AppMessages.showLoading(context);
                                        } else {
                                          AppMessages.hideLoading(context);
                                          if (state is ProfileError) {
                                            AppMessages.showError(
                                                context, state.error);
                                          }

                                          if (state is ProfileUpdated) {
                                            AppMessages.showSuccess(
                                                context, state.message);
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  const SessionExpiredDialog(),
                                            );
                                          }
                                        }
                                      },
                                      child: CustomButtonAuth(
                                        onPressed: () {
                                          if (!passwordFormKey.currentState!
                                              .validate()) return;
                                          final options = ChangePasswordOptions(
                                            currentPassword:
                                                currentPasswordController.text
                                                    .trim(),
                                            password: newPasswordController.text
                                                .trim(),
                                            confirmPassword:
                                                confirmPasswordController.text
                                                    .trim(),
                                          );
                                          context
                                              .read<ProfileCubit>()
                                              .changePassword(options: options);
                                        },
                                        title: "تحديث كلمه المرور",
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'تفاصيل الحساب',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 16,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'هذه المعلومات لا تظهر للمستخدمين',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 13,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            labelText: "تاريخ الميلاد",
                            controller: dobController,
                            readOnly: true,
                            onTap: () {
                              final date = dobController.text.trim().isEmpty
                                  ? DateTime.now()
                                  : DateTime.parse(dobController.text
                                      .trim()
                                      .replaceAll("/", "-"));
                              log("$date");
                              showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((date) {
                                if (date == null) return;
                                dobController.text =
                                    DateFormat("yyyy/MM/dd").format(date);
                              });
                            },
                          ),
                          CustomTextField(
                            labelText: "رقم موبايل",
                            controller: phoneController,
                            // validator: ValidationHelper.validatePhoneNumber,
                          ),
                          // CustomPhoneField(
                          //   labelText: 'رقم موبايل',
                          //   controller: phoneController,
                          //   onChanged: (phone) {
                          //     phonenumber = phone?.completeNumber ?? '';
                          //     log('📞 ${phone?.completeNumber}');
                          //     log('📞2 $phonenumber');
                          //     log('📞 ${phoneController.text}');
                          //   },
                          // ),
                          CustomTextField(
                            labelText: "المدينه",
                            controller: cityController,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: () =>
                                UrlHelper.openPhone(number: '+905379264680'),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.suppot,
                                  color: Theme.of(context).hoverColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'للدعم والتواصل والاعلان',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Theme.of(context).focusColor,
                                    fontSize: 16,
                                    fontFamily: 'Noor',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 100,
                            child: DayNightSwitch(
                              value: themeProvider.themeMode == ThemeMode.dark,
                              onChanged: (isOn) {
                                themeProvider.toggleTheme(isOn);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await UserHelper.logout();
                              await FirebaseMessaging.instance.deleteToken();

                              if (!context.mounted) return;
                              context.pushNamedAndRemoveUntil(AppRoutes.login);
                              AppMessages.showSuccess(
                                  context, 'تم تسجيل الخروج');
                              // final tokenResult =
                              //     await NotificationFactory().getFCMToken();
                              // tokenResult.fold(
                              //   (error) =>
                              //       log("Error fetching FCM token: $error"),
                              //   (token) => log("FCM Token: $token"),
                              // );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.exit_to_app),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'تسجيل خروج',
                                  style: TextStyle(
                                    color: Theme.of(context).focusColor,
                                    fontSize: 13,
                                    fontFamily: 'Noor',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: BlocListener<ProfileCubit, ProfileState>(
                              listener: (context, state) {
                                if (state is ProfileLoading) {
                                  AppMessages.showLoading(context);
                                } else {
                                  AppMessages.hideLoading(context);
                                  if (state is ProfileError) {
                                    AppMessages.showError(context, state.error);
                                  }
                                  if (state is ProfileUpdated) {
                                    AppMessages.showSuccess(
                                      context,
                                      state.message,
                                    );
                                    // image = null;
                                    setState(() {});
                                  }
                                }
                              },
                              child: CustomButtonAuth(
                                title: "تحديث المعلومات",
                                onPressed: () {
                                  if (!formKey.currentState!.validate()) return;
                                  final user = UserHelper.user?.copyWith(
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    // profileImage: image?.path,
                                    city: cityController.text.trim(),
                                    birthday: dobController.text.trim().isEmpty
                                        ? null
                                        : DateTime.parse(dobController.text
                                            .trim()
                                            .replaceAll("/", "-")),
                                  );

                                  if (user == null) return;

                                  log("user: ${phoneController.text.trim()}");
                                  log("user: ${cityController.text.trim()}");
                                  log("user: ${DateTime.parse(dobController.text.trim().replaceAll("/", "-")).toString}");

                                  context
                                      .read<ProfileCubit>()
                                      .updateUser(user: user);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                leading: const Icon(Icons.camera),
                title: const Text("الكاميرا"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("المعرض"),
              ),
            ],
          );
        });
    if (source == null) return;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    image = File(pickedFile.path);
    setState(() {});

    final user = UserHelper.user?.copyWith(
      profileImage: image?.path,
    );

    if (user == null) return;

    // Trigger backend update when image is picked
    context.read<ProfileCubit>().updateUser(user: user);
  }
}

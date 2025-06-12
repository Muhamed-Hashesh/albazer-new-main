import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/Featured%20Items/presentation/view/featured_items_screen.dart';
import 'package:albazar_app/Features/ads/presentation/view/select_category_screen.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/cusrom_appbar_approvel_details.dart';
import 'package:albazar_app/Features/dashboard/approvel%20page/presentation/view/approvel_screen.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/cubit/list_users_cubit.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/view/users_screen.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/Features/favorite/presentation/view/favorite_screen.dart';
import 'package:albazar_app/Features/home/presentation/view/home_screen.dart';
import 'package:albazar_app/Features/profile/presentation/cubit/profile_cubit.dart';
import 'package:albazar_app/Features/profile/presentation/view/profile_screen.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/socket_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/dialogs/session_expired_dialog.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({required this.currentIndex, super.key});
  int currentIndex = 0; // Active index for navigation
  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  // ignore: unused_element
  void _onTabSelected(int index) {
    if (index == 3) {
      // If "New Screen" is selected
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => CategoryScreen()),
      // );
    } else {
      setState(() {
        widget.currentIndex = index;
      });
    }
  }

  final List<IconData> _iconList = [
    Icons.home_outlined,
    Icons.favorite_border,
    Icons.add_box_outlined,
    Icons.star_border_outlined,
    Icons.person_outline_outlined,
    // Icons.person
  ];

  late final List<Widget> _screens = UserHelper.user!.role == UserRole.admin
      ? [
          BlocProvider(
            create: (context) => locator<ListUsersCubit>()
              ..refreshUsers(
                options: const PaginationOptions(),
              ),
            child: const UsersScreen(),
          ),
          const ApprovelScreen(),
        ]
      : [
          HomeScreen(
            onProfileTap: _goToProfile,
            onMessagesTap: () => _goToMessages(context),
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    locator<FavoriteAdCubit>()..getFavoriteAds(),
              ),
              BlocProvider(
                create: (context) => locator<FeaturedAdCubit>(),
              ),
            ],
            child: const FavoriteScreen(),
          ),
          // Center(child: Text("add New ads", style: TextStyle(fontSize: 22))),
          const SelectCategoryScreen(),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<FavoriteAdCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    locator<FeaturedAdCubit>()..getFeaturedAds(),
              ),
            ],
            child: const FeaturedItemsScreen(),
          ),
          BlocProvider(
            create: (context) => locator<ProfileCubit>(),
            child: const ProfileScreen(),
          )
        ];

  void _checkSession(BuildContext context) {
    if (SocketHelper.socket == null || !SocketHelper.socket!.connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => const SessionExpiredDialog(),
        );
      });
    }
  }

  void _goToProfile() {
    setState(() {
      widget.currentIndex = 4;
    });
  }

  void _goToMessages(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.chatHome);
  }

  @override
  Widget build(BuildContext context) {
    // _checkSession(context);
    return PopScope(
      canPop: false,
      // onPopInvokedWithResult: (didPop, _) async {
      //   if (widget.currentIndex != 0) {
      //     setState(() {
      //       widget.currentIndex = 0;
      //     });
      //     return;
      //   }
      onPopInvoked: (didPop) async {
        if (widget.currentIndex != 0) {
          setState(() {
            widget.currentIndex = 0;
          });
          return;
        }

        final canExit = await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).highlightColor,
                    title: const Text("هل تريد الخروج من التطبيق"),
                    actions: [
                      TextButton(
                        child: const Text("لا"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("نعم"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                }) ??
            false;

        if (!canExit) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: UserHelper.user!.role == UserRole.admin
            ? CustomAppBarApprovelDetails(
                isHome: true,
                logoutOnPressed: () async {
                  await UserHelper.logout();
                  if (!context.mounted) return;
                  context.pushNamedAndRemoveUntil(AppRoutes.login);
                  AppMessages.showSuccess(context, 'تم تسجيل الخروج');
                },
              )
            : null,
        body: _screens[widget.currentIndex],
        // body: IndexedStack(
        //   index: widget.currentIndex,
        //   children: _screens,
        // ),

        bottomNavigationBar: UserHelper.user!.role == UserRole.admin
            ? AdminBottomBar(
                currentIndex: widget.currentIndex,
                onChange: (index) {
                  setState(() {
                    widget.currentIndex = index;
                  });
                },
                items: List.generate(2, (index) {
                  return AdminNavItem(
                    isSelected: widget.currentIndex == index,
                    icon: index == 1 ? AppIcons.ads : AppIcons.users,
                    label: index == 1 ? "الإعلانات" : "المستخدمين",
                  );
                }),
              )
            : AnimatedBottomNavigationBar(
                icons: _iconList,
                activeIndex: widget.currentIndex,
                // gapLocation: GapLocation.center, // Creates space for FAB
                notchSmoothness: NotchSmoothness.softEdge, // Smooth animation
                gapWidth: 2,
                backgroundColor: Theme.of(context).highlightColor,
                iconSize: 35,

                activeColor: const Color(0xffFFED00),
                inactiveColor: Theme.of(context).focusColor.withOpacity(.9),
                onTap: (index) {
                  setState(() {
                    widget.currentIndex = index; // Change active tab
                  });
                },
              ),
      ),
    );
  }
}

class AdminBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;
  final List<AdminNavItem> items;
  const AdminBottomBar({
    super.key,
    required this.currentIndex,
    required this.onChange,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(
          items.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onChange(index),
              child: items[index],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminNavItem extends StatelessWidget {
  final bool isSelected;
  final String label, icon;
  const AdminNavItem({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: isSelected
                ? AppColor.coverPageColor
                : Theme.of(context).hoverColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xffFFED00) : null,
            ),
          ),
        ],
      ),
    );
  }
}

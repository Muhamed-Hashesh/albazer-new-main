import 'package:albazar_app/Features/category/presentation/view/category_screen.dart';
import 'package:albazar_app/Features/dashboard/user%20details/presentation/view/user_details_screen.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/cubit/list_users_cubit.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/widget/custom_card_users.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/debounce_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _query = "";

  final DebounceHelper _debounce = DebounceHelper();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.person),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'عدد المستخدمين',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1D1D1B),
                          fontSize: 17.33,
                          fontFamily: 'Noor',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.chart),
                      const SizedBox(
                        width: 5,
                      ),
                      BlocProvider(
                        create: (context) =>
                            locator<ListUsersCubit>()..getNumberOfUsers(),
                        child: Builder(builder: (context) {
                          return BlocBuilder<ListUsersCubit, ListUsersState>(
                            builder: (context, state) {
                              return Text(
                                "(${state.numberOfUsers.toString()})",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF1D1D1B),
                                  fontSize: 15.41,
                                  fontFamily: 'Noor',
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  if (value.isEmpty) {
                    _debounce.cancel();
                    _query = "";
                    _refresh(context);
                    // context.read<CategoryAdsCubit>().refreshCategoryAds(
                    //       options: PaginationOptions(
                    //         queryOptions: AdsQueryOptions(
                    //           category: widget.category.id,
                    //           others: _filters,
                    //         ),
                    //       ),
                    //     );
                    setState(() {});
                    return;
                  }
                  _debounce.debounce(callback: () {
                    _query = value.trim();
                    _refresh(context);
                    // context.read<CategoryAdsCubit>().refreshCategoryAds(
                    //       options: PaginationOptions(
                    //         queryOptions: AdsQueryOptions(
                    //           category: widget.category.id,
                    //           query: _query,
                    //           others: _filters,
                    //         ),
                    //       ),
                    //     );
                    setState(() {});
                  });
                },
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "ابحث عن مستخدم  ...",
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).hoverColor,
                    size: 25,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ListUsersCubit, ListUsersState>(
                builder: (context, state) {
                  return CustomRefreshWidget(
                    onRefresh: () => _refresh(context),
                    child: LazyLoadingView.list(
                      scrollController: _scrollController,

                      shrinkWrap: true,
                      primary: false,
                      onRequest: () async {
                        if (state.isLastPage) return;
                        context.read<ListUsersCubit>().getUsers(
                              options: PaginationOptions(
                                query: _query,
                              ),
                            );
                        // await Future.delayed(const Duration(seconds: 2), () {
                        //   _page++;
                        //   setState(() {
                        //     _isLoading = false;
                        //   });
                        //   log("request end: $_page");
                        // });
                      },
                      firstPageLoader: CustomSkeletonWidget(
                        isLoading: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => _loadingUsers[index],
                          itemCount: _loadingUsers.length,
                        ),
                      ),
                      loader: CustomSkeletonWidget(
                        isLoading: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomCardUsers(
                            user: UserHelper.user!,
                            onTap: () {},
                          ),
                        ),
                      ),
                      page: state.page,

                      // error: 'ssdsd',
                      limit: 10,
                      isLoading: state.status == RequestStatus.loading,
                      isLastPage: state.isLastPage,
                      error: state.error,
                      items: List.generate(
                        state.users.length,
                        (index) => CustomCardUsers(
                          user: state.users[index],
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(
                              user: state.users[index],
                            ),
                          )),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // child: ListView.builder(
              //   itemCount: 10,
              //   itemBuilder: (context, index) => CustomCardUsers(
              //     onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => const UserDetailsScreen(),
              //     )),
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> get _loadingUsers => List.generate(
        10,
        (_) => CustomCardUsers(
          user: UserHelper.user!,
        ),
      );

  Future<void> _refresh(BuildContext context) async {
    context.read<ListUsersCubit>().refreshUsers(
          options: PaginationOptions(
            query: _query,
          ),
        );
  }
}

import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/ads/presentation/view/google_map_screen.dart';
import 'package:albazar_app/Features/ads/presentation/view/new_ad_screen.dart';
import 'package:albazar_app/Features/ads/presentation/view/select_category_screen.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/forget_password/forget_password_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/reset_password/reset_password_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/verify_password/verify_password_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/views/confirm_password_view.dart';
import 'package:albazar_app/Features/auth/presentation/views/forget_password_view.dart';
import 'package:albazar_app/Features/auth/presentation/views/login_view.dart';
import 'package:albazar_app/Features/auth/presentation/views/signup_view.dart';
import 'package:albazar_app/Features/auth/presentation/views/verification_view.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ad_user/ad_user_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/rating/rating_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/reviews/reviews_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/category_details_screen.dart';
import 'package:albazar_app/Features/category/presentation/view/category_screen.dart';
import 'package:albazar_app/Features/category/presentation/view/ratting_screen.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/chats/chats_cubit.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/messages/messages_cubit.dart';
import 'package:albazar_app/Features/chat/presentation/view/chat_home_screen.dart';
import 'package:albazar_app/Features/chat/presentation/view/chat_screen.dart';
import 'package:albazar_app/Features/cover/presentation/view/cover_view.dart';
import 'package:albazar_app/Features/dashboard/approvel%20page/presentation/view/approvel_screen.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/view/users_screen.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/Features/main-home/presentation/view/main_home_screen.dart';
import 'package:albazar_app/Features/my%20ads/presentation/view/my_ads_screen.dart';
import 'package:albazar_app/Features/profile/presentation/view/user_screen.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  const AppRouter._();
  static final initialRoute =
      UserHelper.isLoggedIn ? AppRoutes.home : AppRoutes.cover;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //////////cover_screen////////////////////////
      case AppRoutes.cover:
        return MaterialPageRoute(
          builder: (_) => const CoverView(),
        );
      //////////login_screen////////////////////////
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => locator<LoginCubit>(),
            child: const LoginView(),
          ),
        );
      //////////signUp_screen////////////////////////
      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => locator<SignupCubit>(),
            child: const SignUpView(),
          ),
        );
      //////////forgetpassword_screen////////////////////////
      case AppRoutes.forgetPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => locator<ForgetPasswordCubit>(),
            child: const ForgetpasswordView(),
          ),
        );
      //////////verification_screen////////////////////////
      case AppRoutes.verification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => locator<VerifyPasswordCubit>(),
            child: VerificationView(
              email: settings.arguments as String,
            ),
          ),
        );
      //////////confirmPassword_screen////////////////////////
      case AppRoutes.confirmPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => locator<ResetPasswordCubit>(),
            child: ConfirmPasswordScreen(
              email: settings.arguments as String,
            ),
          ),
        );
      //////////home_screen////////////////////////
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) {
            final index = settings.arguments as int?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<CategoriesCubit>()
                    ..getCategories(
                      options: const PaginationOptions(),
                    ),
                ),
                BlocProvider(
                  create: (context) => locator<CategoryAdsCubit>()
                    ..getCategoryAds(
                      options: const PaginationOptions(
                        queryOptions: AdsQueryOptions(),
                      ),
                    ),
                ),
              ],
              child: MainHomeScreen(
                currentIndex: index ?? 0,
              ),
            );
          },
        );
      //////////categories_screen////////////////////////
      case AppRoutes.categories:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<CategoriesCubit>()
                  ..getCategories(
                    options: const PaginationOptions(),
                  ),
              ),
            ],
            child: const SelectCategoryScreen(),
          ),
        );
      //////////category_screen////////////////////////
      case AppRoutes.category:
        return MaterialPageRoute(
          builder: (_) {
            final category = settings.arguments as Category;
            // final title = settings.arguments as String;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => locator<CategoryAdsCubit>()),
              ],
              child: CategoryScreen(
                category: category,
                // title: title,
              ),
            );
          },
        );
      //////////newAd_screen////////////////////////
      case AppRoutes.newAd:
        return MaterialPageRoute(
          builder: (_) {
            final category = settings.arguments as Category;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<NewAdCubit>(),
                ),
              ],
              child: NewAdScreen(
                category: category,
              ),
            );
          },
        );
      //////////myAd_screen////////////////////////
      case AppRoutes.myAds:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      locator<NewAdCubit>(), // change the cubit to my ads.
                ),
              ],
              child: const MyAdsScreen(),
            );
          },
        );
      //////////chatHome_screen////////////////////////
      case AppRoutes.chatHome:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<ChatsCubit>()
                    ..getChats(), // change the cubit to chatHome.
                ),
              ],
              child: const ChatHomeScreen(),
            );
          },
        );
      //////////chat_screen////////////////////////
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) {
            final user = settings.arguments as UserModel;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<MessagesCubit>()
                    ..getMessages(
                      id: user.id,
                    ), // change the cubit to chatScreen.
                ),
              ],
              child: ChatScreen(
                user: user,
              ),
            );
          },
        );
      //////////categoryDetails_screen////////////////////////
      case AppRoutes.categoryDetails:
        return MaterialPageRoute(
          builder: (_) {
            final ad = settings.arguments as Ad;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<NewAdCubit>(),
                ),
                BlocProvider(
                  create: (context) => locator<FavoriteAdCubit>(),
                ),
                BlocProvider(
                  create: (context) => locator<FeaturedAdCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      locator<AdUserCubit>()..getUser(id: ad.user!),
                ),
                BlocProvider(
                  create: (context) =>
                      locator<RatingCubit>()..getMyReview(id: ad.id!),
                ),
                BlocProvider(
                  create: (context) => locator<CategoryAdsCubit>()
                    ..getCategoryAds(
                      options: PaginationOptions(
                        queryOptions: AdsQueryOptions(
                          query: ad.adTitle,
                        ),
                      ),
                    ),
                ),
              ],
              child: CategoryDetailsScreen(
                ad: ad,
              ),
            );
          },
        );
      //////////userPage_screen////////////////////////
      case AppRoutes.userPage:
        return MaterialPageRoute(
          builder: (_) {
            final user = settings.arguments as UserModel;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<AdUserCubit>(),
                ),
                BlocProvider(
                  create: (context) => locator<CategoryAdsCubit>()
                    ..getCategoryAds(
                      options: PaginationOptions(
                        queryOptions: AdsQueryOptions(
                          user: user.id,
                        ),
                      ),
                    ), // change the cubit to category_details.
                ),
              ],
              child: UserScreen(user: user),
            );
          },
        );
      //////////approvelPage_screen////////////////////////
      case AppRoutes.approvelPage:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<
                      NewAdCubit>(), // change the cubit to approvel-page.
                ),
              ],
              child: const ApprovelScreen(),
            );
          },
        );
      //////////approvelDetails_screen////////////////////////
      // case AppRoutes.approvelDetails:
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       return MultiBlocProvider(
      //         providers: [
      //           BlocProvider(
      //             create: (context) => locator<
      //                 NewAdCubit>(), // change the cubit to ApprovelDetailsScreen.
      //           ),
      //         ],
      //         child: const ApprovelDetailsScreen(),
      //       );
      //     },
      //   );
      //////////users_screen////////////////////////
      case AppRoutes.users:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      locator<NewAdCubit>(), // change the cubit to usersScreen.
                ),
              ],
              child: const UsersScreen(),
            );
          },
        );
      //////////usersDetails_screen////////////////////////
      // case AppRoutes.usersDetails:
      //   return MaterialPageRoute(
      //     builder: (_) {
      //       return MultiBlocProvider(
      //         providers: [
      //           BlocProvider(
      //             create: (context) => locator<
      //                 NewAdCubit>(), // change the cubit to UsersScreenDetails.
      //           ),
      //         ],
      //         child: const UserDetailsScreen(),
      //       );
      //     },
      //   );
      //////////usersDetails_screen////////////////////////
      case AppRoutes.ratting:
        return MaterialPageRoute(
          builder: (_) {
            // final ad = settings.arguments as Ad;
            final args = settings.arguments as Map<String, dynamic>;
            final Ad ad = args['ad'];
            final int count = args['count'] ?? '0';
            // final String rateAverage = args['ratingAvarage'] ?? '0';
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      locator<RatingCubit>()..getMyReview(id: ad.id!),
                ),
                BlocProvider(
                  create: (context) => locator<ReviewsCubit>()
                    ..getReviews(
                      options: PaginationOptions(id: ad.id),
                    ), // change the cubit to ratting.
                ),
              ],
              child: RattingScreen(
                ad: ad,
                count: count,
              ),
            );
          },
        );

      case AppRoutes.googleMap:
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => locator<
                      NewAdCubit>(), // change the cubit to GoogleMapScreen.
                ),
              ],
              child: const GoogleMapScreen(),
            );
          },
        );
      default:
        return null;
    }
  }
}

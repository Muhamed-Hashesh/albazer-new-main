import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/Features/auth/data/repositories/user_repo.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/forget_password/forget_password_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/reset_password/reset_password_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/cubits/verify_password/verify_password_cubit.dart';
import 'package:albazar_app/Features/category/data/repositories/categories_repo.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ad_user/ad_user_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/rating/rating_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/reviews/reviews_cubit.dart';
import 'package:albazar_app/Features/chat/data/repositories/chat_repo.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/chats/chats_cubit.dart';
import 'package:albazar_app/Features/chat/presentation/cubits/messages/messages_cubit.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/cubit/approval_cubit.dart';
import 'package:albazar_app/Features/dashboard/users/presentation/cubit/list_users_cubit.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/Features/my%20ads/presentation/cubit/my_ads_cubit.dart';
import 'package:albazar_app/Features/notificatoins/logic/cubit/notification_cubit.dart';
import 'package:albazar_app/Features/notificatoins/notifications_factory.dart';
import 'package:albazar_app/Features/profile/presentation/cubit/profile_cubit.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  //*Externals
  _initExternals();
  //*Repos
  _initRepos();
  //*Cubits
  _initCubits();
}

void _initExternals() {
  locator.registerLazySingleton<ApiService>(
    () => ApiService(),
  );
  //* Notifications
  locator
      .registerLazySingleton<NotificationFactory>(() => NotificationFactory());
}

void _initRepos() {
  //*Auth
  locator.registerLazySingleton<IAuthRepo>(
    () => AuthRepo(
      service: locator(),
    ),
  );
  //*User
  locator.registerLazySingleton<IUserRepo>(
    () => UserRepo(
      service: locator(),
    ),
  );
  //*Categories
  locator.registerLazySingleton<ICategoriesRepo>(
    () => CategoriesRepo(
      service: locator(),
    ),
  );
  //*Ads
  locator.registerLazySingleton<IAdsRepo>(
    () => AdsRepo(
      service: locator(),
    ),
  );
  //*Chat
  locator.registerLazySingleton<IChatRepo>(
    () => ChatRepo(
      service: locator(),
    ),
  );
}

void _initCubits() {
  //* Notifications
  locator.registerFactory<NotificationCubit>(
    () => NotificationCubit(locator<NotificationFactory>()),
  );
  //*Auth
  locator.registerFactory<LoginCubit>(
    () => LoginCubit(
      repository: locator(),
    ),
  );

  locator.registerFactory<SignupCubit>(
    () => SignupCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<VerifyPasswordCubit>(
    () => VerifyPasswordCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(
      repository: locator(),
    ),
  );
  //*Categories
  locator.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      repository: locator(),
    ),
  );
  //*Ads
  locator.registerFactory<NewAdCubit>(
    () => NewAdCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<CategoryAdsCubit>(
    () => CategoryAdsCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<FavoriteAdCubit>(
    () => FavoriteAdCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<FeaturedAdCubit>(
    () => FeaturedAdCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<MyAdsCubit>(
    () => MyAdsCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<AdUserCubit>(
    () => AdUserCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<RatingCubit>(
    () => RatingCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<ReviewsCubit>(
    () => ReviewsCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<ApprovalCubit>(
    () => ApprovalCubit(
      repository: locator(),
    ),
  );
  //*Chat
  locator.registerFactory<ChatsCubit>(
    () => ChatsCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<MessagesCubit>(
    () => MessagesCubit(
      repository: locator(),
    ),
  );
  //*User
  locator.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      repository: locator(),
    ),
  );
  locator.registerFactory<ListUsersCubit>(
    () => ListUsersCubit(
      repository: locator(),
    ),
  );
}

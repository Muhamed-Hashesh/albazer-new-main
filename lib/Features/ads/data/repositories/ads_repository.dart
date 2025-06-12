import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/paginated_response.dart';
import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';

abstract class IAdsRepo {
  const IAdsRepo();

  Future<String> submitAd({
    required Ad ad,
  });
  Future<PaginatedAdsResponse> getCategoryAds({
    required PaginationOptions options,
  });
  Future<List<Ad>> getFavoriteAds();
  Future<String> addToFavorite({required String id});
  Future<String> removeFromFavorite({required String id});
  Future<List<Ad>> getFollowingAds();
  Future<String> follow({required String id});
  Future<String> unfollow({required String id});
  Future<String> accept({required String id});
  Future<String> reject({required String id});
  Future<List<Ad>> getMyAds({required AdsQueryOptions options});
  Future<String> removeAd({required String id});
  Future<String> rateAd({required RatingOptions options});
  Future<List<Review>> getAllReviews({required PaginationOptions options});
  Future<Review?> getMyReview({required String id});
  Future<Review> updateMyReview({required RatingOptions options});
  Future<String> deleteMyReview({required String id});
}

class AdsRepo implements IAdsRepo {
  final ApiService service;

  const AdsRepo({required this.service});

  @override
  Future<String> submitAd({required Ad ad}) async {
    final response = await service.post(
      endPoint: AppUrls.ads,
      // contentType: "multipart/form-data",
      data: await ad.toFormData(),
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return 'تم طلب الإعلان بنجاح';
  }

  @override
  Future<PaginatedAdsResponse> getCategoryAds(
      {required PaginationOptions options}) async {
    final response = await service.get(
      endPoint: AppUrls.ads,
      queryParameters: options.toJson(),
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return PaginatedAdsResponse.fromJson(response);
  }

  @override
  Future<String> addToFavorite({required String id}) async {
    final response = await service.post(
      endPoint: '${AppUrls.favorites}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    await UserHelper.refresh();

    return 'تم اضافة الإعلان الى المفضلة بنجاح';
  }

  @override
  Future<List<Ad>> getFavoriteAds() async {
    final response = await service.get(
      endPoint: AppUrls.favorites,
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return List.from(response['data']).map((e) => Ad.fromJson(e)).toList();
  }

  @override
  Future<String> removeFromFavorite({required String id}) async {
    final response = await service.delete(
      endPoint: '${AppUrls.favorites}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    await UserHelper.refresh();
    return 'تم حذف الإعلان من المفضلة بنجاح';
  }

  @override
  Future<List<Ad>> getMyAds({required AdsQueryOptions options}) async {
    final response = await service.get(
      endPoint: AppUrls.myAds,
      queryParameters: options.toJson(),
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    // if (response.containsKey("message")) {
    //   throw AuthException(response['message']);
    // }
    await UserHelper.refresh();
    return List.from(response['data']).map((e) => Ad.fromJson(e)).toList();
  }

  @override
  Future<String> removeAd({required String id}) async {
    final response = await service.delete(
      endPoint: '${AppUrls.ads}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    // if (response.containsKey("status")) {
    //   if (response['status'] == "failed") {
    //     throw AuthException(response['message']);
    //   }
    // }
    // await UserHelper.refresh();
    return 'تم حذف الإعلان بنجاح';
  }

  @override
  Future<String> rateAd({required RatingOptions options}) async {
    final response = await service.post(
      endPoint: "${AppUrls.reviews}/${options.id}",
      data: options.toJson(),
    );

    if (response.containsKey("message") ||
        response.containsKey("error") ||
        response.containsKey("errors")) {
      if (response.containsKey("errors")) {
        throw AuthException(response['errors'][0]["msg"]);
      }
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      if (response.containsKey("message")) {
        throw AuthException(response['message']);
      }
      throw const AuthException('حدث خطأ ما');
    }
    return 'تم التقييم بنجاح';
  }

  @override
  Future<String> follow({required String id}) async {
    final response = await service.put(
      endPoint: '${AppUrls.follow}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    await UserHelper.refresh();

    return 'تم المتابعة';
  }

  @override
  Future<List<Ad>> getFollowingAds() async {
    final response = await service.get(
      endPoint: AppUrls.followingListing,
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return List.from(response['data']).map((e) => Ad.fromJson(e)).toList();
  }

  @override
  Future<String> unfollow({required String id}) async {
    final response = await service.put(
      endPoint: '${AppUrls.unfollow}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    await UserHelper.refresh();
    return 'تم الغاء المتابعة';
  }

  @override
  Future<List<Review>> getAllReviews(
      {required PaginationOptions options}) async {
    final response = await service.get(
      endPoint: "${AppUrls.reviews}/${options.id}",
      queryParameters: options.toJson(),
    );
    log("OPTIONS: ${options.toJson()}");
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return List.from(response['data']).map((e) => Review.fromJson(e)).toList();
  }

  @override
  Future<Review?> getMyReview({required String id}) async {
    final response = await service.get(
      endPoint: "${AppUrls.reviews}/$id",
      queryParameters: {
        "user": UserHelper.user!.id,
      },
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    final reviews =
        List.from(response['data']).map((e) => Review.fromJson(e)).toList();
    if (reviews.isEmpty) return null;
    return reviews.first;
  }

  @override
  Future<Review> updateMyReview({required RatingOptions options}) async {
    final response = await service.put(
      endPoint: "${AppUrls.review}/${options.id}",
      data: options.toJson(),
    );

    if (response.containsKey("message") ||
        response.containsKey("error") ||
        response.containsKey("errors")) {
      if (response.containsKey("errors")) {
        throw AuthException(response['errors'][0]["msg"]);
      }
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      if (response.containsKey("message")) {
        throw AuthException(response['message']);
      }
      throw const AuthException('حدث خطأ ما');
    }
    return Review.fromJson(response["data"]);
  }

  @override
  Future<String> deleteMyReview({required String id}) async {
    final response = await service.delete(
      endPoint: '${AppUrls.review}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    return 'تم حذف التقييم بنجاح';
  }

  @override
  Future<String> accept({required String id}) async {
    final response = await service.put(
      endPoint: '${AppUrls.acceptAd}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    return 'تم قبول الإعلان';
  }

  @override
  Future<String> reject({required String id}) async {
    final response = await service.put(
      endPoint: '${AppUrls.rejectAd}/$id',
    );
    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("status")) {
      if (response['status'] == "failed") {
        throw AuthException(response['message']);
      }
    }
    return 'تم رفض الإعلان';
  }
}

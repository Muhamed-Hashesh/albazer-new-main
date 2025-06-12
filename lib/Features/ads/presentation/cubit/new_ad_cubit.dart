import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/errors/exceptions.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_ad_state.dart';

class NewAdCubit extends Cubit<NewAdState> {
  final IAdsRepo repository;
  NewAdCubit({required this.repository}) : super(const NewAdInitial());

  Future<void> submitAd({required Ad ad}) async {
    try {
      emit(const NewAdLoading());
      final message = await repository.submitAd(ad: ad);
      emit(NewAdSubmitted(message: message));
    } on AppException catch (e) {
      log(e.runtimeType.toString());
      emit(NewAdError(error: e.message));
    } catch (e) {
      emit(NewAdError(error: e.toString()));
    }
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/helpers/constants.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';
import 'package:pp_22/services/subscription_service.dart';

class PayWallController {
  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>();

  bool get userHasPremium => _subscriptionRepository.value.userHasPremium;

  Future<void> makePurchase(
    ProductId productId, {
    void Function(String)? onError,
    VoidCallback? onDone,
  }) async {
    try {
      await _subscriptionRepository.makePurchase(productId: productId);
      onDone?.call();
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  Future<void> restorePurchase({
    void Function(String)? onError,
    VoidCallback? onDone,
  }) async {
    try {
      await _subscriptionRepository.restorePurchases();
      onDone?.call();
    } catch (e) {
      log('Error: ${e.toString()}');
      onError?.call(e.toString());
    }
  }

  String getProductPrice(ProductId productId) {
    try {
      return _subscriptionRepository.getProductPrice(productId);
    } catch (e) {
      return Constants.testProductPrice;
    }
  }
}

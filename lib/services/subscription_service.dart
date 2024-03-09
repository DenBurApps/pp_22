// ignore_for_file: constant_identifier_names
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/services/remote_config_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  final _remoteConfigService = GetIt.instance<RemoteConfigService>();
  final _products = <StoreProduct>[];

  late CustomerInfo _customerInfo;

  List<StoreProduct> get products => _products;

  CustomerInfo get customerInfo => _customerInfo;

  Future<SubscriptionService> init() async {
    await _initialize();
    return this;
  }

  Future<void> _initialize() async {
    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }
    await Purchases.configure(
      PurchasesConfiguration(
        _remoteConfigService.getString(
          ConfigKey.subscriptionApiKey,
        ),
      ),
    );
    await _getCustomerInfo();
    await _getAllProducts();
  }

  Future<void> _getAllProducts({VoidCallback? onError}) async {
    try {
      final ids = ProductId.values.map((e) => e.name).toList();
      final products = await Purchases.getProducts(ids);
      _products.addAll(products);
    } catch (e) {
      onError?.call();
      log(e.toString());
    }
  }

  Future<void> _getCustomerInfo() async =>
      _customerInfo = await Purchases.getCustomerInfo();

  Future<void> makePurchase(ProductId productId) async {
    try {
      final targetProduct = _products
          .firstWhere((element) => element.identifier == productId.name);
      _customerInfo = await Purchases.purchaseStoreProduct(targetProduct);
    } catch (e) {
      rethrow;
    }
  }

  void addCustomerInfoUpdateListener(
          void Function(CustomerInfo) customerInfoUpdateListener) =>
      Purchases.addCustomerInfoUpdateListener(customerInfoUpdateListener);

  Future<void> restorePurchases() async =>
      _customerInfo = await Purchases.restorePurchases();
}

enum ProductId {
  premium_1w,
}

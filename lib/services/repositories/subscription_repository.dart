import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/services/database/database_keys.dart';
import 'package:pp_22/services/database/database_service.dart';
import 'package:pp_22/services/subscription_service.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';

class SubscriptionRepositoy extends ValueNotifier<SubscriptionState> {
  SubscriptionRepositoy() : super(SubscriptionState.initial()) {
    _init();
  }

  final _subscriptionService = GetIt.instance<SubscriptionService>();
  final _databaseService = GetIt.instance<DatabaseService>();

  bool get canUserSendPhotoRequest =>
      value.userHasPremium || value.searchByPhotoCount > 0;

  bool get canYserSendQueryRequest =>
      value.userHasPremium || value.searchByQueryCount > 0;

  bool get canUserUseCollections => value.userHasPremium;

  void _init() {
    value = value.copyWith(customerInfo: _subscriptionService.customerInfo);
    _subscriptionService.addCustomerInfoUpdateListener((customerInfo) {
      _checkIfUserHasSubscription(customerInfo);
    });
    _getSearchByPhotoCount();
    _getSearchByQueryCount();
    _checkIfUserHasSubscription(value.customerInfo!);
  }

  String getProductPrice(ProductId productId) {
    try {
      return _subscriptionService.products
          .firstWhere(
            (element) =>
                element.identifier == productId.name ||
                element.identifier.startsWith(productId.name),
          )
          .priceString;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> makePurchase({
    required ProductId productId,
  }) async {
    try {
      await _subscriptionService.makePurchase(productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _subscriptionService.restorePurchases();
    } catch (e) {
      rethrow;
    }
  }

  void _checkIfUserHasSubscription(CustomerInfo customerInfo) {
    if (customerInfo.activeSubscriptions.isNotEmpty && !value.userHasPremium) {
      _onSubscriptionActivated();
    } else if (customerInfo.activeSubscriptions.isEmpty &&
        value.userHasPremium) {
      value.copyWith(userHasPremium: false);
    }
    value = value.copyWith(customerInfo: customerInfo);
  }

  void _onSubscriptionActivated() {
    value = value.copyWith(userHasPremium: true);
  }

  void _getSearchByQueryCount() {
    final searchByQueryCount =
        _databaseService.get(DatabaseKeys.searchByQueryCount);

    value = value.copyWith(searchByQueryCount: searchByQueryCount);
  }

  void _getSearchByPhotoCount() {
    final searchByPhotoCount =
        _databaseService.get(DatabaseKeys.searchByPhotoCount);

    value = value.copyWith(searchByPhotoCount: searchByPhotoCount);
  }

  void decreaseSearchByQueryCount() {
    final updatedSeqrchByQueryCount = value.searchByQueryCount - 1;
    _databaseService.put(
        DatabaseKeys.searchByQueryCount, updatedSeqrchByQueryCount);
    value = value.copyWith(searchByQueryCount: updatedSeqrchByQueryCount);
  }

  void decreaseSearchByPhotoCount() {
    final updatedSeqrchByPhotoCount = value.searchByPhotoCount - 1;
    _databaseService.put(
        DatabaseKeys.searchByPhotoCount, updatedSeqrchByPhotoCount);
    value = value.copyWith(searchByPhotoCount: updatedSeqrchByPhotoCount);
  }
}

class SubscriptionState {
  final bool userHasPremium;
  final int searchByQueryCount;
  final int searchByPhotoCount;
  final CustomerInfo? customerInfo;
  const SubscriptionState({
    required this.userHasPremium,
    required this.searchByPhotoCount,
    required this.searchByQueryCount,
    this.customerInfo,
  });

  factory SubscriptionState.initial() => const SubscriptionState(
        userHasPremium: false,
        searchByPhotoCount: 4,
        searchByQueryCount: 4,
      );

  SubscriptionState copyWith({
    bool? userHasPremium,
    int? searchByQueryCount,
    int? searchByPhotoCount,
    CustomerInfo? customerInfo,
  }) =>
      SubscriptionState(
        userHasPremium: userHasPremium ?? this.userHasPremium,
        searchByQueryCount: searchByQueryCount ?? this.searchByQueryCount,
        searchByPhotoCount: searchByPhotoCount ?? this.searchByPhotoCount,
        customerInfo: customerInfo ?? this.customerInfo,
      );
}

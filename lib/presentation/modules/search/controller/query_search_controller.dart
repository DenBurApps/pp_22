import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/helpers/enums.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/services/coin_api_service.dart';
import 'package:pp_22/services/database/database_keys.dart';
import 'package:pp_22/services/database/database_service.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';

class QuerySearchController extends ValueNotifier<QuerySearchState> {
  QuerySearchController() : super(QuerySearchState.initial());

  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>();
  final _databaseService = GetIt.instance<DatabaseService>();
  final _coinsApiService = GetIt.instance<CoinApiService>();

  bool get canUserSendQueryRequest =>
      _subscriptionRepository.canYserSendQueryRequest;

  Future<void> search(String searchQuery) async {
    try {
      value = value.copyWith(isLoading: true, isResponseReceived: false);
      final searchedCoins =
          await _coinsApiService.getCoinsBySeacrhQuery(searchQuery);
      value = value.copyWith(
        searchedCoins: searchedCoins,
        isLoading: false,
        isResponseReceived: true,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> searchOnScroll(String searchQuery) async {
    try {
      value = value.copyWith(
        isLoading: true,
      );
      final updatedLoadPage = value.loadedPage + 1;
      final searchedCoins = await _coinsApiService.getCoinsBySeacrhQuery(
        searchQuery,
        page: updatedLoadPage,
      );

      final updatedSearchedCoins = value.searchedCoins..addAll(searchedCoins);

      value = value.copyWith(
        searchedCoins: updatedSearchedCoins,
        isLoading: false,
        loadedPage: updatedLoadPage,
        isResponseReceived: true,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clear() => value = value.copyWith(
        searchedCoins: [],
        isResponseReceived: false,
      );
  void switchSortType(SortType sortType) =>
      value = value.copyWith(sortType: sortType);

       void decreaseSearchByQueryCoun() =>
      _subscriptionRepository.decreaseSearchByQueryCount();

  void tooltipAction({VoidCallback? showSearchTooltip}) {
    final seenSearchTooltip =
        _databaseService.get(DatabaseKeys.seenSearchTooltip) ?? false;
    if (!seenSearchTooltip && !_subscriptionRepository.value.userHasPremium) {
      _databaseService.put(DatabaseKeys.seenSearchTooltip, true);
      showSearchTooltip?.call();
    }
  }
}

class QuerySearchState {
  final List<ShortenedCoinData> searchedCoins;
  final bool isLoading;
  final bool isResponseReceived;
  final int loadedPage;
  final SortType sortType;
  final String? errorMessage;

  QuerySearchState({
    required this.searchedCoins,
    required this.sortType,
    required this.isLoading,
    required this.isResponseReceived,
    this.errorMessage,
    required this.loadedPage,
  });

  factory QuerySearchState.initial() => QuerySearchState(
        searchedCoins: [],
        sortType: SortType.none,
        isLoading: false,
        isResponseReceived: false,
        loadedPage: 0,
      );

  QuerySearchState copyWith({
    List<ShortenedCoinData>? searchedCoins,
    bool? isLoading,
    bool? isResponseReceived,
    String? errorMessage,
    int? loadedPage,
    SortType? sortType,
  }) =>
      QuerySearchState(
        sortType: sortType ?? this.sortType,
        searchedCoins: searchedCoins ?? this.searchedCoins,
        isLoading: isLoading ?? this.isLoading,
        isResponseReceived: isResponseReceived ?? this.isResponseReceived,
        errorMessage: errorMessage ?? this.errorMessage,
        loadedPage: loadedPage ?? this.loadedPage,
      );
}

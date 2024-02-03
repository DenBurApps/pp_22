import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22_copy/models/coin.dart';
import 'package:pp_22_copy/services/coin_api_service.dart';

class QuerySearchController extends ValueNotifier<QuerySearchState> {
  QuerySearchController() : super(QuerySearchState.initial());

  final _coinsApiService = GetIt.instance<CoinApiService>();

  Future<void> search(String searchQuery) async {
    try {
      value = value.copyWith(isLoading: true);
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
      value = value.copyWith(isLoading: true);
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
}

class QuerySearchState {
  final List<ShortenedCoinData> searchedCoins;
  final bool isLoading;
  final bool isResponseReceived;
  final int loadedPage;
  final String? errorMessage;

  QuerySearchState({
    required this.searchedCoins,
    required this.isLoading,
    required this.isResponseReceived,
    this.errorMessage,
    required this.loadedPage,
  });

  factory QuerySearchState.initial() => QuerySearchState(
        searchedCoins: [],
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
  }) =>
      QuerySearchState(
        searchedCoins: searchedCoins ?? this.searchedCoins,
        isLoading: isLoading ?? this.isLoading,
        isResponseReceived: isResponseReceived ?? this.isResponseReceived,
        errorMessage: errorMessage ?? this.errorMessage,
        loadedPage: loadedPage ?? this.loadedPage,
      );
}

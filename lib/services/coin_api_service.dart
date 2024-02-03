import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pp_22_copy/models/coin.dart';
import 'package:pp_22_copy/models/price.dart';
import 'package:pp_22_copy/services/remote_config_service.dart';

class CoinApiService {
  final _remoteConfigService = GetIt.instance<RemoteConfigService>();
  static const _url = 'https://api.numista.com/api/v3';

  static const _header = 'Numista-API-Key';
  late final _apikey;
  static const imageMimeType = 'image/jpeg';

  CoinApiService init() {
    _apikey = _remoteConfigService.getString(ConfigKey.coinApiKey);
    return this;
  }

  Future<List<ShortenedCoinData>> getCoinsBySeacrhQuery(
    String searchQuery, {
    int page = 1,
  }) async {
    try {
      List<ShortenedCoinData> coins = [];
      final response = await http.get(
        Uri.parse('$_url/types?q=$searchQuery&category=coin&page=$page'),
        headers: {_header: _apikey},
      );

      if (response.statusCode == 200) {
        final json = (jsonDecode(response.body) as Map<String, dynamic>);
        final coinsData = json['types'] as List<dynamic>;
        for (var coinData in coinsData) {
          coins.add(ShortenedCoinData.fromJson(coinData));
        }
      }
      return coins;
    } catch (e) {
      log('ApiService || ${e.toString()}');
      rethrow;
    }
  }

  Future<List<ShortenedCoinData>> getCoinsByImages(
    Uint8List obverse,
    Uint8List reverse,
  ) async {
    try {
      List<ShortenedCoinData> coins = [];
      final encodedObverse = base64Encode(obverse);
      final encodedReverse = base64Encode(reverse);
      final requestBody = {
        "category": "coin",
        'max_results': 10,
        'images': [
          {"mime_type": imageMimeType, 'image_data': encodedObverse},
          {"mime_type": imageMimeType, 'image_data': encodedReverse},
        ],
      };
      final response = await http.post(
        Uri.parse('$_url/search_by_image'),
        headers: {_header: _apikey},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final coinsData = (jsonDecode(response.body)
            as Map<String, dynamic>)['types'] as List<dynamic>;
        for (var coin in coinsData) {
          coins.add(ShortenedCoinData.fromJson(coin));
        }
      } else {
        log(response.statusCode.toString());
      }
      return coins;
    } catch (e) {
      log('CoinsApiService || ${e.toString()}');
      rethrow;
    }
  }

  Future<ExpandedCoinData> getCoinById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_url/types/$id?category=coin'),
        headers: {_header: _apikey},
      );
      final json = jsonDecode(response.body);
      return ExpandedCoinData.fromJson(json);
    } catch (e) {
      log('ApiService || ${e.toString()}');
      rethrow;
    }
  }

  Future<Price?> getCoinPrice(int id) async {
    try {
      final issuesReponse = await http.get(
        Uri.parse('$_url/types/$id/issues'),
        headers: {_header: _apikey},
      );
      final firstIssueJson = (jsonDecode(issuesReponse.body) as List<dynamic>)
          .first as Map<String, dynamic>;
      final issueId = firstIssueJson['id'] as int;
      final priceResponse = await http.get(
        Uri.parse('$_url/types/$id/issues/$issueId/prices'),
        headers: {_header: _apikey},
      );
      final priceListJson = (jsonDecode(priceResponse.body)
          as Map<String, dynamic>)['prices'] as List<dynamic>;
      return Price.fromJson(priceListJson);
    } catch (e) {
      log('ApiService || ${e.toString()}');
      rethrow;
    }
  }
}

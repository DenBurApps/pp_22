import 'package:get_it/get_it.dart';
import 'package:pp_22_copy/services/coin_api_service.dart';
import 'package:pp_22_copy/services/database/database_service.dart';
import 'package:pp_22_copy/services/remote_config_service.dart';
import 'package:pp_22_copy/services/repositories/collection_repository.dart';

class ServiceLocator {
  static Future<void> loadServices() async {
    GetIt.I.registerSingletonAsync<DatabaseService>(
        () => DatabaseService().init());
    await GetIt.I.isReady<DatabaseService>();
    GetIt.I.registerSingletonAsync<RemoteConfigService>(
        () => RemoteConfigService().init());
    await GetIt.I.isReady<RemoteConfigService>();
    GetIt.I.registerSingleton<CoinApiService>(CoinApiService().init());
  }

  static Future<void> loadRepositories() async {
    GetIt.I.registerSingleton<CollectionsRepository>(CollectionsRepository());
  }
}

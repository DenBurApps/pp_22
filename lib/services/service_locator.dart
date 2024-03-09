import 'package:get_it/get_it.dart';
import 'package:pp_22/services/coin_api_service.dart';
import 'package:pp_22/services/database/database_service.dart';
import 'package:pp_22/services/remote_config_service.dart';
import 'package:pp_22/services/repositories/collection_repository.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';
import 'package:pp_22/services/subscription_service.dart';

class ServiceLocator {
  static Future<void> loadServices() async {
    GetIt.I.registerSingletonAsync<DatabaseService>(
        () => DatabaseService().init());
    await GetIt.I.isReady<DatabaseService>();
    GetIt.I.registerSingletonAsync<RemoteConfigService>(
        () => RemoteConfigService().init());
    GetIt.I.registerSingletonAsync(() => SubscriptionService().init());
    await GetIt.I.isReady<SubscriptionService>();
    await GetIt.I.isReady<RemoteConfigService>();
    GetIt.I.registerSingleton<CoinApiService>(CoinApiService().init());
  }

  static Future<void> loadRepositories() async {
    GetIt.I.registerSingleton<CollectionsRepository>(CollectionsRepository());
    GetIt.I.registerSingleton(SubscriptionRepositoy());
  }
}

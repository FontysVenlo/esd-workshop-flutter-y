import 'package:watch_it/watch_it.dart' show sl;

import '../data/repositories/climate_repository.dart';
import '../data/services/api/api_client.dart';

void setupLocator() {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<ClimateRepository>(() => ClimateRepositoryImpl());
}

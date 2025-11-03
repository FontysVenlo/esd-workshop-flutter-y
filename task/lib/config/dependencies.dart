import 'package:watch_it/watch_it.dart' show sl;
import '../data/repositories/climate_repository.dart';
import '../data/services/api/api_client.dart';
import '../ui/climate/view_model/climate_view_model.dart';

void setupLocator() {
  // Services
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<ClimateRepository>(
    () => ClimateRepositoryImpl(apiClient: sl<ApiClient>()),
  );

  // ViewModels
  sl.registerLazySingleton<ClimateViewModel>(
    () => ClimateViewModel(climateRepository: sl<ClimateRepository>()),
  );
}

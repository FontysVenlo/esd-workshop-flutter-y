import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../../data/repositories/climate_repository.dart';
import '../../../domain/models/location.dart';

class ClimateViewModel extends SafeChangeNotifier {
  ClimateViewModel({required ClimateRepository climateRepository}) : _climateRepository = climateRepository;

  final ClimateRepository _climateRepository;

  final bool _isLoading = false;
  String? _errorMessage;
  final List<Location> _locations = [];
}

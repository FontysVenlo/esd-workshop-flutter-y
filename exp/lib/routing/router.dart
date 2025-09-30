import 'package:go_router/go_router.dart';

import '../ui/climate/widgets/climate_screen.dart';
import 'routes.dart';

final router = GoRouter(
  initialLocation: Routes.climate,
  routes: [GoRoute(path: Routes.climate, builder: (context, state) => const ClimateScreen())],
);

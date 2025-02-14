class AppRoute {
  static const String dashboard = '/';
  static const String zones = '/zones';
  static const String zoneDetail = '/zones/:id';
  static const String schedules = '/schedules';
  static const String scheduleDetail = '/schedules/:id';
  static const String settings = '/settings';

  static String zoneDetailPath(String id) => '/zones/$id';
  static String scheduleDetailPath(String id) => '/schedules/$id';
}

class RouteLocation {
  final String path;
  final Map<String, String> params;

  const RouteLocation(this.path, [this.params = const {}]);

  @override
  String toString() => path;

  static RouteLocation parse(String location) {
    final uri = Uri.parse(location);
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) {
      return RouteLocation(AppRoute.dashboard);
    }

    switch (pathSegments[0]) {
      case 'zones':
        if (pathSegments.length > 1) {
          return RouteLocation(AppRoute.zoneDetail, {'id': pathSegments[1]});
        }
        return RouteLocation(AppRoute.zones);
      case 'schedules':
        if (pathSegments.length > 1) {
          return RouteLocation(AppRoute.scheduleDetail, {'id': pathSegments[1]});
        }
        return RouteLocation(AppRoute.schedules);
      case 'settings':
        return RouteLocation(AppRoute.settings);
      default:
        return RouteLocation(AppRoute.dashboard);
    }
  }
} 
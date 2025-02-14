import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouteInformationParser extends RouteInformationParser<RouteLocation> {
  @override
  Future<RouteLocation> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.location;
    if (location == null) {
      return RouteLocation(AppRoute.dashboard);
    }
    return RouteLocation.parse(location);
  }

  @override
  RouteInformation? restoreRouteInformation(RouteLocation configuration) {
    return RouteInformation(location: configuration.toString());
  }
} 
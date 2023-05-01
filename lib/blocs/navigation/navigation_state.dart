part of 'navigation_bloc.dart';

@immutable
class NavigationState {
  final String route;
  final String? routType;
  final String? message;
  final String? messageType;
  const NavigationState(
      {this.route = "", this.routType, this.message, this.messageType});
  NavigationState copyWith(
          {String? route,
          String? routType,
          String? message,
          String? messageType}) =>
      NavigationState(
        route: route ?? this.route,
        routType: routType ?? this.routType,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
      );
}

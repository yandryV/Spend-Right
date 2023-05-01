part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent{}

class NavigateToPage extends NavigationEvent {
  final String route;
  final String routType;
  NavigateToPage(this.route, this.routType);
}

class ShowSnackBar extends NavigationEvent {
  final String message;
  final String messageType;
  ShowSnackBar(this.message, this.messageType);
}



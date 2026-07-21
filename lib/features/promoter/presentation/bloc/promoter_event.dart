abstract class PromoterEvent {}

class ChangeDrawerPage extends PromoterEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends PromoterEvent {}

abstract class SecretaryEvent {}

class ChangeDrawerPage extends SecretaryEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends SecretaryEvent {}

abstract class AssistantEvent {}

class ChangeDrawerPage extends AssistantEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends AssistantEvent {}

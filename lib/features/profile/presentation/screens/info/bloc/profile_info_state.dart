import 'package:equatable/equatable.dart';
import 'package:coleapp/features/auth/data/models/user.dart';

class ProfileInfoState extends Equatable {
  final User? user;

  const ProfileInfoState({this.user});

  ProfileInfoState copyWith({User? user}) {
    return ProfileInfoState(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}

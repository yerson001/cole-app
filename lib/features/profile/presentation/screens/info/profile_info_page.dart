import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_bloc.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_state.dart';
import 'package:coleapp/features/profile/presentation/screens/info/profile_info_content.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
      builder: (context, state) {
        return ProfileInfoContent(state.user);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/data/models/role.dart';
import 'package:coleapp/features/roles/presentation/widgets/roles_item.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_state.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF003366),
                  Color(0xFF4CAF50),
                ],
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              children: state.roles != null
                  ? (state.roles?.map((Role role) {
                        return RolesItem(role);
                      }).toList())
                      as List<Widget>
                  : [],
            ),
          );
        },
      ),
    );
  }
}

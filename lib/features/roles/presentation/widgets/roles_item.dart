import 'package:flutter/material.dart';
import 'package:coleapp/features/auth/data/models/role.dart';

class RolesItem extends StatelessWidget {
  final Role role;

  const RolesItem(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, role.route, (route) => false);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 15),
            height: 150,
            child: role.image.isNotEmpty
                ? FadeInImage(
                    image: NetworkImage(role.image),
                    fit: BoxFit.contain,
                    fadeInDuration: const Duration(seconds: 1),
                    placeholder: const AssetImage('assets/images/cole.png'),
                  )
                : Image.asset(
                    'assets/images/cole.png',
                    fit: BoxFit.contain,
                  ),
          ),
          Text(
            role.displayName,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

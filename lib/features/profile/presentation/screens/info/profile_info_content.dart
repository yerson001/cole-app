import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/auth/data/models/user.dart';

class ProfileInfoContent extends StatelessWidget {
  final User? user;

  const ProfileInfoContent(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final p = user?.person;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _userCard(context, ac, p),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Información Personal'),
          const SizedBox(height: 8),
          _dataCard(context, ac, [
            _dataRow(Icons.badge_outlined, 'Nombre', '${p?.name ?? ''} ${p?.lastName ?? ''}'),
            _dataRow(Icons.person_outline, 'Usuario', user?.username ?? ''),
            _dataRow(Icons.credit_card_outlined, 'Documento', p?.documentNumber ?? ''),
            _dataRow(Icons.email_outlined, 'Email', p?.email ?? ''),
            _dataRow(Icons.phone_outlined, 'Teléfono', p?.cellPhone ?? ''),
          ]),
        ],
      ),
    );
  }

  Widget _userCard(BuildContext context, AppColors ac, dynamic p) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [ac.primary, ac.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 48, color: ac.primary),
            ),
            const SizedBox(height: 14),
            Text(
              '${p?.name ?? ''} ${p?.lastName ?? ''}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '@${user?.username ?? ''}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: cs.onSurface,
        ),
      ),
    );
  }

  Widget _dataCard(BuildContext context, AppColors ac, List<Widget> rows) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: rows),
      ),
    );
  }

  Widget _dataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

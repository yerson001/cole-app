import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/themes/theme_page.dart';
import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeEvent.dart';

class ProfileInfoContent extends StatelessWidget {
  final User? user;
  final List<StudentModel> students;
  final BranchModel? branch;

  const ProfileInfoContent(
    this.user, {
    super.key,
    this.students = const [],
    this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final p = user?.person;
    final fullName = p != null
        ? '${p.name} ${p.lastName}'.trim()
        : (user?.username ?? '');
    final initials = _initialsOf(user);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileHeader(
            ac: ac,
            name: fullName,
            initials: initials,
            dni: p?.documentNumber ?? '',
            username: user?.username ?? '',
          ),
          const SizedBox(height: 16),
          _SectionTitle(ac: ac, text: 'INFORMACIÓN PERSONAL'),
          _PersonalInfoCard(ac: ac, email: p?.email, phone: p?.cellPhone),
          const SizedBox(height: 20),
          _SectionTitle(ac: ac, text: 'HIJOS', padded: true),
          const SizedBox(height: 8),
          _ChildrenCarousel(ac: ac, children: students),
          const SizedBox(height: 20),
          _SectionTitle(ac: ac, text: 'PREFERENCIAS Y SEGURIDAD'),
          _SettingsCard(ac: ac),
          const SizedBox(height: 14),
          _LogoutCard(ac: ac),
          _FooterSchoolName(ac: ac, name: branch?.name ?? ''),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static String _initialsOf(User? user) {
    final p = user?.person;
    final parts = <String>[if (p != null) p.name, if (p != null) p.lastName];
    if (parts.isEmpty) return '?';
    return parts
        .where((s) => s.isNotEmpty)
        .map((s) => s[0].toUpperCase())
        .take(2)
        .join();
  }
}

// ------------------------------------------------------------
// HEADER: avatar con iniciales + nombre + DNI + píldora QR
// ------------------------------------------------------------
class _ProfileHeader extends StatelessWidget {
  final AppColors ac;
  final String name;
  final String initials;
  final String dni;
  final String username;

  const _ProfileHeader({
    required this.ac,
    required this.name,
    required this.initials,
    required this.dni,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ac.surface,
              border: Border.all(color: ac.primary, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ac.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Usuario' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (dni.isNotEmpty)
                  Text(
                    'DNI $dni',
                    style: TextStyle(fontSize: 12, color: ac.textDisabled),
                  ),
                if (username.isNotEmpty)
                  Text(
                    '@$username',
                    style: TextStyle(fontSize: 11.5, color: ac.textDisabled),
                  ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ac.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code, size: 13, color: ac.primary),
                      const SizedBox(width: 5),
                      Text(
                        'Mi credencial',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: ac.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// TITULO DE SECCION reutilizable
// ------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  final AppColors ac;
  final String text;
  final bool padded;

  const _SectionTitle({
    required this.ac,
    required this.text,
    this.padded = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(
      text,
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        color: ac.textDisabled,
        letterSpacing: 0.8,
      ),
    );
    if (padded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: title,
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: title,
    );
  }
}

// ------------------------------------------------------------
// TARJETA "INFORMACIÓN PERSONAL" (email + teléfono)
// ------------------------------------------------------------
class _PersonalInfoCard extends StatelessWidget {
  final AppColors ac;
  final String? email;
  final String? phone;

  const _PersonalInfoCard({
    required this.ac,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final emailText = (email ?? '').trim();
    final phoneText = (phone ?? '').trim();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ac.border, width: 1),
      ),
      child: Column(
        children: [
          _InfoRow(
            ac: ac,
            icon: Icons.mail_outline,
            text: emailText.isNotEmpty ? emailText : '—',
            muted: emailText.isEmpty,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: ac.border,
            indent: 14,
            endIndent: 14,
          ),
          _InfoRow(
            ac: ac,
            icon: Icons.phone_outlined,
            text: phoneText.isNotEmpty ? phoneText : '—',
            muted: phoneText.isEmpty,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final AppColors ac;
  final IconData icon;
  final String text;
  final bool muted;

  const _InfoRow({
    required this.ac,
    required this.icon,
    required this.text,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: muted ? ac.textDisabled : ac.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                color: muted ? ac.textDisabled : ac.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// CARRUSEL HORIZONTAL DE HIJOS (alto fijo)
// ------------------------------------------------------------
class _ChildrenCarousel extends StatelessWidget {
  final AppColors ac;
  final List<StudentModel> children;

  const _ChildrenCarousel({required this.ac, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ac.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ac.border, width: 1),
        ),
        child: Center(
          child: Text(
            'No hay hijos registrados',
            style: TextStyle(fontSize: 13, color: ac.textDisabled),
          ),
        ),
      );
    }
    return SizedBox(
      height: 126,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          if (i == children.length) {
            return SizedBox(
              width: 44,
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: ac.textDisabled,
                ),
              ),
            );
          }
          final s = children[i];
          return Container(
            width: 132,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ac.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ac.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ac.surface,
                    border: Border.all(color: ac.primary, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initialsOfStudent(s),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ac.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: ac.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${s.level.name} · ${s.grade.name} · ${s.section.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, color: ac.textDisabled),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _initialsOfStudent(StudentModel s) {
    final parts = [s.name, s.lastName].where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

// ------------------------------------------------------------
// TARJETA "PREFERENCIAS Y SEGURIDAD" (Tema, Contraseña, Roles)
// ------------------------------------------------------------
class _SettingsCard extends StatelessWidget {
  final AppColors ac;

  const _SettingsCard({required this.ac});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ac.border, width: 1),
      ),
      child: Column(
        children: [
          _SettingsRow(
            ac: ac,
            icon: Icons.wb_sunny_outlined,
            label: 'Tema',
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(MaterialPageRoute(builder: (_) => const ThemePage()));
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: ac.border,
            indent: 14,
            endIndent: 14,
          ),
          _SettingsRow(
            ac: ac,
            icon: Icons.lock_outline,
            label: 'Cambiar contraseña',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: ac.border,
            indent: 14,
            endIndent: 14,
          ),
          _SettingsRow(
            ac: ac,
            icon: Icons.shield_outlined,
            label: 'Roles',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed('roles');
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final AppColors ac;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.ac,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Icon(icon, size: 16, color: ac.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 13.5)),
            ),
            Icon(Icons.chevron_right, size: 15, color: ac.textDisabled),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// TARJETA "CERRAR SESIÓN" (rojo)
// ------------------------------------------------------------
class _LogoutCard extends StatelessWidget {
  final AppColors ac;

  const _LogoutCard({required this.ac});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ac.border, width: 1),
      ),
      child: InkWell(
        onTap: () {
          final parentBloc = context.read<ParentHomeBloc>();
          final loginBloc = context.read<LoginBloc>();
          try {
            parentBloc.add(Logout());
            loginBloc.add(ResetLogin());
          } catch (_) {}
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Icon(Icons.logout, size: 16, color: ac.error),
              const SizedBox(width: 10),
              Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: ac.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PIE DE PÁGINA (nombre del colegio)
// ------------------------------------------------------------
class _FooterSchoolName extends StatelessWidget {
  final AppColors ac;
  final String name;

  const _FooterSchoolName({required this.ac, required this.name});

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 10.5, color: ac.textDisabled),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_event.dart';
import 'package:coleapp/features/parent/presentation/bloc/parent_state.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentBloc, ParentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          drawer: _buildDrawer(context),
          body: _buildPage(context, state.pageIndex),
          bottomNavigationBar: _buildBottomNav(context, state.pageIndex),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              context.read<ParentBloc>().add(Logout());
              context.read<LoginBloc>().add(ResetLogin());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
    
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_outlined),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final c = context.appColors;
    final currentIdx = context.read<ParentBloc>().state.pageIndex;
    final themeCubit = context.read<ThemeCubit>();
    return Drawer(
      width: 256,
      child: Column(
        children: [
          Container(
            width: 256,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.3))),
            ),
            child: Image.asset('assets/images/check.png', height: 30, fit: BoxFit.contain),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _groupHeader(context, 'PRINCIPAL'),
                _navItem(context, Icons.home_outlined, 'Inicio', 0, currentIdx),
                const SizedBox(height: 16),
                _groupHeader(context, 'ASISTENCIA'),
                _navItem(context, Icons.today_outlined, 'Asistencia diaria', null, currentIdx),
                _navItem(context, Icons.calendar_today_outlined, 'Asistencia general', null, currentIdx),
                _navItem(context, Icons.verified_user_outlined, 'Revisar fotocheck', null, currentIdx),
                const SizedBox(height: 16),
                _groupHeader(context, 'ACADÉMICO'),
                _navItem(context, Icons.calendar_month_outlined, 'Horario', null, currentIdx),
                _navItem(context, Icons.grade_outlined, 'Calificaciones', null, currentIdx),
                const SizedBox(height: 16),
                _groupHeader(context, 'COMUNICACIÓN'),
                _navItem(context, Icons.campaign_outlined, 'Comunicados', 1, currentIdx),
                _navItem(context, Icons.handshake_outlined, 'Reuniones', null, currentIdx),
                _navItem(context, Icons.event_note_outlined, 'Agenda', 2, currentIdx),
                const SizedBox(height: 16),
                _groupHeader(context, 'TESORERÍA'),
                _navItem(context, Icons.account_balance_outlined, 'Pensiones', null, currentIdx),
                _navItem(context, Icons.payments_outlined, 'Cuotas', null, currentIdx),
              ],
            ),
          ),
          Container(
            width: 256,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.3))),
            ),
            child: Column(
              children: [
                _footerItem(context, Icons.person_outline, 'Mi perfil', () {
                  Navigator.pop(context);
                  context.read<ParentBloc>().add(ChangePage(pageIndex: 3));
                }, c),
                _footerItem(context, Icons.logout, 'Cerrar sesión', () {
                  context.read<ParentBloc>().add(Logout());
                  context.read<LoginBloc>().add(ResetLogin());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }, c, isLogout: true),
                _footerItem(context, themeCubit.icon, 'Cambiar tema', () {
                  themeCubit.cycle();
                  Navigator.pop(context);
                }, c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupHeader(BuildContext context, String label) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: c.textSecondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int? pageIndex, int currentIndex) {
    final c = context.appColors;
    final selected = pageIndex != null && currentIndex == pageIndex;
    return Container(
      decoration: selected
          ? BoxDecoration(
              border: Border(left: BorderSide(color: c.primary, width: 2)),
              color: c.primary.withValues(alpha: 0.1),
            )
          : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (pageIndex != null) {
              context.read<ParentBloc>().add(ChangePage(pageIndex: pageIndex));
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: selected ? c.primary : null),
                const SizedBox(width: 12),
                Text(label, style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? c.primary : c.textPrimary,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerItem(BuildContext context, IconData icon, String label, VoidCallback onTap, AppColors c, {bool isLogout = false}) {
    return SizedBox(
      width: 256,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: isLogout ? c.error.withValues(alpha: 0.8) : c.textSecondary.withValues(alpha: 0.7)),
                const SizedBox(width: 12),
                Text(label, style: TextStyle(
                  fontSize: 14,
                  fontWeight: isLogout ? FontWeight.w500 : FontWeight.normal,
                  color: isLogout ? c.error.withValues(alpha: 0.8) : c.textSecondary.withValues(alpha: 0.7),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => context.read<ParentBloc>().add(ChangePage(pageIndex: index)),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Comunicados'),
        NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Agenda'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    switch (index) {
      case 0: return _buildDashboard(context);
      case 1: return _buildPlaceholder(context, 'Comunicados', Icons.chat_bubble_outline);
      case 2: return _buildPlaceholder(context, 'Agenda', Icons.calendar_month_outlined);
      case 3: return _buildPlaceholder(context, 'Perfil', Icons.person_outline);
      default: return _buildDashboard(context);
    }
  }

  Widget _buildDashboard(BuildContext context) {
    final c = context.appColors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _quickAccessGrid(context),
          const SizedBox(height: 24),
          _attendanceSection(context),
          const SizedBox(height: 24),
          Text('Últimos comunicados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
          const SizedBox(height: 12),
          _communicationList(context),
          const SizedBox(height: 24),
          _summaryCard(context),
        ],
      ),
    );
  }

  Widget _quickAccessGrid(BuildContext context) {
    final c = context.appColors;
    final items = [
      {'icon': Icons.badge_outlined, 'label': 'Fotocheck'},
      {'icon': Icons.schedule_outlined, 'label': 'Horario'},
      {'icon': Icons.grade_outlined, 'label': 'Calificaciones'},
      {'icon': Icons.checklist_outlined, 'label': 'Asistencia'},
      {'icon': Icons.campaign_outlined, 'label': 'Comunicados'},
      {'icon': Icons.attach_money_outlined, 'label': 'Tesorería'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => Card(
        color: c.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(items[i]['icon'] as IconData, size: 32, color: c.primary),
              const SizedBox(height: 8),
              Text(items[i]['label'] as String,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: c.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attendanceSection(BuildContext context) {
    final c = context.appColors;
    final students = [
      {'name': 'Carlos', 'grade': '5° A', 'entry': '07:45', 'exit': '14:30'},
      {'name': 'Ana', 'grade': '3° B', 'entry': '07:50', 'exit': null},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle_outline, color: c.success, size: 22),
            const SizedBox(width: 8),
            Text('Asistencia hoy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: students.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final s = students[i];
              final exit = s['exit'];
              final hasExit = exit != null;
              return Card(
                color: c.surface,
                elevation: 1,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: c.border, width: 0.5),
                ),
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: c.successLight.withValues(alpha: 0.3),
                            child: Icon(Icons.person, size: 18, color: c.success),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['name'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
                              Text(s['grade'] as String, style: TextStyle(fontSize: 11, color: c.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.login, size: 16, color: c.success),
                          const SizedBox(width: 4),
                          Text('Entrada:', style: TextStyle(fontSize: 11, color: c.textSecondary)),
                          const Spacer(),
                          Text(s['entry'] as String, style: TextStyle(fontWeight: FontWeight.w700, color: c.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.logout, size: 16, color: hasExit ? c.success : c.textDisabled),
                          const SizedBox(width: 4),
                          Text('Salida:', style: TextStyle(fontSize: 11, color: c.textSecondary)),
                          const Spacer(),
                          Text(hasExit ? exit : '--:--', style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: hasExit ? c.textPrimary : c.textDisabled,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(BuildContext context) {
    final c = context.appColors;
    return Card(
      color: c.surface,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: c.primary),
                const SizedBox(width: 8),
                Text('Resumen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            _summaryRow(context, Icons.star_outline, 'Notas', '☆☆☆☆  16', c),
            const SizedBox(height: 12),
            _summaryRow(context, Icons.check_circle_outline, 'Asistencia', '██████  95%', c),
            const SizedBox(height: 12),
            _summaryRow(context, Icons.campaign_outlined, 'Comunicados', '3 nuevos', c),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, IconData icon, String label, String value, AppColors c) {
    return Row(
      children: [
        Icon(icon, size: 20, color: c.primary),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: c.textSecondary, fontSize: 14)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
      ],
    );
  }

  Widget _communicationList(BuildContext context) {
    final c = context.appColors;
    final communications = [
      {'title': 'Reunión de padres', 'date': '15/08/2026', 'desc': 'Reunión general en el auditorio'},
      {'title': 'Entrega de notas', 'date': '22/08/2026', 'desc': 'Segundo bimestre'},
      {'title': 'Día del logro', 'date': '05/09/2026', 'desc': 'Presentación de estudiantes'},
    ];
    return Column(
      children: communications.map((com) => Card(
        color: c.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: c.primaryLight.withValues(alpha: 0.2),
            child: Icon(Icons.campaign, color: c.primary, size: 20),
          ),
          title: Text(com['title']!, style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
          subtitle: Text('${com['date']} — ${com['desc']}', style: TextStyle(color: c.textSecondary, fontSize: 12)),
          trailing: Icon(Icons.chevron_right, color: c.textSecondary),
          onTap: () {},
        ),
      )).toList(),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String label, IconData icon) {
    final c = context.appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: c.textDisabled),
          const SizedBox(height: 16),
          Text(label, style: TextStyle(fontSize: 20, color: c.textSecondary)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
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
      title: const Text('Inicio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_outlined),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final c = context.appColors;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: c.primary),
            accountName: const Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            accountEmail: const Text('juan.perez@email.com', style: TextStyle(fontSize: 13)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: c.primary),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(Icons.home_outlined, 'Inicio', 0, context),
                _drawerItem(Icons.person_outline, 'Mi Perfil', null, context, subtitle: 'Cambiar contraseña'),
                _drawerItem(Icons.badge_outlined, 'Fotocheck', null, context),
                _drawerExpansionTile(context, Icons.menu_book_outlined, 'Académico', [
                  _drawerItem(Icons.schedule_outlined, 'Horario', null, context),
                  _drawerItem(Icons.grade_outlined, 'Calificaciones', null, context),
                ]),
                _drawerExpansionTile(context, Icons.checklist_outlined, 'Asistencia', [
                  _drawerItem(Icons.today_outlined, 'Diaria', null, context),
                  _drawerItem(Icons.assessment_outlined, 'General', null, context),
                  _drawerItem(Icons.badge_outlined, 'Revisar Fotocheck', null, context),
                ]),
                _drawerExpansionTile(context, Icons.forum_outlined, 'Comunicación', [
                  _drawerItem(Icons.campaign_outlined, 'Comunicados', 1, context),
                  _drawerItem(Icons.handshake_outlined, 'Reuniones', null, context),
                  _drawerItem(Icons.calendar_month_outlined, 'Agenda', 2, context),
                ]),
                _drawerExpansionTile(context, Icons.attach_money_outlined, 'Tesorería', [
                  _drawerItem(Icons.account_balance_wallet_outlined, 'Pensiones', null, context),
                  _drawerItem(Icons.receipt_long_outlined, 'Cuotas', null, context),
                ]),
                const Divider(),
                _drawerItem(Icons.settings_outlined, 'Configuración', null, context),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<ParentBloc>().add(Logout());
              context.read<LoginBloc>().add(ResetLogin());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int? pageIndex, BuildContext context, {String? subtitle}) {
    final currentIndex = context.read<ParentBloc>().state.pageIndex;
    final selected = pageIndex != null && currentIndex == pageIndex;
    return ListTile(
      leading: Icon(icon, color: selected ? Theme.of(context).colorScheme.primary : null),
      title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 11, color: context.appColors.textSecondary)) : null,
      selected: selected,
      onTap: () {
        Navigator.pop(context);
        if (pageIndex != null) {
          context.read<ParentBloc>().add(ChangePage(pageIndex: pageIndex));
        }
      },
    );
  }

  Widget _drawerExpansionTile(BuildContext context, IconData icon, String title, List<Widget> children) {
    final c = context.appColors;
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: c.textPrimary)),
      childrenPadding: const EdgeInsets.only(left: 32),
      children: children,
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
          _parentCard(context),
          const SizedBox(height: 20),
          Text('Accesos rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
          const SizedBox(height: 12),
          _quickAccessGrid(context),
          const SizedBox(height: 24),
          _summaryCard(context),
          const SizedBox(height: 24),
          Text('Últimos comunicados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
          const SizedBox(height: 12),
          _communicationList(context),
        ],
      ),
    );
  }

  Widget _parentCard(BuildContext context) {
    final c = context.appColors;
    return Card(
      color: c.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: c.primaryLight.withValues(alpha: 0.2),
          child: Icon(Icons.person, color: c.primary),
        ),
        title: Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary)),
        subtitle: Text('juan.perez@email.com', style: TextStyle(color: c.textSecondary)),
        trailing: Icon(Icons.edit_outlined, color: c.textSecondary, size: 20),
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
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _summaryCard(BuildContext context) {
    final c = context.appColors;
    return Card(
      color: c.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

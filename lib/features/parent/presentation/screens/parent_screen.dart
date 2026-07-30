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
import 'package:coleapp/features/parent/presentation/widgets/quick_access_grid.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_section.dart';
import 'package:coleapp/features/parent/presentation/widgets/communications_tab.dart';
import 'package:coleapp/features/parent/presentation/widgets/summary_card.dart';
import 'package:coleapp/features/parent/presentation/widgets/priority_banner.dart';

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
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.primary, c.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: c.primary, size: 30),
                ),
                const SizedBox(height: 12),
                const Text('MENÚ DEL PADRE', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('juan.perez@email.com', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _drawerTile(context, Icons.home_outlined, 'Inicio', 0, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.campaign_outlined, 'Comunicados', 1, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.calendar_month_outlined, 'Agenda', 2, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.checklist_outlined, 'Asistencia', null, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.menu_book_outlined, 'Académico', null, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.attach_money_outlined, 'Tesorería', null, currentIdx),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          _drawerTile(context, Icons.person_outline, 'Mi Perfil', null, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.settings_outlined, 'Configuración', null, currentIdx),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.notifications_outlined, 'Notificaciones', null, currentIdx),
                          const Divider(height: 1),
                          _themeTile(context),
                          const Divider(height: 1),
                          _drawerTile(context, Icons.logout, 'Cerrar sesión', null, currentIdx, isLogout: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeTile(BuildContext context) {
    final c = context.appColors;
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark;
    return ListTile(
      leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 22, color: c.textPrimary),
      title: Text('Cambiar tema', style: TextStyle(fontSize: 14, color: c.textPrimary)),
      trailing: Switch(
        value: isDark,
        onChanged: (_) => themeCubit.cycle(),
        activeThumbColor: c.primary,
      ),
      onTap: () => themeCubit.cycle(),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String label, int? pageIndex, int currentIndex, {bool isLogout = false}) {
    final c = context.appColors;
    final selected = pageIndex != null && currentIndex == pageIndex;

    void onTap() {
      if (isLogout) {
        context.read<ParentBloc>().add(Logout());
        context.read<LoginBloc>().add(ResetLogin());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
        return;
      }
      Navigator.pop(context);
      if (pageIndex != null) {
        context.read<ParentBloc>().add(ChangePage(pageIndex: pageIndex));
      }
    }

    return ListTile(
      leading: Icon(icon, size: 22, color: isLogout ? c.error : (selected ? c.primary : null)),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isLogout ? FontWeight.w600 : (selected ? FontWeight.w600 : FontWeight.normal),
          color: isLogout ? c.error : (selected ? c.primary : c.textPrimary),
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 20, color: c.textSecondary.withValues(alpha: 0.5)),
      onTap: onTap,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PriorityBanner(),
          const SizedBox(height: 20),
          const QuickAccessGrid(),
          const SizedBox(height: 24),
          const AttendanceSection(childrenCount: 2),
          const SizedBox(height: 12),
          const _DateHeader(),
          const SizedBox(height: 24),
          const CommunicationsTab(),
          const SizedBox(height: 24),
          const SummaryCard(),
          const SizedBox(height: 32),
        ],
      ),
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

class _DateHeader extends StatelessWidget {
  const _DateHeader();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final now = DateTime.now();
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'setiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    final weekdays = [
      'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 14, color: c.textDisabled),
          const SizedBox(width: 6),
          Text(
            '${weekdays[now.weekday % 7]}, ${now.day} de ${months[now.month - 1]} del ${now.year}',
            style: TextStyle(fontSize: 12, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

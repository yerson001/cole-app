import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_bloc.dart';
import 'package:coleapp/features/auth/presentation/bloc/login_event.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeEvent.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/core/themes/theme_page.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_bloc.dart';
import 'package:coleapp/features/profile/presentation/screens/info/bloc/profile_info_state.dart';
import 'package:coleapp/features/profile/presentation/screens/info/profile_info_content.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/FotocheckContent.dart';
import 'package:coleapp/features/parent/presentation/horario/HorarioContent.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/CalificacionesContent.dart';
import 'package:coleapp/features/parent/presentation/pensiones/PensionesContent.dart';
import 'package:coleapp/features/parent/presentation/cuotas/CuotasContent.dart';
import 'package:coleapp/features/parent/presentation/reuniones/ReunionesContent.dart';
import 'package:coleapp/features/parent/presentation/agenda/AgendaContent.dart';
import 'package:coleapp/features/parent/presentation/mas/MasContent.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_section.dart';
import 'package:coleapp/features/parent/presentation/widgets/date_header.dart';
import 'package:coleapp/features/parent/presentation/widgets/communications_tab.dart';
import 'package:coleapp/features/parent/presentation/widgets/summary_card.dart';

class ParentHomeContent extends StatefulWidget {
  const ParentHomeContent({super.key});

  @override
  State<ParentHomeContent> createState() => _ParentHomeContentState();
}

class _ParentHomeContentState extends State<ParentHomeContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sessionLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_sessionLoaded) {
        _sessionLoaded = true;
        context.read<ParentHomeBloc>().add(GetParentUser());
      }
    });
  }

  final List<Widget> pageList = const [
    _HomeBody(),
    SizedBox.shrink(),
    FotocheckContent(),
    HorarioContent(),
    CalificacionesContent(),
    PensionesContent(),
    CuotasContent(),
    ReunionesContent(),
    AgendaContent(),
    MasContent(),
    _ComunicadosContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: BlocBuilder<ParentHomeBloc, ParentHomeState>(
        builder: (context, state) {
          if (state.pageIndex == 1) {
            return BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
              builder: (context, pState) {
                return ProfileInfoContent(pState.user, students: state.students);
              },
            );
          }
          return pageList[state.pageIndex];
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (ctx) {
          return BlocBuilder<ParentHomeBloc, ParentHomeState>(
            builder: (context, state) {
              if (state.pageIndex == 0) {
                return IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              }
              if (state.pageIndex == 1) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              }
              return IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  context.read<ParentHomeBloc>().add(
                    ChangePage(pageIndex: state.previousPageIndex),
                  );
                },
              );
            },
          );
        },
      ),
      title: BlocBuilder<ParentHomeBloc, ParentHomeState>(
        builder: (context, state) {
          final titles = ['', 'Perfil', 'Fotocheck', 'Horario', 'Calificaciones',
            'Pensiones', 'Cuotas', 'Reuniones', 'Agenda', 'Más', 'Comunicados'];
          final title = state.pageIndex < titles.length ? titles[state.pageIndex] : '';
          return Text(title, style: const TextStyle(fontWeight: FontWeight.w600));
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BlocBuilder<ParentHomeBloc, ParentHomeState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: _bottomNavIndex(state.pageIndex),
          onTap: (index) {
            final pageIndex = _bottomNavToPageIndex(index);
            context.read<ParentHomeBloc>().add(ChangePage(pageIndex: pageIndex));
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: context.appColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), label: 'Comunicados'),
            BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        );
      },
    );
  }

  int _bottomNavIndex(int pageIndex) {
    if (pageIndex == 0) return 0;
    if (pageIndex == 10) return 1;
    if (pageIndex == 8) return 2;
    if (pageIndex == 1) return 3;
    return 0;
  }

  int _bottomNavToPageIndex(int navIndex) {
    switch (navIndex) {
      case 0: return 0;
      case 1: return 10;
      case 2: return 8;
      case 3: return 1;
      default: return 0;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final ac = context.appColors;
    final parentBloc = context.read<ParentHomeBloc>();
    final loginBloc = context.read<LoginBloc>();
    return Drawer(
      child: BlocBuilder<ParentHomeBloc, ParentHomeState>(
        builder: (context, state) {
          final user = state.user;
          final branch = state.branch;
          final roleName = user != null && user.roles.isNotEmpty
              ? user.roles.first.displayName
              : 'Padre';
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 4),
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ac.primary,
                      ac.primary.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    if (branch?.urlLogo != null && branch!.urlLogo!.isNotEmpty)
                      Expanded(
                        child: Opacity(
                          opacity: 0.60,
                          child: CachedNetworkImage(
                            imageUrl: branch.urlLogo!,
                            fit: BoxFit.contain,
                            errorWidget: (a, b, c) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menú del $roleName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Material(
                  type: MaterialType.canvas,
                  color: ac.surface,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 12, bottom: 4),
                        child: Text(
                          'GENERAL',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.home_outlined, color: ac.primary),
                        title: const Text('Inicio'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<ParentHomeBloc>().add(ChangePage(pageIndex: 0));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_outline, color: ac.primary),
                        title: const Text('Perfil'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<ParentHomeBloc>().add(ChangePage(pageIndex: 1));
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 16, bottom: 4),
                        child: Text(
                          'PREFERENCIAS',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(context.watch<ThemeCubit>().icon, color: ac.primary),
                        title: const Text('Tema'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (_) => const ThemePage()),
                          ).then((_) {
                            _scaffoldKey.currentState?.openDrawer();
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.security, color: ac.primary),
                        title: const Text('Roles'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true).pushNamed('roles').then((_) {
                            _scaffoldKey.currentState?.openDrawer();
                          });
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          try {
                            parentBloc.add(Logout());
                            loginBloc.add(ResetLogin());
                          } catch (_) {}
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (branch?.name != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: BoxDecoration(
                    color: ac.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Text(
                    branch!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickAccessItem {
  final String name;
  final IconData icon;
  final int pageIndex;
  const _QuickAccessItem(this.name, this.icon, this.pageIndex);
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  static const _items = [
    _QuickAccessItem('Fotocheck', Icons.badge, 2),
    _QuickAccessItem('Horario', Icons.schedule, 3),
    _QuickAccessItem('Calificaciones', Icons.grade, 4),
    _QuickAccessItem('Pensiones', Icons.payments, 5),
    _QuickAccessItem('Cuotas', Icons.receipt_long, 6),
    _QuickAccessItem('Reuniones', Icons.groups, 7),
    _QuickAccessItem('Agenda', Icons.book, 8),
    _QuickAccessItem('Más', Icons.apps, 9),
  ];

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      children: [
        for (var row = 0; row < 2; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                for (var col = 0; col < 4; col++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<ParentHomeBloc>().add(
                          ChangePage(pageIndex: _items[row * 4 + col].pageIndex),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: ac.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Icon(_items[row * 4 + col].icon, size: 26, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _items[row * 4 + col].name,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ParentHomeBloc>();
    final state = context.watch<ParentHomeBloc>().state;
    return RefreshIndicator(
      onRefresh: () async {
        if (state.students.isNotEmpty && state.branch != null) {
          bloc.add(GetDayReport(
            date: _todayDate(),
            branchId: state.branch!.id,
            studentIds: state.students.map((s) => s.id).toList(),
            tenantId: state.tenant,
          ));
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _QuickAccessGrid(),
            const SizedBox(height: 24),
            AttendanceSection(reports: state.dayReports, isLoading: state.isLoadingDayReport),
            const SizedBox(height: 12),
            const DateHeader(),
            const SizedBox(height: 20),
            const CommunicationsTab(),
            const SizedBox(height: 16),
            const SummaryCard(),
          ],
        ),
      ),
    );
  }
}

String _todayDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

class _ComunicadosContent extends StatelessWidget {
  const _ComunicadosContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Comunicados'),
    );
  }
}

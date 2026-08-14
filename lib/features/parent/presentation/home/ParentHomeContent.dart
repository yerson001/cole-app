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
import 'package:coleapp/features/parent/presentation/comunicados/ComunicadosContent.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/mas/MasContent.dart';
import 'package:coleapp/features/parent/presentation/asistencia/asistencia_page.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_section.dart';
import 'package:coleapp/features/parent/presentation/widgets/curved_header.dart';
import 'package:google_fonts/google_fonts.dart';

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
    ComunicadosContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: BlocBuilder<ParentHomeBloc, ParentHomeState>(
        builder: (context, state) {
          final navIndex = _pageToNav(state.pageIndex);
          if (navIndex >= 0) {
            return _BottomNavPages(navIndex: navIndex, students: state.students);
          }
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

  PreferredSizeWidget _buildHomeHeader(BuildContext context) {
    final state = context.watch<ParentHomeBloc>().state;
    final user = state.user;
    final greetingName = user?.person?.name ?? user?.username ?? '';
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Buenos días'
        : (hour < 19 ? 'Buenas tardes' : 'Buenas noches');
    const days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    const months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    final fullDate = '${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';
    return PreferredSize(
      preferredSize: Size.fromHeight(
        CurvedHeader.preferredHeight(MediaQuery.of(context).padding.top, 16),
      ),
      child: CurvedHeader(
        title: greetingName.isEmpty ? greeting : '$greeting, $greetingName',
        subtitle: fullDate,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationsPressed: () {},
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final state = context.watch<ParentHomeBloc>().state;
    if (state.pageIndex == 0) {
      return _buildHomeHeader(context);
    }
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
            BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), label: 'Comunicados'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Cuotas'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        );
      },
    );
  }

  int _bottomNavIndex(int pageIndex) {
    if (pageIndex == 0) return 0;
    if (pageIndex == 8) return 1;
    if (pageIndex == 10) return 2;
    if (pageIndex == 6) return 3;
    if (pageIndex == 1) return 4;
    return 0;
  }

  static int _bottomNavToPageIndex(int navIndex) {
    switch (navIndex) {
      case 0: return 0;
      case 1: return 8;
      case 2: return 10;
      case 3: return 6;
      case 4: return 1;
      default: return 0;
    }
  }

  int _pageToNav(int pageIndex) {
    switch (pageIndex) {
      case 0: return 0;
      case 8: return 1;
      case 10: return 2;
      case 6: return 3;
      case 1: return 4;
      default: return -1;
    }
  }

  static int _navToPage(int navIndex) => _bottomNavToPageIndex(navIndex);

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
  final Color color;
  const _QuickAccessItem(this.name, this.icon, this.pageIndex, this.color);
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  static const _primary = Color(0xFF225BAA);
  static const _items = [
    _QuickAccessItem('Fotocheck', Icons.badge, 2, _primary),
    _QuickAccessItem('Horario', Icons.schedule, 3, _primary),
    _QuickAccessItem('Notas', Icons.grade, 4, _primary),
    _QuickAccessItem('Más', Icons.apps, 9, _primary),
  ];

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accesos Rápidos',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ac.textPrimary),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in _items)
              GestureDetector(
                onTap: () {
                  context.read<ParentHomeBloc>().add(
                    ChangePage(pageIndex: item.pageIndex),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.color.withValues(alpha: 0.25),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        item.icon,
                        size: 26,
                        color: item.color,
                        weight: 400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ac.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BottomNavPages extends StatefulWidget {
  final int navIndex;
  final List<StudentModel> students;

  const _BottomNavPages({required this.navIndex, required this.students});

  @override
  State<_BottomNavPages> createState() => _BottomNavPagesState();
}

class _BottomNavPagesState extends State<_BottomNavPages> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.navIndex);
  }

  @override
  void didUpdateWidget(covariant _BottomNavPages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navIndex != widget.navIndex && _controller.hasClients) {
      final current = _controller.page?.round() ?? oldWidget.navIndex;
      final diff = (widget.navIndex - current).abs();
      if (diff == 1) {
        _controller.animateToPage(
          widget.navIndex,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      } else {
        _controller.jumpToPage(widget.navIndex);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: (navIndex) {
        final bloc = context.read<ParentHomeBloc>();
        final pageIndex = _ParentHomeContentState._navToPage(navIndex);
        if (bloc.state.pageIndex != pageIndex) {
          bloc.add(ChangePage(pageIndex: pageIndex));
        }
      },
      children: [
        const _HomeBody(),
        const AgendaContent(),
        const ComunicadosContent(),
        const CuotasContent(),
        BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
          builder: (context, pState) => ProfileInfoContent(pState.user, students: widget.students),
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
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      child: RefreshIndicator(
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
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AttendanceSection(
                reports: state.dayReports,
                isLoading: state.isLoadingDayReport,
                onVerMas: () {
                  print('[DEBUG] Ver más tapped. students=${state.students.length}, branch=${state.branch?.id}, tenant=${state.tenant}');
                  if (state.students.isNotEmpty) {
                    Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => AsistenciaPage(
                            students: state.students,
                            tenant: state.tenant,
                            branchId: state.branch?.id ?? 1,
                          ),
                        ),
                      )
                      .then((_) {
                        print('[DEBUG] Back from AsistenciaPage -> reload daily attendance');
                        if (state.students.isNotEmpty && state.branch != null) {
                          context.read<ParentHomeBloc>().add(GetDayReport(
                            date: _todayDate(),
                            branchId: state.branch!.id,
                            studentIds: state.students.map((s) => s.id).toList(),
                            tenantId: state.tenant,
                          ));
                        }
                      });
                  }
                },
              ),
              const SizedBox(height: 5),
              const _QuickAccessGrid(),
              const SizedBox(height: 5),
              const _HomeTabs(),
            ],
          ),
        ),
      ),
    );
  }
}

String _todayDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

class _HomeTabs extends StatefulWidget {
  const _HomeTabs();

  @override
  State<_HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<_HomeTabs> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final state = context.watch<ParentHomeBloc>().state;
    final labels = const ['Comunicados', 'Reuniones', 'Agenda'];
    final totalCount = state.comunicados.length + state.meetings.length + state.agendaItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Contenido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ac.textPrimary),
            ),
            const SizedBox(width: 6),
            if (totalCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 16,
                constraints: const BoxConstraints(minWidth: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ac.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$totalCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ac.fill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selected == i ? ac.card : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _selected == i
                            ? Border.all(color: ac.border)
                            : Border.all(color: Colors.transparent),
                        boxShadow: _selected == i
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _selected == i ? FontWeight.w600 : FontWeight.w500,
                          color: _selected == i ? ac.primary : ac.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (state.isLoadingTabs && state.comunicados.isEmpty && state.meetings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else
          _buildTabContent(state, _selected),
      ],
    );
  }

  Widget _buildTabContent(ParentHomeState state, int index) {
    switch (index) {
      case 1:
        final meetings = state.meetings;
        if (meetings.isEmpty) {
          return _emptyState('No hay reuniones por ahora');
        }
        return Column(
          children: [
            for (final m in meetings.take(3))
              _HomeTabCard(
                icon: Icons.groups,
                color: const Color(0xFF01AFEB),
                title: m.parentMeeting.subject,
                time: m.parentMeeting.timeRange,
                description: _formatMeetingDate(m.parentMeeting.date),
              ),
          ],
        );
      case 2:
        final items = state.agendaItems;
        if (items.isEmpty) {
          return _emptyState('No hay eventos en agenda');
        }
        return Column(
          children: [
            for (final item in items.take(3))
              _HomeTabCard(
                icon: Icons.event,
                color: const Color(0xFFFF9B38),
                title: item.title,
                time: _formatShortDate(item.dueDate),
                description: item.description,
              ),
          ],
        );
      default:
        final items = state.comunicados;
        if (items.isEmpty) {
          return _emptyState('No hay comunicados por ahora');
        }
        return Column(
          children: [
            for (final item in items.take(3))
              _HomeTabCard(
                icon: Icons.campaign_outlined,
                color: const Color(0xFFFE4349),
                title: item.title,
                time: _formatShortDate(item.publishedAt),
                description: item.description,
              ),
          ],
        );
    }
  }

  Widget _emptyState(String message) {
    final ac = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 13, color: ac.textSecondary.withValues(alpha: 0.7)),
        ),
      ),
    );
  }

  String _formatShortDate(String? iso) {
    final date = DateTime.tryParse(iso ?? '');
    if (date == null) return '';
    const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatMeetingDate(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    const days = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }
}

class _HomeTabCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  final String description;

  const _HomeTabCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ac.textPrimary,
                            ),
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: ac.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: ac.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: ac.border,
          indent: 52,
        ),
      ],
    );
  }
}



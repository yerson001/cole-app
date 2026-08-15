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
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final page = context.read<ParentHomeBloc>().state.pageIndex;
        const navPages = {0, 1, 6, 8, 10};
        if (navPages.contains(page)) {
          _scaffoldKey.currentState?.openDrawer();
        } else {
          context.read<ParentHomeBloc>().add(
            ChangePage(
              pageIndex: context.read<ParentHomeBloc>().state.previousPageIndex,
            ),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        body: BlocBuilder<ParentHomeBloc, ParentHomeState>(
          builder: (context, state) {
            final navIndex = _pageToNav(state.pageIndex);
            if (navIndex >= 0) {
              return _BottomNavPages(
                navIndex: navIndex,
                students: state.students,
              );
            }
            if (state.pageIndex == 1) {
              return BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
                builder: (context, pState) {
                  return ProfileInfoContent(
                    pState.user,
                    students: state.students,
                    branch: state.branch,
                  );
                },
              );
            }
            return pageList[state.pageIndex];
          },
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
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
    const days = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final fullDate =
        '${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';
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
    final ac = context.appColors;
    return AppBar(
      backgroundColor: ac.surface,
      foregroundColor: ac.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
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
          final titles = [
            '',
            'Perfil',
            'Fotocheck',
            'Horario',
            'Calificaciones',
            'Pensiones',
            'Cuotas',
            'Reuniones',
            'Agenda',
            'Más',
            'Comunicados',
          ];
          final title = state.pageIndex < titles.length
              ? titles[state.pageIndex]
              : '';
          return Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
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
            context.read<ParentHomeBloc>().add(
              ChangePage(pageIndex: pageIndex),
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: context.appColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'INICIO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'AGENDA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              label: 'AVISOS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'CUOTAS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'PERFIL',
            ),
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
      case 0:
        return 0;
      case 1:
        return 8;
      case 2:
        return 10;
      case 3:
        return 6;
      case 4:
        return 1;
      default:
        return 0;
    }
  }

  int _pageToNav(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 0;
      case 8:
        return 1;
      case 10:
        return 2;
      case 6:
        return 3;
      case 1:
        return 4;
      default:
        return -1;
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
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? LinearGradient(
                          colors: const [Color(0xFF191C1F), Color(0xFF23272B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
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
                        padding: const EdgeInsets.only(
                          left: 4,
                          top: 12,
                          bottom: 4,
                        ),
                        child: Text(
                          'GENERAL',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.home_outlined, color: ac.primary),
                        title: const Text('Inicio'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<ParentHomeBloc>().add(
                            ChangePage(pageIndex: 0),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_outline, color: ac.primary),
                        title: const Text('Perfil'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<ParentHomeBloc>().add(
                            ChangePage(pageIndex: 1),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          top: 16,
                          bottom: 4,
                        ),
                        child: Text(
                          'PREFERENCIAS',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          context.watch<ThemeCubit>().icon,
                          color: ac.primary,
                        ),
                        title: const Text('Tema'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context, rootNavigator: true)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => const ThemePage(),
                                ),
                              )
                              .then((_) {
                                _scaffoldKey.currentState?.openDrawer();
                              });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.security, color: ac.primary),
                        title: const Text('Roles'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed('roles').then((_) {
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
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
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

class _StudentCard extends StatelessWidget {
  final ReportStudent student;
  final int total;
  final int currentIndex;

  const _StudentCard({
    required this.student,
    required this.total,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final avatarColor = _avatarColors[currentIndex % _avatarColors.length];
    final initials = [
      student.name,
      student.lastName,
    ].where((p) => p.isNotEmpty).map((p) => p[0].toUpperCase()).take(2).join();

    String capitalize(String value) {
      if (value.isEmpty) return value;
      return value[0].toUpperCase() + value.substring(1).toLowerCase();
    }

    final gradeLabel =
        '${capitalize(student.level.name)} · '
        '${capitalize(student.grade.name)} ${capitalize(student.section.name)}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ac.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.name} ${student.lastName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ac.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  gradeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, color: ac.textSecondary),
                ),
              ],
            ),
          ),
          if (total > 1)
            Row(
              children: [
                for (var i = 0; i < total; i++)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == currentIndex ? ac.primary : ac.border,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TodayLabel extends StatelessWidget {
  final int current;
  final int total;

  const _TodayLabel({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'HOY',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: ac.textDisabled,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          total > 0 ? '$current de $total' : '',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ac.primary,
          ),
        ),
      ],
    );
  }
}

class _StatusLegend extends StatelessWidget {
  const _StatusLegend();

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    Widget item(IconData icon, Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: ac.textDisabled)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
      child: Row(
        children: [
          item(Icons.check_circle, ac.success, 'A tiempo'),
          const SizedBox(width: 14),
          item(Icons.access_time, ac.warning, 'Tarde'),
          const SizedBox(width: 14),
          item(Icons.close, ac.error, 'Falta'),
        ],
      ),
    );
  }
}

const _avatarColors = [
  Color(0xFF225BAA),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
  Color(0xFFC62828),
  Color(0xFF00838F),
];

class _QuickAccessItem {
  final String name;
  final IconData icon;
  final int pageIndex;
  const _QuickAccessItem(this.name, this.icon, this.pageIndex);
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  static const _items = [
    _QuickAccessItem('Fotocheck', Icons.badge_outlined, 2),
    _QuickAccessItem('Horario', Icons.access_time, 3),
    _QuickAccessItem('Notas', Icons.notes, 4),
    _QuickAccessItem('Más', Icons.more_horiz, 9),
  ];

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCESOS RAPIDOS',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: ac.textDisabled,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final item in _items)
              Expanded(
                child: SizedBox(
                  height: 76,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.read<ParentHomeBloc>().add(
                          ChangePage(pageIndex: item.pageIndex),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: ac.fill,
                              shape: BoxShape.circle,
                              border: Border.all(color: ac.border),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              item.icon,
                              size: 23,
                              color: ac.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: ac.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
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
          builder: (context, pState) => ProfileInfoContent(
            pState.user,
            students: widget.students,
            branch: context.read<ParentHomeBloc>().state.branch,
          ),
        ),
      ],
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  int _currentReport = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ParentHomeBloc>();
    final state = context.watch<ParentHomeBloc>().state;
    final reports = state.dayReports;
    final currentStudent = reports.isNotEmpty
        ? reports[_currentReport.clamp(0, reports.length - 1)].student
        : null;
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          if (state.students.isNotEmpty && state.branch != null) {
            bloc.add(
              GetDayReport(
                date: _todayDate(),
                branchId: state.branch!.id,
                studentIds: state.students.map((s) => s.id).toList(),
                tenantId: state.tenant,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reports.isNotEmpty && currentStudent != null) ...[
                _StudentCard(
                  student: currentStudent,
                  total: reports.length,
                  currentIndex: _currentReport,
                ),
              ],
              const SizedBox(height: 14),
              _TodayLabel(
                current: reports.isEmpty ? 0 : _currentReport + 1,
                total: reports.length,
              ),
              const SizedBox(height: 8),
              AttendanceSection(
                reports: reports,
                isLoading: state.isLoadingDayReport,
                onPageChanged: (index) =>
                    setState(() => _currentReport = index),
                onVerMas: () {
                  print(
                    '[DEBUG] Ver más tapped. students=${state.students.length}, branch=${state.branch?.id}, tenant=${state.tenant}',
                  );
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
                          print(
                            '[DEBUG] Back from AsistenciaPage -> reload daily attendance',
                          );
                          if (state.students.isNotEmpty &&
                              state.branch != null) {
                            context.read<ParentHomeBloc>().add(
                              GetDayReport(
                                date: _todayDate(),
                                branchId: state.branch!.id,
                                studentIds: state.students
                                    .map((s) => s.id)
                                    .toList(),
                                tenantId: state.tenant,
                              ),
                            );
                          }
                        });
                  }
                },
              ),
              if (reports.isNotEmpty) const _StatusLegend(),
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
    final totalCount =
        state.comunicados.length +
        state.meetings.length +
        state.agendaItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Contenido',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ac.textPrimary,
              ),
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
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ac.border, width: 1)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                _HomeTabItem(
                  text: labels[i],
                  active: _selected == i,
                  onTap: () => setState(() => _selected = i),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (state.isLoadingTabs &&
            state.comunicados.isEmpty &&
            state.meetings.isEmpty)
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
      padding: const EdgeInsets.fromLTRB(0, 34, 0, 26),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sentiment_satisfied_alt,
              size: 26,
              color: ac.textDisabled,
            ),
            const SizedBox(height: 10),
            Text(
              'Todo tranquilo por aqui',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ac.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: TextStyle(fontSize: 12.5, color: ac.textDisabled),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(String? iso) {
    final date = DateTime.tryParse(iso ?? '');
    if (date == null) return '';
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatMeetingDate(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    const days = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }
}

class _HomeTabItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _HomeTabItem({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(bottom: 9),
          alignment: Alignment.center,
          decoration: active
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ac.primary, width: 2),
                  ),
                )
              : null,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: active ? ac.primary : ac.textDisabled,
            ),
          ),
        ),
      ),
    );
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
        Divider(height: 1, thickness: 1, color: ac.border, indent: 52),
      ],
    );
  }
}

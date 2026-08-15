import 'package:flutter/material.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  bool isDark = false;

  // Paleta de colores para modo claro
  final Map<String, Color> lightColors = {
    'bg': const Color(0xFFFFFFFF),
    'card': const Color(0xFFFFFFFF),
    'txt': const Color(0xFF111111),
    'txt2': const Color(0xFF5B5B5B),
    'txt3': const Color(0xFF9B9B9B),
    'brand': const Color(0xFF0A66C2),
    'brandTint': const Color(0xFFF0F4F9),
    'line': const Color(0xFFEAEAEA),
  };

  // Paleta de colores para modo oscuro
  final Map<String, Color> darkColors = {
    'bg': const Color(0xFF000000),
    'card': const Color(0xFF141414),
    'txt': const Color(0xFFF5F5F5),
    'txt2': const Color(0xFFA3A3A3),
    'txt3': const Color(0xFF6E6E6E),
    'brand': const Color(0xFF5B9BD8),
    'brandTint': const Color(0xFF141B22),
    'line': const Color(0xFF242424),
  };

  // Getter para los colores actuales según el modo
  Map<String, Color> get colors => isDark ? darkColors : lightColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // para que el fondo sea el del contenedor
      body: Center(
        child: Container(
          width: 360, // Ancho fijo como el HTML
          decoration: BoxDecoration(
            color: colors['bg'],
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Botón toggle y barra superior ---
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildToggleButton(),
                  ],
                ),
              ),

              // --- Header con flecha, título y campana ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: colors['txt'], size: 20),
                    const Spacer(),
                    Text(
                      'Agenda',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: colors['txt'],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.notifications_none, color: colors['txt2'], size: 19),
                  ],
                ),
              ),

              // --- Selector de contactos (avatares) ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  children: [
                    _buildAvatarOption(
                      icon: Icons.people,
                      label: 'Todos',
                      isSelected: false,
                    ),
                    const SizedBox(width: 20),
                    _buildAvatarOption(
                      initials: 'MC',
                      label: 'Madison',
                      isSelected: true,
                    ),
                    const SizedBox(width: 20),
                    _buildAvatarOption(
                      initials: 'IC',
                      label: 'Ivet',
                      isSelected: false,
                    ),
                    const SizedBox(width: 20),
                    _buildAvatarOption(
                      initials: 'SF',
                      label: 'Summer',
                      isSelected: false,
                    ),
                  ],
                ),
              ),

              // --- Selector de vista (Mensual, Semanal, Diario) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors['brandTint'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      _buildViewOption('Mensual', isSelected: true),
                      _buildViewOption('Semanal', isSelected: false),
                      _buildViewOption('Diario', isSelected: false),
                    ],
                  ),
                ),
              ),

              // --- Navegador de semana (chevrones + fechas) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left, color: colors['txt3'], size: 18),
                    Text(
                      '10 ago – 16 ago 2026',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors['txt'],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors['txt3'], size: 18),
                  ],
                ),
              ),

              // --- Días de la semana (con resaltado del 14) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDayColumn('LUN', '10', isActive: false),
                    _buildDayColumn('MAR', '11', isActive: false),
                    _buildDayColumn('MIE', '12', isActive: false),
                    _buildDayColumn('JUE', '13', isActive: false),
                    _buildDayColumn('VIE', '14', isActive: true), // día seleccionado
                    _buildDayColumn('SAB', '15', isActive: false),
                    _buildDayColumn('DOM', '16', isActive: false),
                  ],
                ),
              ),

              const Divider(height: 20, thickness: 1),

              // --- Mensaje "Sin eventos" ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 30, color: colors['txt3']),
                    const SizedBox(height: 14),
                    Text(
                      'Sin eventos esta semana',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colors['txt'],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reuniones, actividades y fechas importantes de Madison apareceran aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors['txt3'],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // --- Barra inferior de navegación ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors['line']!, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home, 'INICIO', isActive: false),
                    _buildNavItem(Icons.bookmark, 'AGENDA', isActive: true),
                    _buildNavItem(Icons.volume_up, 'AVISOS', isActive: false),
                    _buildNavItem(Icons.receipt_long, 'CUOTAS', isActive: false),
                    _buildNavItem(Icons.person, 'PERFIL', isActive: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----- Widgets auxiliares -----

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDark = !isDark;
        });
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors['brandTint'],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            isDark ? 'Modo claro' : 'Modo oscuro',
            style: TextStyle(
              fontSize: 12,
              color: colors['brand'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    IconData? icon,
    String? initials,
    required String label,
    required bool isSelected,
  }) {
    final isIcon = icon != null;
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? colors['brand']! : colors['line']!,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: isIcon
                ? Icon(icon, color: colors['txt2'], size: 19)
                : Text(
                    initials!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? colors['brand'] : colors['txt2'],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? colors['brand'] : colors['txt2'],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildViewOption(String label, {required bool isSelected}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors['card'] : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? colors['txt'] : colors['brand'],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayColumn(String day, String number, {required bool isActive}) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 10.5,
            color: isActive ? colors['brand'] : colors['txt3'],
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colors['brand'] : Colors.transparent,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : colors['txt'],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, {required bool isActive}) {
    return Column(
      children: [
        Icon(
          icon,
          color: isActive ? colors['brand'] : colors['txt3'],
          size: 20,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? colors['brand'] : colors['txt3'],
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
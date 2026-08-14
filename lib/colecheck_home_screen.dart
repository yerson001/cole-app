// ============================================================
// COLECHECK - HOME SCREEN
// Codigo completo listo para pegar en tu proyecto Flutter.
// Todo el diseno (colores, tamanos, espaciado) esta explicado
// en comentarios justo donde se usa.
// ============================================================

import 'package:flutter/material.dart';

// ------------------------------------------------------------
// 1. COLORES
// Junta todos los colores en un solo lugar. Si cambias un color
// aca, cambia en toda la app. Hay un set para modo claro y otro
// para modo oscuro.
// ------------------------------------------------------------
class CCColors {
  final Color bg;    // fondo de toda la pantalla
  final Color card;  // fondo de las tarjetas (blanco en claro, gris oscuro en dark)
  final Color txt;   // texto principal / mas importante (negro o blanco)
  final Color txt2;  // texto secundario (subtitulos, descripciones)
  final Color txt3;  // texto terciario (labels chiquitos, iconos apagados)
  final Color brand; // EL UNICO color de acento -> azul, para todo lo interactivo
  final Color ok;    // verde -> solo para "a tiempo"
  final Color warn;  // ambar -> solo para "tarde"
  final Color bad;   // rojo -> solo para "falta"
  final Color line;  // color de bordes / lineas divisoras (gris muy clarito)

  const CCColors({
    required this.bg,
    required this.card,
    required this.txt,
    required this.txt2,
    required this.txt3,
    required this.brand,
    required this.ok,
    required this.warn,
    required this.bad,
    required this.line,
  });

  // MODO CLARO
  static const light = CCColors(
    bg: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    txt: Color(0xFF111111),
    txt2: Color(0xFF5B5B5B),
    txt3: Color(0xFF9B9B9B),
    brand: Color(0xFF0A66C2), // azul (el mismo tono de LinkedIn que pediste)
    ok: Color(0xFF0F6E56),
    warn: Color(0xFFB0790F),
    bad: Color(0xFFA32D2D),
    line: Color(0xFFEAEAEA),
  );

  // MODO OSCURO
  static const dark = CCColors(
    bg: Color(0xFF000000),
    card: Color(0xFF141414),
    txt: Color(0xFFF5F5F5),
    txt2: Color(0xFFA3A3A3),
    txt3: Color(0xFF6E6E6E),
    brand: Color(0xFF5B9BD8), // azul mas claro para que resalte sobre negro
    ok: Color(0xFF5DCAA5),
    warn: Color(0xFFEF9F27),
    bad: Color(0xFFF09595),
    line: Color(0xFF242424),
  );
}

// ------------------------------------------------------------
// 2. PANTALLA PRINCIPAL
// ------------------------------------------------------------
class ColeCheckHome extends StatelessWidget {
  const ColeCheckHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Detecta si el celular esta en modo oscuro y elige el set de colores.
    // Si prefieres forzar un modo fijo, cambia esta linea por:
    // final c = CCColors.light;  (o CCColors.dark)
    final brightness = MediaQuery.of(context).platformBrightness;
    final c = brightness == Brightness.dark ? CCColors.dark : CCColors.light;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        // *** ACA ESTA EL SCROLL ***
        // SingleChildScrollView hace que TODO el contenido de la pantalla
        // (header, tarjetas, accesos rapidos, tabs, estado vacio) se pueda
        // deslizar verticalmente si no entra en la altura del celular.
        // Solo el bottom nav (mas abajo) queda FIJO fuera de este scroll.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(c: c),
              _StudentCard(c: c),
              _TodayLabel(c: c),
              _AttendanceCard(c: c),
              _StatusLegend(c: c),
              _WeekLink(c: c),
              _QuickAccess(c: c),
              _Tabs(c: c),
              _EmptyState(c: c),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      // El bottom nav NO scrollea, siempre esta pegado abajo.
      bottomNavigationBar: _BottomNav(c: c),
    );
  }
}

// ------------------------------------------------------------
// 3. HEADER (saludo + iconos)
// ------------------------------------------------------------
class _Header extends StatelessWidget {
  final CCColors c;
  const _Header({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: 20px a los lados, 18px arriba, 8px abajo
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenas tardes, Pedro',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500, // medium, nunca bold
                  color: c.txt, // negro (o blanco en dark)
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'viernes, 14 de agosto',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: c.txt2, // gris secundario
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 19, color: c.txt2),
              const SizedBox(width: 14),
              Icon(Icons.menu, size: 19, color: c.txt2),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 4. TARJETA DEL ALUMNO
// Fondo blanco/gris oscuro (c.card), borde de 1px (c.line),
// esquinas redondeadas 16px. NO tiene sombra.
// ------------------------------------------------------------
class _StudentCard extends StatelessWidget {
  final CCColors c;
  const _StudentCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16), // radio de tarjeta = 16px
        border: Border.all(color: c.line, width: 1), // borde en vez de sombra
      ),
      child: Row(
        children: [
          // Avatar circular con iniciales
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: c.txt, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              'MC',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: c.card, // color invertido: blanco sobre negro
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Madison Jenifer Angelina',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: c.txt)),
                const SizedBox(height: 2),
                Text('Primaria · Primero A',
                    style: TextStyle(fontSize: 12.5, color: c.txt2)),
              ],
            ),
          ),
          // Puntos de paginacion (si el padre tiene mas de un hijo)
          Row(
            children: [
              _Dot(color: c.brand), // el activo, en azul
              const SizedBox(width: 4),
              _Dot(color: c.line),
              const SizedBox(width: 4),
              _Dot(color: c.line),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ------------------------------------------------------------
// 5. LABEL "HOY" + "1 de 3"
// ------------------------------------------------------------
class _TodayLabel extends StatelessWidget {
  final CCColors c;
  const _TodayLabel({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('HOY',
              style: TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w500, color: c.txt3, letterSpacing: 0.8)),
          Text('1 de 3',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: c.brand)),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 6. TARJETA DE ASISTENCIA (entrada / salida)
// ------------------------------------------------------------
class _AttendanceCard extends StatelessWidget {
  final CCColors c;
  const _AttendanceCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- ENTRADA ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 13, color: c.ok), // verde = a tiempo
                    const SizedBox(width: 5),
                    Text('ENTRADA', style: TextStyle(fontSize: 11, color: c.txt3, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '02:58 ',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: c.txt),
                      ),
                      TextSpan(
                        text: 'AM',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: c.txt2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Registrada',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: c.brand)),
                const SizedBox(height: 1),
                Text('Puerta principal', style: TextStyle(fontSize: 11.5, color: c.txt3)),
              ],
            ),
          ),
          // Linea vertical divisoria
          Container(width: 1, height: 80, color: c.line, margin: const EdgeInsets.symmetric(horizontal: 16)),
          // --- SALIDA ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 13, color: c.txt3), // gris = pendiente
                    const SizedBox(width: 5),
                    Text('SALIDA', style: TextStyle(fontSize: 11, color: c.txt3, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('--:--', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: c.txt3)),
                const SizedBox(height: 6),
                Text('Pendiente', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: c.txt3)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 17, color: c.txt3),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 7. LEYENDA DE ESTADOS (a tiempo / tarde / falta)
// Estos son los UNICOS lugares de la app donde se usa verde/ambar/rojo.
// ------------------------------------------------------------
class _StatusLegend extends StatelessWidget {
  final CCColors c;
  const _StatusLegend({required this.c});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: c.txt3)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          item(Icons.check_circle, c.ok, 'A tiempo'),
          const SizedBox(width: 14),
          item(Icons.access_time, c.warn, 'Tarde'),
          const SizedBox(width: 14),
          item(Icons.close, c.bad, 'Falta'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 8. ENLACE "VER ASISTENCIA DE LA SEMANA"
// ------------------------------------------------------------
class _WeekLink extends StatelessWidget {
  final CCColors c;
  const _WeekLink({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            // TODO: navegar a la pantalla de historial semanal
          },
          child: Text(
            'Ver asistencia de la semana →',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: c.brand),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 9. ACCESOS RAPIDOS (iconos sueltos, sin circulo de fondo)
// ------------------------------------------------------------
class _QuickAccess extends StatelessWidget {
  final CCColors c;
  const _QuickAccess({required this.c});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label) {
      return Column(
        children: [
          Icon(icon, size: 23, color: c.txt), // negro, sin fondo detras
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: c.txt2)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACCESOS RAPIDOS',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: c.txt3, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              item(Icons.badge_outlined, 'Fotocheck'),
              item(Icons.access_time, 'Horario'),
              item(Icons.notes, 'Notas'),
              item(Icons.more_horiz, 'Mas'),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 10. TABS (Comunicados / Reuniones / Agenda)
// ------------------------------------------------------------
class _Tabs extends StatelessWidget {
  final CCColors c;
  const _Tabs({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line, width: 1))),
      child: Row(
        children: [
          _TabItem(text: 'Comunicados', active: true, c: c),
          const SizedBox(width: 20),
          _TabItem(text: 'Reuniones', active: false, c: c),
          const SizedBox(width: 20),
          _TabItem(text: 'Agenda', active: false, c: c),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool active;
  final CCColors c;
  const _TabItem({required this.text, required this.active, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 9),
      decoration: active
          ? BoxDecoration(border: Border(bottom: BorderSide(color: c.brand, width: 2)))
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: active ? c.brand : c.txt3,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 11. ESTADO VACIO (cuando no hay comunicados)
// ------------------------------------------------------------
class _EmptyState extends StatelessWidget {
  final CCColors c;
  const _EmptyState({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 26),
      child: Column(
        children: [
          Icon(Icons.sentiment_satisfied_alt, size: 26, color: c.txt3),
          const SizedBox(height: 10),
          Text('Todo tranquilo por aqui',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.txt)),
          const SizedBox(height: 2),
          Text('No tienes nuevos comunicados', style: TextStyle(fontSize: 12.5, color: c.txt3)),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 12. BOTTOM NAV (fijo, fuera del scroll)
// ------------------------------------------------------------
class _BottomNav extends StatelessWidget {
  final CCColors c;
  const _BottomNav({required this.c});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label, bool active) {
      final color = active ? c.brand : c.txt3;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: color, fontWeight: active ? FontWeight.w500 : FontWeight.w400)),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(top: BorderSide(color: c.line, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          item(Icons.home_outlined, 'INICIO', true),
          item(Icons.calendar_today_outlined, 'AGENDA', false),
          item(Icons.campaign_outlined, 'AVISOS', false),
          item(Icons.receipt_long_outlined, 'CUOTAS', false),
          item(Icons.person_outline, 'PERFIL', false),
        ],
      ),
    );
  }
}

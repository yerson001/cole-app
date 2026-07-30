# Parent Dashboard — Layout

```
┌────────────────────────────────────────────┐
│  🔥 ¡COMUNICADO IMPORTANTE!          24h   │  ← PriorityBanner (rojo, tap → se oculta)
├────────────────────────────────────────────┤
│  [Fotocheck] [Horario] [Calificaciones]    │  ← QuickAccessGrid
│  [Pensiones]  [Cuotas]  [Reuniones]        │     (2 filas, 4+4)
│  [Agenda]     [Más]                        │     (icono en card cuadrado, nombre debajo)
├────────────────────────────────────────────┤
│  Asistencia hoy (2)              Ver más →  │  ← AttendanceSection
│  ┌──────────┐ ┌──────────┐ ┌──────────┐    │     Scroll horizontal
│  │ CARLOS   │ │ FRANKYE  │ │ SOFIA    │    │
│  │ GUSTAVO  │ │ RICARDO  │ │ LUCIANA  │    │
│  │ [Aula]   │ │ [Puerta] │ │ [Puerta] │    │
│  │ Sec - 1B │ │ Sec - 4C │ │ Prim - 3A│    │
│  │          │ │          │ │          │    │
│  │ INGRESO  │ │ INGRESO  │ │ INGRESO  │    │
│  │  07:45   │ │  08:10   │ │  --:--   │    │
│  │ PRESENTE  │ │  TARDE   │ │SIN MARCAR│    │
│  │          │ │          │ │          │    │
│  │ SALIDA   │ │ SALIDA   │ │ SALIDA   │    │
│  │  14:30   │ │  --:--   │ │  --:--   │    │
│  │ PRESENTE  │ │SIN MARCAR│ │SIN MARCAR│    │
│  └──────────┘ └──────────┘ └──────────┘    │
├────────────────────────────────────────────┤
│  📅 Miércoles, 23 de julio del 2026        │  ← _DateHeader
├────────────────────────────────────────────┤
│  [Comunicados] [Reuniones] [Agenda]        │  ← CommunicationsTab
│  ┌ Reunión de padres 15/08/2026         →┐ │     TabBar con 3 tabs
│  ├ Entrega de notas    22/08/2026        →┤ │
│  ├ Día del logro       05/09/2026        →┤ │
│  └───────────────────────────────────────┘ │
├────────────────────────────────────────────┤
│  Resumen                                    │  ← SummaryCard
│  Notas        ☆☆☆☆  16                     │
│  Asistencia   ██████  95%                   │
│  Comunicados  3 nuevos                      │
└────────────────────────────────────────────┘
```

## Drawer — Patrón initflutter

**Fuente:** `/home/yrsn/Dev/cole-check/initflutter/lib/src/presentation/pages/client/home/ClientHomePage.dart` (cliente) y `/home/yrsn/Dev/cole-check/initflutter/lib/src/presentation/pages/driver/home/DriverHomePage.dart` (conductor).

El drawer se implementa inline en `ParentContent` siguiendo ese patrón:

```
Scaffold(
  drawer: BlocBuilder<ParentBloc, ParentState>(
    builder: (context, state) => Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(gradient: ...),
            child: Text('Menú del Padre'),
          ),
          // SECCIÓN GENERAL
          Padding(child: Text('GENERAL', style: ...)),
          Card(
            child: Column(children: [
              ListTile(
                selected: state.pageIndex == 0,
                leading: Icon(Icons.home_outlined),
                title: Text('Inicio'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  context.read<ParentBloc>().add(ChangePage(pageIndex: 0));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: state.pageIndex == 1,
                leading: Icon(Icons.people_outline),
                title: Text('Hijos/Estudiantes'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  context.read<ParentBloc>().add(ChangePage(pageIndex: 1));
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
          // SECCIÓN PREFERENCIAS
          Padding(child: Text('PREFERENCIAS', style: ...)),
          Card(
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Cerrar sesión', style: ...),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () { /* logout + navigate */ },
              ),
            ]),
          ),
        ],
      ),
    ),
  ),
  body: BlocBuilder<ParentBloc, ParentState>(
    builder: (context, state) => pageList[state.pageIndex],
  ),
)
```

**Reglas del drawer:**
- `DrawerHeader` con gradiente y título del rol
- Secciones con `Text` header (ej. "GENERAL", "PREFERENCIAS")
- Cada sección es un `Card` > `Column` > `ListTile`s
- Cada `ListTile` tiene `selected: state.pageIndex == N`
- `onTap` dispatchea `ChangePage(pageIndex: N)` + `Navigator.pop(context)`
- Logout va como último tile en "PREFERENCIAS" (NO como FAB)
- Sin FAB flotante — el logout está en el drawer

## Widgets (presentation/widgets/)

| Widget | Archivo | Descripción |
|---|---|---|
| `QuickAccessGrid` | `quick_access_grid.dart` | 2 filas, 4 columnas, icono 26px en card cuadrado 48x48, nombre debajo del card |
| `AttendanceSection` | `attendance_section.dart` | Header "Asistencia hoy (n)" + botón "Ver más" + scroll horizontal de AttendanceCard |
| `AttendanceCard` | `attendance_card.dart` | Ancho 320. Avatar + nombre + apellido + badge (Aula/Puerta) + curso + INGRESO/SALIDA |
| `CommunicationsTab` | `communications_tab.dart` | Card con TabBar: Comunicados (lista), Reuniones, Agenda (placeholders) |
| `SummaryCard` | `summary_card.dart` | 3 filas: Notas, Asistencia, Comunicados |
| `PriorityBanner` | `priority_banner.dart` | Gradiente rojo, desaparece al tap |

## Estados de check-in

| statusCheckIn | Muestra |
|---|---|
| `PRESENT` | Hora + PRESENTE (verde) |
| `LATE` | Hora + TARDE (naranja) |
| `ABSENT` | --:-- + FALTO (rojo) |
| `UNMARKED` | --:-- + SIN MARCAR (gris) |

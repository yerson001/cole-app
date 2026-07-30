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

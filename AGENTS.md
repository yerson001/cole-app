# Contexto del proyecto — Colecheck

## Patrón initflutter — Drawer (debe reflejarse en parent)

**Fuente:** `initflutter/lib/src/presentation/pages/client/home/ClientHomePage.dart` (cliente) y `initflutter/lib/src/presentation/pages/driver/home/DriverHomePage.dart` (conductor).

El proyecto initflutter define el drawer inline dentro de un `StatefulWidget`, dentro de un `BlocBuilder`:

```
Estado → Changes pageIndex via Bloc
Page → StatefulWidget con pageList + Scaffold + drawer inline
Drawer → dentro de BlocBuilder<Bloc, State>:
   └─ DrawerHeader (gradient + titulo del rol)
   └─ Secciones con Text header (ej. "GENERAL", "PREFERENCIAS")
   └─ Card > Column > ListTile c/u:
        - selected: state.pageIndex == N
        - onTap: dispatch ChangeDrawerPage(pageIndex: N) + Navigator.pop
   └─ Logout como ultimo ListTile en seccion "PREFERENCIAS"
```

## Parent Dashboard — Drawer estilo

El archivo `parent_dashboard_vista.md` NO define el drawer, solo el body. El drawer debe seguir el patron initflutter:
- DrawerHeader: "Menu del Padre"
- Secciones: "GENERAL", "PREFERENCIAS"
- Items GENERAL: Inicio (home), Hijos/Estudiantes
- Items PREFERENCIAS: Cerrar sesion
- Sin FAB (logout va en drawer)

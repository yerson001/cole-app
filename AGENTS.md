# Colecheck Mobile — Agent Notes

## Project basics
- Flutter single-app project (`coleapp`). SDK `^3.12.2`.
- No tests or CI configured yet. Verification is `flutter analyze` + `flutter build bundle`.
- `build_runner` is required after any `@injectable` change: `dart run build_runner build`.
- `analysis_options.yaml` only includes `package:flutter_lints/flutter.yaml`.

## Entrypoints and routing
- `lib/main.dart` bootstraps DI (`configureDependencies()`), then runs `ColecheckApp`.
- Routing is manual `MaterialApp.routes`, not GoRouter. Role routes: `director/home`, `promoter/home`, `secretary/home`, `assistant/home`, `teacher/home`, `parent/home`.
- `parent/home` resolves to `lib/features/parent/presentation/home/ParentHomePage.dart`.

## Architecture (actually in use)
- README's folder tree is stale. Real layout under `features/parent/presentation/` uses PascalCase files: `home/ParentHomeContent.dart`, `reuniones/ReunionesContent.dart`, etc.
- Pattern per feature: `Content` (body widget) + `Page` (thin Scaffold wrapper) + `bloc/*Bloc.dart` + `*Event.dart` + `*State.dart`.
- Clean Architecture: `data/` (service/model/repo-impl) → `domain/` (repo interface/usecase) → `presentation/` (Bloc/Content).
- DI via `get_it` + `injectable`. Register new use cases in `lib/di/app_module.dart`, then run `build_runner`. Widgets should use `context.read<T>()`; only `main.dart`, `app_module.dart`, and `bloc_provider.dart` touch `locator`.
- `lib/bloc_provider.dart` creates global Blocs with `locator<...>()`.
- `lib/injection.config.dart` is generated — do not edit by hand.

## Backend / API conventions
- Base URL is hardcoded in `lib/core/constants/api_constants.dart` (prod by default).
- Almost every request needs header `tenant-id`. For parent flows, read tenant from the saved auth session (`session.tenant`), do not hardcode `ie-guillermo`.
- Auth is cookie-based JWT (`access_token` cookie) plus `tenant-id` header.

## Parent feature specifics
- Navigation inside `ParentHomeContent` uses `pageIndex` via `ParentHomeBloc` (`ChangePage`). Bottom nav maps 0→Inicio, 10→Comunicados, 8→Agenda, 1→Perfil.
- QuickAccessGrid items dispatch `ChangePage(pageIndex: N)`. Existing indices: 2 Fotocheck, 3 Horario, 4 Calificaciones, 5 Pensiones, 6 Cuotas, 7 Reuniones, 8 Agenda, 9 Más.
- Drawer follows initflutter pattern (source: `initflutter/lib/src/presentation/pages/client/home/ClientHomePage.dart`): inline in Scaffold, `BlocBuilder`, gradient `DrawerHeader`, sections "GENERAL" / "PREFERENCIAS" inside `Card > Column > ListTile`, logout as last tile in "PREFERENCIAS", no FAB.
- `ParentHomeBloc` loads `user` + `tenant` from session, then fetches `branch` and `students`, then daily attendance.

## Reference files
- API docs: `api/api.md`.
- Parent dashboard body layout: `parent_dashboard_vista.md` (drawer pattern is above).

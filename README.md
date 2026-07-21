# ColeApp

App móvil de Colecheck — gestión educativa para padres, auxiliares, profesores y directores.

## Estructura del proyecto

```
lib/
├── main.dart
├── injection.dart
├── injection.config.dart
├── app.dart                          # MaterialApp.router con GoRouter
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── resource.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── auth_interceptor.dart
│   │   ├── tenant_interceptor.dart
│   │   └── refresh_token_interceptor.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── auth_guard.dart
│   │   └── role_guard.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── storage/
│   │   └── secure_storage.dart
│   └── extensions/
│       └── string_ext.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_text_field.dart
│   │   ├── app_button.dart
│   │   ├── app_bar.dart
│   │   ├── loading_overlay.dart
│   │   ├── error_widget.dart
│   │   └── empty_state.dart
│   ├── utils/
│   │   ├── bloc_form_item.dart
│   │   └── validators.dart
│   └── enums/
│       └── role.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasource/...
│   │   │   ├── models/...
│   │   │   └── repositories/...
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/...
│   │   │   └── usecases/...
│   │   └── presentation/
│   │       ├── bloc/...
│   │       └── screens/...
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── dashboard_bloc.dart
│   │       └── screens/
│   │           └── dashboard_shell.dart
│   │
│   ├── notifications/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   ├── remote/
│   │   │   │   │   └── notification_remote_datasource.dart
│   │   │   │   └── local/
│   │   │   │       └── notification_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_notifications_usecase.dart
│   │   │       ├── mark_as_read_usecase.dart
│   │   │       └── subscribe_to_topic_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notification_list/
│   │       │   │   ├── notification_list_bloc.dart
│   │       │   │   ├── notification_list_event.dart
│   │       │   │   └── notification_list_state.dart
│   │       │   └── notification_badge/
│   │       │       └── notification_badge_cubit.dart
│   │       └── screens/
│   │           ├── notification_list_screen.dart
│   │           └── notification_detail_screen.dart
│   │
│   ├── parent/
│   │   ├── data/
│   │   │   └── ...
│   │   ├── domain/
│   │   │   └── ...
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── parent_home/
│   │       │   │   ├── parent_home_bloc.dart
│   │       │   │   ├── parent_home_event.dart
│   │       │   │   └── parent_home_state.dart
│   │       │   ├── grades/
│   │       │   │   ├── grades_bloc.dart
│   │       │   │   ├── grades_event.dart
│   │       │   │   └── grades_state.dart
│   │       │   └── attendance/
│   │       │       ├── attendance_bloc.dart
│   │       │       ├── attendance_event.dart
│   │       │       └── attendance_state.dart
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           ├── grades_screen.dart
│   │           ├── attendance_screen.dart
│   │           └── communication_screen.dart
│   │
│   ├── teacher/
│   │   ├── data/
│   │   │   └── ...
│   │   ├── domain/
│   │   │   └── ...
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── teacher_home/
│   │       │   │   ├── teacher_home_bloc.dart
│   │       │   │   ├── teacher_home_event.dart
│   │       │   │   └── teacher_home_state.dart
│   │       │   ├── classes/
│   │       │   │   ├── classes_bloc.dart
│   │       │   │   ├── classes_event.dart
│   │       │   │   └── classes_state.dart
│   │       │   ├── attendance/
│   │       │   │   ├── attendance_bloc.dart
│   │       │   │   ├── attendance_event.dart
│   │       │   │   └── attendance_state.dart
│   │       │   └── grades/
│   │       │       ├── grades_bloc.dart
│   │       │       ├── grades_event.dart
│   │       │       └── grades_state.dart
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           ├── classes_screen.dart
│   │           ├── attendance_screen.dart
│   │           ├── grades_screen.dart
│   │           └── communication_screen.dart
│   │
│   ├── assistant/
│   │   ├── data/
│   │   │   └── ...
│   │   ├── domain/
│   │   │   └── ...
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── attendance/
│   │       │       ├── attendance_bloc.dart
│   │       │       ├── attendance_event.dart
│   │       │       └── attendance_state.dart
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           └── attendance_screen.dart
│   │
│   ├── director/
│   │   ├── data/
│   │   │   └── ...
│   │   ├── domain/
│   │   │   └── ...
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── director_home/
│   │       │   │   ├── director_home_bloc.dart
│   │       │   │   ├── director_home_event.dart
│   │       │   │   └── director_home_state.dart
│   │       │   ├── users/
│   │       │   │   ├── users_bloc.dart
│   │       │   │   ├── users_event.dart
│   │       │   │   └── users_state.dart
│   │       │   └── reports/
│   │       │       ├── reports_bloc.dart
│   │       │       ├── reports_event.dart
│   │       │       └── reports_state.dart
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           ├── users_screen.dart
│   │           ├── reports_screen.dart
│   │           └── settings_screen.dart
│   │
│   └── fcm/
│       ├── data/
│       │   └── datasource/
│       │       └── fcm_remote_datasource.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── fcm_message.dart
│       │   └── usecases/
│       │       └── handle_fcm_message_usecase.dart
│       └── presentation/
│           └── services/
│               └── fcm_service.dart
│
├── di/
│   └── app_module.dart
│
└── bootstrap/
    └── app_bootstrap.dart
```

## Arquitectura

**Clean Architecture** en 3 capas dentro de cada feature:

```
Screen (UI) → Bloc (Estado) → UseCase (Lógica) → Repository (Contrato) → Datasource (API/BBDD)
                                                                              ↕
                                                                        Model (DTO)
```

### Ejemplo concreto: feature `parent/`

```
📁 features/parent/
├── 📁 data/                          ← Implementación concreta
│   ├── 📁 datasource/remote/         ← Llama a la API con Dio
│   │   └── grades_remote_datasource.dart
│   ├── 📁 models/                    ← DTOs que mapean el JSON de la API
│   │   └── grade_model.dart
│   └── 📁 repositories/              ← Implementa el contrato del dominio
│       └── grade_repository_impl.dart  ← Toma GradeModel → lo convierte a GradeEntity
│
├── 📁 domain/                        ← Capa pura (sin Flutter, sin APIs)
│   ├── 📁 entities/                  ← Objetos de negocio
│   │   └── grade_entity.dart
│   ├── 📁 repositories/              ← Contrato abstracto (interfaz)
│   │   └── grade_repository.dart
│   └── 📁 usecases/                  ← Lógica de negocio
│       └── get_grades_usecase.dart
│
└── 📁 presentation/                  ← UI + Estado
    ├── 📁 bloc/grades/               ← BLoC: maneja eventos y emite estados
    │   ├── grades_bloc.dart
    │   ├── grades_event.dart
    │   └── grades_state.dart
    └── 📁 screens/                   ← Pantalla: escucha el estado del BLoC
        └── grades_screen.dart
```

**Flujo cuando el padre ve sus notas:**

```
1. grades_screen.dart
   → El usuario entra a la pantalla de notas

2. grades_screen.dart
   → Dispara GradesEvent.fetched() al GradesBloc

3. grades_bloc.dart
   → Recibe el evento, llama a GetGradesUseCase

4. get_grades_usecase.dart
   → Valida datos, llama a GradeRepository (interfaz)

5. grade_repository_impl.dart
   → Llama a GradesRemoteDatasource.getGrades()

6. grades_remote_datasource.dart
   → Hace GET /api/grades con Dio, devuelve JSON

7. grade_repository_impl.dart
   → Convierte GradeModel (JSON) → GradeEntity (dominio puro)

8. grades_bloc.dart
   → Recibe List<GradeEntity>, emite GradesState.success(grades)

9. grades_screen.dart
   → Se reconstruye con los datos y los muestra
```

### Cómo se relaciona cada parte

| Capa | Rol | Lo que contiene |
|---|---|---|
| **`core/`** | Infraestructura compartida | Conexión HTTP, router con guards, tema, storage seguro |
| **`shared/`** | Componentes reutilizables | Botones, inputs, loaders, validators, enum de roles |
| **`features/*/data/`** | Implementación concreta | Datasources (API/local), modelos DTO, repositorios concretos |
| **`features/*/domain/`** | Lógica de negocio pura | Entidades, interfaces de repositorio, casos de uso |
| **`features/*/presentation/`** | UI y estado | BLoCs (eventos/estados), pantallas |
| **`features/fcm/`** | Servicio de notificaciones push | Manejo de mensajes FCM, suscripción a topics |
| **`di/`** | Cableado de dependencias | Registro de todo en GetIt (AppModule) |
| **`bootstrap/`** | Inicialización al arrancar | Firebase, SecureStorage, DI antes de runApp() |

### Reglas clave

- **`domain/` no importa nada de Flutter ni de `data/`** — solo dart puro
- **`data/` implementa los contratos de `domain/`** — el repositorio concreto mapea Models → Entities
- **El BLoC es el único que orquesta** — la screen jamás llama a un use case directamente
- **Cada rol es un feature independiente** — comparten `core/` y `shared/`, pero cada uno tiene sus propias pantallas, BLoCs y lógica de negocio
- **Las notificaciones unifican todo** — `fcm/` recibe el mensaje → `notifications/` lo persiste → el badge se actualiza desde cualquier rol

---

## Arquitectura actual (en construcción)

### Cadena de dependencias (inyección)

```
AuthService (HTTP) ─┐
                    ├→ AuthRepositoryImpl → LoginUseCase ─┐
AuthLocalStorage ───┘                                      │
                                                           ├→ AuthUseCases → LoginBloc
                    Saveuser, Logout, etc. (use cases) ────┘
```

**¿Por qué `AuthRepositoryImpl` necesita `AuthService` Y `AuthLocalStorage`?**

Porque el repositorio hace DOS tipos de trabajo:

| Trabajo | Lo hace | Con qué |
|---|---|---|
| Loguear (internet) | `login()` | `AuthService` → POST HTTP al backend |
| Guardar sesión (disco) | `saveUserSession()` | `AuthLocalStorage` → SharedPreferences |
| Recuperar sesión (disco) | `getUserSession()` | `AuthLocalStorage` → SharedPreferences |
| Cerrar sesión (disco) | `logout()` | `AuthLocalStorage` → SharedPreferences |

Si solo tuviera `AuthService` → podría loguear pero no guardar la sesión.  
Si solo tuviera `AuthLocalStorage` → podría guardar datos pero no loguear.  
**Necesita ambos.**

### Cómo se arma todo con `@injectable`

```dart
// di/app_module.dart

@module
abstract class AppModule {
  // 1. Hojas (no necesitan nada)
  @injectable
  AuthLocalStorage get authLocalStorage => AuthLocalStorage();

  @injectable
  AuthService get authService => AuthService();

  // 2. Repositorio (necesita service + storage)
  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(
    authService: authService,     // ← getIt busca AuthService registrado
    storage: authLocalStorage,    // ← getIt busca AuthLocalStorage registrado
  );

  // 3. Use cases (cada uno necesita el repositorio)
  @injectable
  LoginUseCase get loginUseCase => LoginUseCase(authRepository: authRepository);

  // 4. Mochila que agrupa todos los use cases
  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    loginUseCase: loginUseCase,
    saveuserUseCase: saveuserUseCase,
    getusersessionUseCase: getusersessionUseCase,
    removeuserUseCase: removeuserUseCase,
    logoutUseCase: logoutUseCase,
  );
}
```

**¿Qué significa `get` + `=>`?**

- `get` = getter de Dart (propiedad que devuelve algo, como una función sin `()`)
- `=>` = atajo de `{ return ...; }`
- `authService: authService` → el de la derecha es el getter de arriba, GetIt lo resuelve automáticamente
- `@injectable` = marcador para que build_runner genere el registro en GetIt

**build_runner** (`dart run build_runner build`) lee los `@injectable` y genera `injection.config.dart` con el código real.

### Cómo llega al BLoC

```dart
// bloc_provider.dart
BlocProvider<LoginBloc>(
  create: (context) {
    return LoginBloc(getIt<AuthUseCases>());
    //                ↑
    // GetIt busca AuthUseCases, que necesita todos los use cases,
    // que necesitan AuthRepository, que necesita AuthService + AuthLocalStorage
    // → construye toda la cadena automáticamente
  },
);
```

### Regla de oro: ¿dónde se usa `getIt`?

| Archivo | ¿Usa `getIt`? | ¿Por qué? |
|---|---|---|
| `main.dart` | ✅ `configureDependencies()` | Inicializa el baúl |
| `app_module.dart` | ✅ `@injectable` | Registra cosas en el baúl |
| `bloc_provider.dart` | ✅ `getIt<AuthUseCases>()` | Saca del baúl para crear BLoC |
| `login_content.dart` (widget) | ❌ | Solo `context.read<LoginBloc>()` |
| `login_bloc.dart` (BLoC) | ❌ | Recibe `AuthUseCases` por constructor |

**Los widgets nunca usan `getIt`. Solo mandan eventos al BLoC.**

### Capas

| Capa | Rol | Contiene |
|------|-----|----------|
| `data/` | Implementación concreta | Services (HTTP), Models (DTO), RepositoryImpl |
| `domain/` | Lógica de negocio pura | UseCases, Repository (interfaz), Entities |
| `presentation/` | UI y estado | Screens, Bloc (event/state) |
| `shared/` | Utilidades transversales | Widgets, BlocFormItem, validators |
| `core/` | Infraestructura base | Constantes, errores, temas |

# Plan de implementación — Login funcional

## Estado actual (v0.2.0-data-layer)

```
lib/
├── main.dart                          ← Solo splash (sin DI, sin rutas)
├── core/
│   ├── constants/api_constants.dart   ← panel.colecheck.com
│   └── errors/resource.dart           ← LoadingResource, SuccessData, ErrorData
├── shared/
│   ├── utils/session_storage.dart     ← SharedPreferences wrapper
│   └── widgets/ (campos, botones)
└── features/
    ├── splash/presentation/screens/splash_screen.dart  ← Logo animado
    └── auth/
        ├── data/
        │   ├── datasource/remote/auth_service.dart     ← HTTP con http package
        │   ├── models/ (person, profile, user, auth_response)
        │   └── repositories/auth_repository_impl.dart   ← Implementación
        └── domain/
            └── repositories/auth_repository.dart        ← Interfaz abstracta
```

**Lo que falta**: DI (injectable), BLoC, login screen, rutas, home placeholder.

---

## Paso 1 — Agregar injectable + build_runner

### Archivo: `pubspec.yaml`

Agregar bajo `dependencies:`:
```yaml
  injectable: ^2.7.0
```

Agregar bajo `dev_dependencies:`:
```yaml
  injectable_generator: ^2.12.1
  build_runner: ^2.15.0
```

Correr:
```bash
flutter pub get
```

---

## Paso 2 — Crear AppModule (registro de dependencias)

### Crear `lib/src/di/AppModule.dart`

```dart
@module
abstract class AppModule {
  @injectable
  SessionStorage get sessionStorage => SessionStorage.instance;

  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sessionStorage);
}
```

> **Nota**: Los use cases y blocs NO se registran aquí. Se crean manualmente en `blocProviders.dart` porque reciben parámetros del contexto (formKey, etc.).

---

## Paso 3 — Crear injection.dart

### Crear `lib/injection.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

Correr:
```bash
dart run build_runner build
```

Esto genera `injection.config.dart` automáticamente.

---

## Paso 4 — Crear login BLoC

### `lib/features/auth/presentation/login/bloc/LoginEvent.dart`

Eventos:
- `LoginInit()`
- `TenantChanged(String tenant)`
- `UsernameChanged(String username)`
- `PasswordChanged(String password)`
- `RememberMeChanged(bool rememberMe)`
- `FormSubmitted()`
- `SaveSession(AuthResponse)`

### `lib/features/auth/presentation/login/bloc/LoginState.dart`

Estado con Equatable:
- `tenant`, `username`, `password` (BlocFormItem con validación)
- `rememberMe` (bool)
- `formKey` (GlobalKey<FormState>)
- `response` (Resource?)

### `lib/features/auth/presentation/login/bloc/LoginBloc.dart`

Maneja eventos:
- `TenantChanged` → valida no vacío
- `UsernameChanged` → valida no vacío
- `PasswordChanged` → valida no vacío
- `RememberMeChanged` → toggle bool
- `FormSubmitted` → llama a `LoginUseCase.run(tenant, username, password)`, emite `LoadingResource`, luego `SuccessData` o `ErrorData`
- `SaveSession` → llama a `authUseCases.saveUserSession(authResponse)`

Requiere `AuthUseCases` (que agrupa login + saveSession + getUserSession + logout).

---

## Paso 5 — Crear AuthUseCases y LoginUseCase

### `lib/features/auth/domain/useCases/LoginUseCase.dart`

```dart
class LoginUseCase {
  AuthRepository repository;
  LoginUseCase(this.repository);
  Future<Resource> run(String tenant, String username, String password) =>
      repository.login(tenant, username, password);
}
```

### `lib/features/auth/domain/useCases/AuthUseCases.dart`

Fachada que agrupa:
- `login` (LoginUseCase)
- `saveUserSession` (SaveUserSessionUseCase)
- `getUserSession` (GetUserSessionUseCase)
- `logout` (LogoutUseCase)

---

## Paso 6 — Crear LoginContent + LoginPage

### `lib/features/auth/presentation/login/LoginContent.dart`

Form con:
1. Campo `Código del colegio` (tenant)
2. Campo `Usuario`
3. Campo `Contraseña` (con toggle visibilidad)
4. Checkbox `Recordar contraseña`
5. Botón `Iniciar sesión`

Cada campo dispara su evento al BLoC. El botón dispara `FormSubmitted`.

### `lib/features/auth/presentation/login/LoginPage.dart`

- `BlocListener<LoginBloc, LoginState>` que escucha el `response`
- Si `ErrorData` → muestra SnackBar
- Si `SuccessData` → navega a `'home'`

---

## Paso 7 — Crear blocProviders.dart

### `lib/blocProviders.dart`

```dart
List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(
      getIt<AuthUseCases>(),
    )..add(LoginInit()),
  ),
];
```

---

## Paso 8 — Actualizar main.dart

- Importar `configureDependencies` y llamarlo antes de `runApp`
- `MultiBlocProvider(providers: blocProviders, child: MaterialApp(...))`
- Routes: `'splash'`, `'login'`, `'home'`

```dart
initialRoute: 'splash',
routes: {
  'splash': (context) => SplashScreen(),
  'login': (context) => LoginPage(),
  'home': (context) => HomeScreen(),
},
```

---

## Paso 9 — Actualizar splash_screen.dart

Agregar navegación después de la animación (3s):
```dart
Future.delayed(Duration(seconds: 3), () {
  if (mounted) Navigator.pushReplacementNamed(context, 'login');
});
```

---

## Paso 10 — Crear HomeScreen placeholder

### `lib/features/home/presentation/screens/HomeScreen.dart`

Pantalla simple que obtiene el rol desde `SessionStorage` y muestra:
```dart
Center(child: Text('Vista $rol'))
```

---

## Resumen del flujo completo

```
SplashScreen (3s, logo animado)
    ↓ pushReplacementNamed('login')
LoginPage (BlocListener)
    ↓ FormSubmitted
LoginBloc → LoginUseCase → AuthRepository → AuthRepositoryImpl
    ↓                                               ↓
SuccessData/ErrorData                        AuthService.login()
    ↓                                               ↓
LoginPage escucha                          POST /auth/login
    ↓                                               ↓
Navigator.pushNamed('home')           AuthResponse.fromJson()
    ↓
HomeScreen("Vista ${rol}")
```

## Orden de implementación

| Paso | Archivos | Tiempo |
|------|----------|--------|
| 1 | pubspec.yaml | 2min |
| 2 | AppModule.dart | 5min |
| 3 | injection.dart + build_runner | 2min |
| 4 | LoginEvent, LoginState, LoginBloc | 15min |
| 5 | LoginUseCase, AuthUseCases + otros use cases | 10min |
| 6 | LoginContent, LoginPage | 15min |
| 7 | blocProviders.dart | 3min |
| 8 | main.dart | 5min |
| 9 | splash_screen.dart (navegación) | 2min |
| 10 | HomeScreen | 5min |
| **Total** | | **~1 hora** |

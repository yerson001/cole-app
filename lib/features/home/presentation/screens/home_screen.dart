import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/injection.dart';

final _log = Logger('HOME');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authUseCases = getIt<AuthUseCases>();
  String _rol = '';
  String _tenant = '';
  String _tokenPreview = '';

  @override
  void initState() {
    super.initState();
    _log.info('initState()');
    _loadData();
  }

  Future<void> _loadData() async {
    _log.info('Cargando datos de sesión...');
    final session = await _authUseCases.getusersessionUseCase.call();
    if (session != null) {
      final token = session.token;
      final tokenPreview = token.length > 20
          ? '${token.substring(0, 20)}...'
          : token;
      setState(() {
        _rol = session.user.profile?.type ?? 'Sin rol';
        _tenant = session.tenant;
        _tokenPreview = tokenPreview;
      });
      _log.info('rol=$_rol tenant=$_tenant token=$tokenPreview');
    } else {
      _log.info('No hay sesión guardada');
      setState(() {
        _rol = 'Sin sesión';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _log.info('build()');
    return Scaffold(
      appBar: AppBar(title: const Text('Colecheck')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Vista $_rol', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('Tenant: $_tenant'),
            if (_tokenPreview.isNotEmpty) Text('Token: $_tokenPreview'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                _log.info('Cerrando sesión...');
                await _authUseCases.logoutUseCase.call();
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeEvent.dart';

class MasContent extends StatelessWidget {
  const MasContent({super.key});

  static const _items = [
    _MasItem('Fotocheck', Icons.badge, 2),
    _MasItem('Horario', Icons.schedule, 3),
    _MasItem('Calificaciones', Icons.grade, 4),
    _MasItem('Pensiones', Icons.payments, 5),
    _MasItem('Cuotas', Icons.receipt_long, 6),
    _MasItem('Reuniones', Icons.groups, 7),
    _MasItem('Agenda', Icons.book, 8),
    _MasItem('Comunicados', Icons.campaign, 10),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
            title: Text(item.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.read<ParentHomeBloc>().add(
                ChangePage(pageIndex: item.pageIndex),
              );
            },
          ),
        );
      },
    );
  }
}

class _MasItem {
  final String name;
  final IconData icon;
  final int pageIndex;
  const _MasItem(this.name, this.icon, this.pageIndex);
}

import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class CommunicationsTab extends StatelessWidget {
  const CommunicationsTab({super.key});

  static const _communications = [
    {'title': 'Reunión de padres', 'date': '15/08/2026', 'desc': 'Reunión general en el auditorio'},
    {'title': 'Entrega de notas', 'date': '22/08/2026', 'desc': 'Segundo bimestre'},
    {'title': 'Día del logro', 'date': '05/09/2026', 'desc': 'Presentación de estudiantes'},
    {'title': 'Inicio de clases', 'date': '10/03/2026', 'desc': 'Bienvenida al año escolar'},
    {'title': 'Taller deportivo', 'date': '18/07/2026', 'desc': 'Inscripciones abiertas'},
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Card(
      color: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                labelColor: c.primary,
                unselectedLabelColor: c.textSecondary,
                indicatorColor: c.primary,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: const [
                  Tab(text: 'Comunicados'),
                  Tab(text: 'Reuniones'),
                  Tab(text: 'Agenda'),
                ],
              ),
              SizedBox(
                height: 260,
                child: TabBarView(
                  children: [
                    _buildCommunicationsList(context, c),
                    _buildPlaceholder(context, c, 'Reuniones'),
                    _buildPlaceholder(context, c, 'Agenda'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationsList(BuildContext context, AppColors c) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _communications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final com = _communications[i];
        final isRecent = i < 2;
        return Card(
          color: c.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: c.border, width: 0.5),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: isRecent ? c.errorLight.withValues(alpha: 0.3) : c.primaryLight.withValues(alpha: 0.2),
              child: Icon(Icons.campaign, color: c.primary, size: 18),
            ),
            title: Text(
              com['title']!,
              style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary, fontSize: 13),
            ),
            subtitle: Text(
              '${com['date']} — ${com['desc']}',
              style: TextStyle(color: c.textSecondary, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.chevron_right, color: c.textSecondary, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context, AppColors c, String label) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined, size: 40, color: c.textDisabled),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: c.textSecondary)),
          const SizedBox(height: 4),
          Text('Próximamente', style: TextStyle(fontSize: 12, color: c.textDisabled)),
        ],
      ),
    );
  }
}

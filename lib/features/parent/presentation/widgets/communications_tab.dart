import 'package:flutter/material.dart';

class CommunicationsTab extends StatelessWidget {
  const CommunicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Comunicados'),
                Tab(text: 'Reuniones'),
                Tab(text: 'Agenda'),
              ],
            ),
            SizedBox(
              height: 160,
              child: TabBarView(
                children: [
                  _placeholderList('No hay comunicados por ahora'),
                  _placeholderList('No hay reuniones por ahora'),
                  _placeholderList('No hay eventos en agenda'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderList(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ),
    );
  }
}

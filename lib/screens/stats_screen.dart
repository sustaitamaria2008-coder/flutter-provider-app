import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estadísticas")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Resumen de tareas",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Text(
                  "📌 Total de tareas: ${provider.totalTasks}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "✅ Completadas: ${provider.completedTasks}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "⏳ Pendientes: ${provider.pendingTasks}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Progreso:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: provider.progress,
                  minHeight: 12,
                ),

                const SizedBox(height: 10),

                Text(
                  "${(provider.progress * 100).toStringAsFixed(1)}% completado",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String filter = "Todas";
  String priority = "Normal";
  String searchText = "";

  Color getPriorityColor(String priority) {
    if (priority == "Alta") return Colors.red;
    if (priority == "Normal") return Colors.orange;
    return Colors.green;
  }

  void showEditDialog(
    BuildContext context,
    TaskProvider provider,
    int index,
    Map task,
  ) {
    final TextEditingController editController = TextEditingController(
      text: task["title"],
    );

    String editPriority = task["priority"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar tarea"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la tarea",
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: editPriority,
                items: const [
                  DropdownMenuItem(value: "Baja", child: Text("Baja")),
                  DropdownMenuItem(value: "Normal", child: Text("Normal")),
                  DropdownMenuItem(value: "Alta", child: Text("Alta")),
                ],
                onChanged: (value) {
                  setState(() {
                    editPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isEmpty) return;

                provider.editTask(
                  index,
                  editController.text.trim(),
                  editPriority,
                );

                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(
    BuildContext context,
    TaskProvider provider,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar tarea"),
          content: const Text("¿Seguro que deseas eliminar esta tarea?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                provider.removeTask(index);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of (como en el documento)
    final taskProvider = Provider.of<TaskProvider>(context);

    List<Map<String, dynamic>> filteredTasks = taskProvider.tasks;

    // filtro por estado
    if (filter == "Pendientes") {
      filteredTasks = filteredTasks
          .where((task) => task["done"] == false)
          .toList();
    } else if (filter == "Completadas") {
      filteredTasks = filteredTasks
          .where((task) => task["done"] == true)
          .toList();
    }

    // filtro por búsqueda
    if (searchText.isNotEmpty) {
      filteredTasks = filteredTasks
          .where(
            (task) =>
                task["title"].toLowerCase().contains(searchText.toLowerCase()),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestor de Tareas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              if (taskProvider.tasks.isNotEmpty) {
                taskProvider.clearAll();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // CONTADORES con Consumer (como en el documento)
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      "Total: ${provider.totalTasks} | Pendientes: ${provider.pendingTasks} | Completadas: ${provider.completedTasks}",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Barra de progreso
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: provider.progress,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${(provider.progress * 100).toStringAsFixed(1)}% completado",
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 15),

                // FILTRO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Filtro: "),
                    DropdownButton<String>(
                      value: filter,
                      items: const [
                        DropdownMenuItem(value: "Todas", child: Text("Todas")),
                        DropdownMenuItem(
                          value: "Pendientes",
                          child: Text("Pendientes"),
                        ),
                        DropdownMenuItem(
                          value: "Completadas",
                          child: Text("Completadas"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          filter = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BUSCADOR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Buscar tarea...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // FORMULARIO
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: "Nueva tarea",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: priority,
                      items: const [
                        DropdownMenuItem(value: "Baja", child: Text("Baja")),
                        DropdownMenuItem(
                          value: "Normal",
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(value: "Alta", child: Text("Alta")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_taskController.text.trim().isEmpty) return;

                        taskProvider.addTask(
                          _taskController.text.trim(),
                          priority,
                        );

                        _taskController.clear();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Agregar"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // LISTA DE TAREAS
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No hay tareas todavía 📌",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      int realIndex = taskProvider.tasks.indexOf(task);

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Container(
                            width: 12,
                            height: 50,
                            decoration: BoxDecoration(
                              color: getPriorityColor(task["priority"]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          title: Text(
                            task["title"],
                            style: TextStyle(
                              decoration: task["done"]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("Prioridad: ${task["priority"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  showEditDialog(
                                    context,
                                    taskProvider,
                                    realIndex,
                                    task,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDeleteDialog(
                                    context,
                                    taskProvider,
                                    realIndex,
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            taskProvider.toggleTask(realIndex);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

# Gestor de Tareas con Provider - Flutter

Aplicación desarrollada en Flutter que implementa **Provider** como gestor de estado.  
Permite administrar tareas con prioridades, buscarlas, editarlas, eliminarlas y visualizar estadísticas con progreso.

---

## Objetivo del proyecto

Desarrollar una aplicación en Flutter aplicando el patrón **Provider** para gestionar el estado de manera eficiente,
permitiendo la actualización automática de la interfaz cuando se modifica la lista de tareas.

---

## Capturas de la aplicación

### Pantalla principal
![Pantalla Principal](assets/screenshots/home.jpg)

### Pantalla de estadísticas
![Pantalla Estadísticas](assets/screenshots/stats.jpg)

---

## Funciones principales

- Agregar tareas con prioridad (Alta, Normal, Baja)
- Marcar tareas como completadas
- Editar tareas existentes
- Eliminar tareas con confirmación
- Buscar tareas por nombre
- Visualizar estadísticas de tareas
- Barra de progreso de tareas completadas
- Guardado automático usando SharedPreferences

---

## Implementación de Provider (según documento)

Este proyecto utiliza los conceptos principales de la librería Provider:

- **ChangeNotifier** → Clase que controla el estado de la aplicación.
- **notifyListeners()** → Notifica a la interfaz cuando existe un cambio en los datos.
- **ChangeNotifierProvider** → Comparte el estado a toda la aplicación.
- **Provider.of** → Permite acceder al provider desde los widgets para lectura y modificación.
- **Consumer** → Reconstruye automáticamente widgets específicos cuando el estado cambia.

---

## Tecnologías utilizadas

- Flutter
- Dart
- Provider
- SharedPreferences

---

## Estructura del proyecto

```txt
lib/
 ┣ providers/
 ┃ ┗ task_provider.dart
 ┣ screens/
 ┃ ┣ home_screen.dart
 ┃ ┗ stats_screen.dart
 ┗ main.dart
```
---

## Instalación y ejecución

# 1. Clonar repositorio

```bash
git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
```

# 2. Entrar al proyecto
```bash
cd TU_REPOSITORIO
```

# 3. Instalar dependencias
```bash
flutter pub get
```

# 4. Ejecutar la aplicación
```
flutter run
```

---

## Autor
Maria del Rosario Sustaita Juarez
6-A, Programacion




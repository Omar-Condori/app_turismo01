import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/user_provider.dart';
import 'upload_municipalidad_images_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _usersList = [];

  @override
  void initState() {
    super.initState();
    // Simular carga de datos
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // Simular una carga de datos desde el servidor
    await Future.delayed(const Duration(seconds: 1));
    
    // Lista de usuarios simulada
    final mockUsers = [
      {
        'id': 1,
        'name': 'Administrador',
        'email': 'admin@example.com',
        'role': 'Admin',
        'status': 'Activo',
        'lastLogin': '2023-06-15 10:30:45',
      },
      {
        'id': 2,
        'name': 'Juan Pérez',
        'email': 'juan.perez@gmail.com',
        'role': 'Usuario',
        'status': 'Activo',
        'lastLogin': '2023-06-14 08:15:22',
      },
      {
        'id': 3,
        'name': 'María García',
        'email': 'maria.garcia@hotmail.com',
        'role': 'Usuario',
        'status': 'Activo',
        'lastLogin': '2023-06-13 14:45:10',
      },
      {
        'id': 4,
        'name': 'Carlos López',
        'email': 'carlos.lopez@outlook.com',
        'role': 'Emprendedor',
        'status': 'Inactivo',
        'lastLogin': '2023-06-10 11:20:30',
      },
      {
        'id': 5,
        'name': 'Ana Martínez',
        'email': 'ana.martinez@gmail.com',
        'role': 'Emprendedor',
        'status': 'Activo',
        'lastLogin': '2023-06-12 16:35:55',
      },
    ];
    
    setState(() {
      _usersList.addAll(mockUsers);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Verificar si el usuario es administrador
    if (!userProvider.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Acceso Denegado'),
        ),
        body: const Center(
          child: Text('No tienes permisos para acceder a esta sección.'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
      ),
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFF4F455),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard('Usuarios', '${_usersList.length}', Icons.people, Colors.blue),
                            _buildStatCard('Activos', '${_usersList.where((u) => u['status'] == 'Activo').length}', Icons.check_circle, Colors.green),
                            _buildStatCard('Inactivos', '${_usersList.where((u) => u['status'] == 'Inactivo').length}', Icons.cancel, Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Agregar accesos rápidos
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Accesos Rápidos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAccessButton(
                          context,
                          'Subir Imágenes',
                          Icons.photo_camera,
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UploadMunicipalidadImagesScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickAccessButton(
                          context,
                          'Gestionar Eventos',
                          Icons.event,
                          Colors.purple,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función no disponible aún')),
                            );
                          },
                        ),
                        _buildQuickAccessButton(
                          context,
                          'Reservas',
                          Icons.calendar_today,
                          Colors.green,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función no disponible aún')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Usuarios registrados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _usersList.length,
                  itemBuilder: (context, index) {
                    final user = _usersList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFF4F455),
                          child: Text(
                            user['name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(user['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email']),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: user['role'] == 'Admin' ? Colors.purple[100] : 
                                           user['role'] == 'Emprendedor' ? Colors.amber[100] : Colors.blue[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user['role'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: user['role'] == 'Admin' ? Colors.purple[800] : 
                                             user['role'] == 'Emprendedor' ? Colors.amber[800] : Colors.blue[800],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: user['status'] == 'Activo' ? Colors.green[100] : Colors.red[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: user['status'] == 'Activo' ? Colors.green[800] : Colors.red[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showUserOptions(context, user);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF4F455),
        foregroundColor: Colors.black,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función para agregar usuario no disponible aún'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
  
  Widget _buildQuickAccessButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserOptions(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Ver detalles'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función no disponible aún'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar usuario'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función no disponible aún'),
                    ),
                  );
                },
              ),
              if (user['status'] == 'Activo')
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text('Desactivar usuario', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función no disponible aún'),
                      ),
                    );
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text('Activar usuario', style: TextStyle(color: Colors.green)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función no disponible aún'),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
} 
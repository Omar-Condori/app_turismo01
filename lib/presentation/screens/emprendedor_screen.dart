// lib/presentation/screens/emprendedor_screen.dart
import 'package:flutter/material.dart';
import '../../data/models/emprendedor_model.dart';
import '../viewmodels/main_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'emprendedor_detalle_screen.dart';

class EmprendedorScreen extends StatefulWidget {
  const EmprendedorScreen({Key? key}) : super(key: key);

  @override
  State<EmprendedorScreen> createState() => _EmprendedorScreenState();
}

class _EmprendedorScreenState extends State<EmprendedorScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos los emprendedores al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MainPageViewModel>(context, listen: false).loadEmprendedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprendedores'),
        backgroundColor: const Color(0xFFF4F455), // Color amarillo claro
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5DC), // Color beige claro
      body: Consumer<MainPageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF4F455), // Color amarillo claro
              ),
            );
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${viewModel.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadEmprendedores(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F455), // Color amarillo claro
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.emprendedores.length,
            itemBuilder: (context, index) {
              final emprendedor = viewModel.emprendedores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    emprendedor.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (emprendedor.rubro != null)
                        Text('Rubro: ${emprendedor.rubro}'),
                      if (emprendedor.telefono != null)
                        Text('Teléfono: ${emprendedor.telefono}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFF4F455)),
                  onTap: () {
                    // Navegar a la pantalla de detalle
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmprendedorDetalleScreen(emprendedor: emprendedor),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
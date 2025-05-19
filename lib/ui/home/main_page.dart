import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/main_page_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MainPageViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capachica',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Carga inicial de emprendedores al iniciar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainPageViewModel>().loadEmprendedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainPageViewModel>();

    final pages = <Widget>[
      const HomeContent(),
      const Center(child: Text('Explorar', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Favoritos', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Perfil', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capachica'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Registrarse', style: TextStyle(color: Colors.black)),
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[vm.currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentPageIndex,
        onTap: vm.setCurrentPageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),     label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.explore),  label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person),   label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainPageViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text('Error: \${vm.error}'));
    }

    final emprendedores = vm.emprendedores;
    if (emprendedores.isEmpty) {
      return const Center(child: Text('No hay emprendedores para mostrar'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emprendedores.length,
      itemBuilder: (context, i) {
        final e = emprendedores[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: e.imagen != null && e.imagen!.isNotEmpty
                  ? NetworkImage(e.imagen!)
                  : null,
              child: (e.imagen == null || e.imagen!.isEmpty) ? const Icon(Icons.person) : null,
            ),
            title: Text(e.nombre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (e.rubro.isNotEmpty) Text('Rubro: 	${e.rubro}'),
                if (e.telefono.isNotEmpty) Text('Teléfono: ${e.telefono}'),
                if (e.email != null && e.email!.isNotEmpty) Text('Email: ${e.email}'),
                if (e.direccion != null && e.direccion!.isNotEmpty) Text('Dirección: ${e.direccion}'),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Acciones al tocar un emprendedor
            },
          ),
        );
      },
    );
  }
}
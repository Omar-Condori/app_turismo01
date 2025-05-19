import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/providers/user_provider.dart';
import '../admin/admin_panel_screen.dart';
import '../pages/emprendimientos_page.dart';
import '../pages/eventos_page.dart';
import '../pages/inicio_page.dart';
import '../pages/mis_reservas_page.dart';
import '../pages/planes_page.dart';
import '../pages/servicios_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _primaryImagePath;
  String? _secondaryImagePath;
  String? _logoImagePath; // Nueva variable para la imagen del logo

  static final List<Widget> _widgetOptions = <Widget>[
    const InicioPage(),
    const EmprendimientosPage(),
    const ServiciosPage(),
    const EventosPage(),
    const PlanesPage(),
    const MisReservasPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Función para simular la selección de imagen (puedes integrar image_picker aquí)
  void _selectImage(bool isPrimary) {
    // Aquí puedes implementar la lógica de image_picker
    setState(() {
      if (isPrimary) {
        _primaryImagePath = 'assets/images/foto01.png'; // Imagen de ejemplo
      } else {
        _secondaryImagePath = 'assets/images/foto02.png'; // Imagen de ejemplo
      }
    });
  }

  // Nueva función para seleccionar imagen del logo
  void _selectLogoImage() {
    // Aquí puedes implementar la lógica de image_picker para el logo
    setState(() {
      _logoImagePath = 'assets/images/logo.png'; // Imagen de ejemplo
    });
  }

  @override
  void initState() {
    super.initState();
    // Inicializar las imágenes al cargar la pantalla
    _primaryImagePath = 'assets/images/foto1.jpg';
    _secondaryImagePath = 'assets/images/foto2.jpg';
    _logoImagePath = 'assets/images/logo.png';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Definir colores según el tema
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA);
    final cardBackgroundColor = themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = themeProvider.isDarkMode ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: _buildDrawer(context, themeProvider, userProvider, textColor, subtitleColor),
      body: SafeArea(
        child: Column(
          children: [
            // Header personalizado
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Icono de menú hamburguesa
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.menu,
                          color: textColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Saludo y bienvenida
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capachica, ${userProvider.user?.name ?? 'Travel'}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          '"¡Bienvenidos a Capachica, Paraíso Turístico del Lago Titicaca!"',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón de perfil con imagen circular
                  GestureDetector(
                    onTap: _selectLogoImage,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: _logoImagePath != null
                          ? AssetImage(_logoImagePath!)
                          : const AssetImage('assets/images/logo.png'),
                      backgroundColor: const Color(0xFFF4F455),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Barra de búsqueda
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: subtitleColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Botón de tema (día/noche) reemplazando el filtro
                  GestureDetector(
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Título principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select your next trip',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Chips de categorías
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('Asia', false, themeProvider.isDarkMode),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Europe', false, themeProvider.isDarkMode),
                  const SizedBox(width: 12),
                  _buildCategoryChip('South America', true, themeProvider.isDarkMode),
                  const SizedBox(width: 12),
                  _buildCategoryChip('North America', false, themeProvider.isDarkMode),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Cartas apiladas de destinos
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Segunda carta (carta de fondo)
                        Positioned(
                          top: 20,
                          left: 10,
                          right: -10,
                          bottom: 100,
                          child: GestureDetector(
                            onTap: () => _selectImage(false),
                            child: _buildTripCard(
                              'Colombia',
                              'Bogotá',
                              4.2,
                              89,
                              _secondaryImagePath,
                              Colors.orange.shade400,
                              false,
                              themeProvider.isDarkMode,
                            ),
                          ),
                        ),

                        // Primera carta (carta principal)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 120,
                          child: GestureDetector(
                            onTap: () => _selectImage(true),
                            child: _buildTripCard(
                              'Llachon',
                              'Lgo titicaca',
                              5.0,
                              143,
                              _primaryImagePath,
                              Colors.blue.shade400,
                              true,
                              themeProvider.isDarkMode,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar rediseñado
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 0),
            _buildBottomNavItem(Icons.credit_card, 1),
            _buildBottomNavItem(Icons.favorite_outline, 2),
            _buildBottomNavItem(Icons.apps, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeProvider themeProvider, UserProvider userProvider, Color textColor, Color subtitleColor) {
    return Drawer(
      backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      child: Column(
        children: [
          // Header del drawer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : Colors.blue.shade600,
                  themeProvider.isDarkMode ? const Color(0xFF3D3D3D) : Colors.blue.shade800,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: _logoImagePath != null
                      ? AssetImage(_logoImagePath!)
                      : const AssetImage('assets/images/logo.png'),
                  backgroundColor: const Color(0xFFF4F455),
                  child: _logoImagePath == null
                      ? Text(
                    userProvider.user?.name?.isNotEmpty == true
                        ? userProvider.user!.name[0].toUpperCase()
                        : 'V',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userProvider.user?.name ?? 'Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userProvider.user?.email ?? 'capachica@travel.com',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Botón de inicio de sesión (solo visible cuando no hay usuario autenticado)
                if (userProvider.user == null)
                  _buildDrawerItem(
                    icon: Icons.login,
                    title: 'Iniciar Sesión',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    textColor: textColor,
                    themeProvider: themeProvider,
                  ),

                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Inicio',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
                _buildDrawerItem(
                  icon: Icons.business,
                  title: 'Emprendimientos',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
                _buildDrawerItem(
                  icon: Icons.room_service,
                  title: 'Servicios',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
                _buildDrawerItem(
                  icon: Icons.event,
                  title: 'Eventos',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
                _buildDrawerItem(
                  icon: Icons.payment,
                  title: 'Planes',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    _onItemTapped(4);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
                _buildDrawerItem(
                  icon: Icons.book_online,
                  title: 'Mis Reservas',
                  isSelected: _selectedIndex == 5,
                  onTap: () {
                    _onItemTapped(5);
                    Navigator.pop(context);
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),

                const Divider(),

                // Panel de administración (comentado hasta que agregues isAdmin al UserModel)
                // Puedes descomentar esto cuando agregues la propiedad isAdmin al UserModel
                /*
                if (userProvider.user?.isAdmin == true)
                  _buildDrawerItem(
                    icon: Icons.admin_panel_settings,
                    title: 'Panel de Admin',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelScreen(),
                        ),
                      );
                    },
                    textColor: textColor,
                    themeProvider: themeProvider,
                  ),
                */

                // Opción temporal de admin panel (siempre visible)
                _buildDrawerItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Panel de Admin',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPanelScreen(),
                      ),
                    );
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),

                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Configuración',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    // Navegar a configuración
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),

                _buildDrawerItem(
                  icon: themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  title: themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                  isSelected: false,
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),

                _buildDrawerItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    // Mostrar información de la app
                  },
                  textColor: textColor,
                  themeProvider: themeProvider,
                ),
              ],
            ),
          ),

          // Footer del drawer
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Capachica Travel v1.0',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // Lógica de logout
                    userProvider.logout();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textColor,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? (themeProvider.isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600)
            : textColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? (themeProvider.isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600)
              : textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: themeProvider.isDarkMode
          ? Colors.blue.shade900.withOpacity(0.2)
          : Colors.blue.shade50,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDarkMode ? Colors.white : Colors.black)
            : (isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? (isDarkMode ? Colors.black : Colors.white)
              : (isDarkMode ? Colors.white70 : Colors.black54),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTripCard(String country, String city, double rating, int reviews,
      String? imagePath, Color gradientColor, bool isPrimary, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isPrimary ? 0.2 : 0.1),
            blurRadius: isPrimary ? 15 : 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: imagePath == null
                  ? [
                gradientColor.withOpacity(0.8),
                gradientColor.withOpacity(0.6),
              ]
                  : [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Imagen de fondo
              if (imagePath != null)
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              gradientColor.withOpacity(0.8),
                              gradientColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Botón de favorito
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),

              // Contenido inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // País y ciudad
                      Text(
                        country,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        city,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Rating y reviews
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '$reviews reviews',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Botón "See more" y flecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Text(
                              'See more',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
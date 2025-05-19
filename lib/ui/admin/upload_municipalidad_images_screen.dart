import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/api_provider.dart';

class UploadMunicipalidadImagesScreen extends StatefulWidget {
  const UploadMunicipalidadImagesScreen({super.key});

  @override
  State<UploadMunicipalidadImagesScreen> createState() => _UploadMunicipalidadImagesScreenState();
}

class _UploadMunicipalidadImagesScreenState extends State<UploadMunicipalidadImagesScreen> {
  final ApiProvider _apiProvider = ApiProvider();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final List<XFile> _selectedImages = [];
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al seleccionar imágenes: ${e.toString()}');
    }
  }
  
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _selectedImages.add(photo);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al tomar foto: ${e.toString()}');
    }
  }
  
  void _removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _selectedImages.removeAt(index);
      });
    }
  }
  
  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      _showErrorSnackBar('Selecciona al menos una imagen');
      return;
    }
    
    if (_tituloController.text.trim().isEmpty) {
      _showErrorSnackBar('Ingresa un título para las imágenes');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulamos la carga exitosa
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _selectedImages.clear();
          _tituloController.clear();
          _descripcionController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imágenes cargadas exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Error al cargar imágenes: ${e.toString()}');
      }
    }
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    if (!userProvider.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Acceso Denegado'),
        ),
        body: const Center(
          child: Text('No tienes permisos para acceder a esta sección'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Imágenes de Municipalidad'),
      ),
      body: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Subiendo imágenes...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subir Imágenes de la Municipalidad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Formulario
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  
                  // Botones para seleccionar imágenes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Seleccionar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Tomar Foto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Mostrar imágenes seleccionadas
                  if (_selectedImages.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Imágenes seleccionadas:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón de carga
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _uploadImages,
                        icon: const Icon(Icons.cloud_upload),
                        label: Text('Subir ${_selectedImages.length} ${_selectedImages.length == 1 ? 'imagen' : 'imágenes'}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No hay imágenes seleccionadas',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Selecciona imágenes o toma fotos para subirlas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
} 
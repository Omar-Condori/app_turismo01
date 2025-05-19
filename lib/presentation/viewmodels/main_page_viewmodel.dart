// lib/presentation/viewmodels/main_page_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../data/providers/api_provider.dart';
import '../../data/models/emprendedor_model.dart';
import '../../data/models/api_response_model.dart';

class MainPageViewModel extends ChangeNotifier {
  final ApiProvider _api = ApiProvider();

  bool isLoading = false;
  String? error;
  List<Emprendedor> emprendedores = [];

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  void setCurrentPageIndex(int index) {
    if (_currentPageIndex != index) {
      _currentPageIndex = index;
      notifyListeners();
      if (index == 0) {
        loadEmprendedores();
      }
    }
  }

  Future<void> loadEmprendedores() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final ApiResponse<List<Emprendedor>> resp = await _api.getEmprendedores();

    if (resp.success && resp.data != null) {
      emprendedores = resp.data!;
    } else {
      error = resp.message;
    }

    isLoading = false;
    notifyListeners();
  }
}
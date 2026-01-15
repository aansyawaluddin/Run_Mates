import 'package:flutter/material.dart';
import 'package:runmates/models/tips_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TipsProvider extends ChangeNotifier {

  bool _isLoading = false;
  List<TipsModel> _tips = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<TipsModel> get tips => _tips;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTips() async {
    try {
      _isLoading = true;
      _errorMessage = null; 
      notifyListeners();

      final response = await Supabase.instance.client
          .schema('runmates')
          .from('tips')
          .select()
          .order('id', ascending: true);

      final List<dynamic> data = response;
      _tips = data.map((json) => TipsModel.fromJson(json)).toList();

    } catch (e) {
      _errorMessage = 'Gagal memuat tips: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
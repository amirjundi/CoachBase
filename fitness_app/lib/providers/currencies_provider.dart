import 'package:flutter/foundation.dart';
import '../models/currency.dart';
import '../services/currency_service.dart';

class CurrenciesProvider with ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  List<Currency> _currencies = [];
  bool _isLoading = false;
  String? _error;

  List<Currency> get currencies => _currencies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Currency? get defaultCurrency {
    try {
      return _currencies.firstWhere((c) => c.isDefault);
    } catch (_) {
      return _currencies.isNotEmpty ? _currencies.first : null;
    }
  }

  Future<void> loadCurrencies(int trainerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currencies = await _currencyService.getAllByTrainer(trainerId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Currency?> createCurrency(Currency currency) async {
    _error = null;

    try {
      final newCurrency = await _currencyService.create(currency);
      _currencies.add(newCurrency);
      _currencies.sort((a, b) {
        if (a.isDefault) return -1;
        if (b.isDefault) return 1;
        return a.name.compareTo(b.name);
      });
      notifyListeners();
      return newCurrency;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateCurrency(Currency currency) async {
    _error = null;

    try {
      await _currencyService.update(currency);
      final index = _currencies.indexWhere((c) => c.id == currency.id);
      if (index != -1) {
        _currencies[index] = currency;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCurrency(int id) async {
    _error = null;

    try {
      final canDelete = await _currencyService.canDelete(id);
      if (!canDelete) {
        _error = 'لا يمكن حذف عملة مستخدمة في اشتراكات';
        notifyListeners();
        return false;
      }

      await _currencyService.delete(id);
      _currencies.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setDefault(int trainerId, int currencyId) async {
    _error = null;

    try {
      await _currencyService.setDefault(trainerId, currencyId);
      _currencies = _currencies.map((c) {
        return c.copyWith(isDefault: c.id == currencyId);
      }).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Currency? getById(int? id) {
    if (id == null) return null;
    try {
      return _currencies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

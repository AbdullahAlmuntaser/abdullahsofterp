import 'package:flutter/material.dart';
import 'package:supermarket/core/services/asset_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:drift/drift.dart' show Insertable;

class AssetProvider with ChangeNotifier {
  final AssetService _service;
  List<FixedAsset> _assets = [];
  bool _isLoading = false;
  String? _error;

  AssetProvider(this._service);

  List<FixedAsset> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAssets(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _assets = await _service.getAllAssets();
    } catch (e) {
      _error = l10n.failedToLoadAssets(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAsset(BuildContext context, Insertable<FixedAsset> asset) async {
    final l10n = AppLocalizations.of(context)!;
    _error = null;
    try {
      await _service.addAsset(asset);
      if (context.mounted) await loadAssets(context);
      return true;
    } catch (e) {
      _error = l10n.failedToAddAsset(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAsset(BuildContext context, Insertable<FixedAsset> asset) async {
    final l10n = AppLocalizations.of(context)!;
    _error = null;
    try {
      await _service.updateAsset(asset);
      if (context.mounted) await loadAssets(context);
      return true;
    } catch (e) {
      _error = l10n.failedToUpdateAsset(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> runDepreciation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.processDepreciation();
      if (context.mounted) await loadAssets(context);
      return true;
    } catch (e) {
      _error = l10n.failedToCalculateDepreciation(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

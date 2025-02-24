import 'package:firefly_user/models/building.dart';
import 'package:flutter/material.dart';

class BuildingProvider extends ChangeNotifier {
  Building? _building;

  Building? get building => _building;

  void setBuilding(Building building) {
    _building = building;
    notifyListeners();
  }
}

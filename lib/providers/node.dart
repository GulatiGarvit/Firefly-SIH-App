import 'package:firefly_user/models/node.dart';
import 'package:flutter/material.dart';

class NodeProvider extends ChangeNotifier {
  Map<int, Node> _nodes = {};

  Map<int, Node> get nodes => _nodes;

  void setNodes(Map<int, Node> nodes) {
    _nodes = nodes;
    notifyListeners();
  }
}

import 'package:flutter/widgets.dart';

class UERenderNode {
  final String type;
  final String description;
  final RenderObject? renderObject;
  final List<UERenderNode> children;

  UERenderNode({
    required this.type,
    required this.description,
    required this.renderObject,
    required this.children,
  });

  @override
  String toString() {
    return 'UERenderNode(type: $type, description: $description, children: $children)';
  }

  // Convert RenderNode to a Map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'children': children.map((child) => child.toMap()).toList(),
    };
  }

  // Create RenderNode from a Map
  factory UERenderNode.fromMap(Map<String, dynamic> map) {
    return UERenderNode(
      type: map['type'] as String,
      description: map['description'] as String,
      renderObject: null, // RenderObject can't be reconstructed from Map
      children: (map['children'] as List<dynamic>)
          .map((child) => UERenderNode.fromMap(child as Map<String, dynamic>))
          .toList(),
    );
  }
}

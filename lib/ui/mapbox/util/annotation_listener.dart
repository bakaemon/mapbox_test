import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CircleAnnotationListener implements OnCircleAnnotationClickListener {
  CircleAnnotationListener(this.listener);

  final void Function(CircleAnnotation) listener;
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) => listener;
}

class DeleteCircleAnnotationListener
    implements OnCircleAnnotationClickListener {
  DeleteCircleAnnotationListener(this.manager, {this.onDeleted});

  final CircleAnnotationManager manager;

  final void Function(CircleAnnotation)? onDeleted;

  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    debugPrint('DeleteCircleAnnotationListener called on ${annotation.id}');
    manager.delete(annotation);
    onDeleted?.call(annotation);
  }
}

class PointAnnotationListener implements OnPointAnnotationClickListener {
  PointAnnotationListener(this.listener);

  final void Function(PointAnnotation) listener;
  @override
  void onPointAnnotationClick(PointAnnotation annotation) => listener;
}

class DeletePointAnnotationListener
    implements OnPointAnnotationClickListener {
  DeletePointAnnotationListener(this.manager, {this.onDeleted});

  final PointAnnotationManager manager;

  final void Function(PointAnnotation)? onDeleted;

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    debugPrint('DeletePointAnnotationListener called on ${annotation.id}');
    manager.delete(annotation);
    onDeleted?.call(annotation);
  }
}
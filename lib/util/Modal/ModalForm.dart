import 'package:flutter/material.dart';

abstract class ModalForm<T> implements Widget {
  T data([bool destroy = false]);
  String name();
  String initialName();
  Future<List<String>> validationErrors(T subject);
  Future<T> postProcess(T subject);
  final String title = "";
  final String acceptText = "";
  final bool showDelete = false;
  final bool showCancel = false;
}

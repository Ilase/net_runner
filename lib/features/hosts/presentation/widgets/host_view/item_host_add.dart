import 'package:flutter/material.dart';

class HostItem {
  String? name;
  String ip;
  String? description;
  TextEditingController? nameController;
  TextEditingController? descriptionController;

  HostItem(
    this.ip, {
    this.name,
    this.description,
  });
}

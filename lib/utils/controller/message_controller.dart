import 'package:flutter/material.dart';

class MessageController {
  final BuildContext _context;

  MessageController.from(this._context);

  void showSnackbar(String text) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}

class SnackAction {
  final String title;

  final VoidCallback onAction;

  SnackAction(this.title, this.onAction);
}

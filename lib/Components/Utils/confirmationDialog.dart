import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? titulo;
  final String message;
  final VoidCallback onAccept;
  final String onAcceptMessage;
  final VoidCallback? onCancel;
  final String? onCancelMessage;
  final IconData? icon;


  ConfirmationDialog({
    this.titulo,  
    required this.message,  
    required this.onAccept,
    required this.onAcceptMessage,
    this.onCancel,
    this.onCancelMessage,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo ?? ''),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if(icon != null)
            Icon(icon, size: 55,)
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: Text(onCancelMessage ?? ''),
        ),
        TextButton(
          onPressed: onAccept,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(onAcceptMessage),
        ),
      ],
    );
  }
}



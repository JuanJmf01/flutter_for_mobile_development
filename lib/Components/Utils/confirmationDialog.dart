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
          if (icon != null)
            Icon(
              icon,
              size: 55,
            )
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

class DeletedDialog extends StatelessWidget {
  const DeletedDialog(
      {super.key, required this.onPress, required this.objectToDelete});

  final VoidCallback onPress;
  final String objectToDelete;

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      titulo: 'Advertencia',
      message: '¿Seguro que deseas eliminar $objectToDelete?',
      onAcceptMessage: 'Aceptar',
      onCancelMessage: 'Cancelar',
      onAccept: onPress,
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class RuleOut extends StatelessWidget {
  const RuleOut(
      {super.key, required this.onPress, required this.objectToDelete});

  final VoidCallback onPress;
  final String objectToDelete;

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      titulo: 'Advertencia',
      message: '¿Seguro que deseas descartar $objectToDelete?',
      onAcceptMessage: 'Aceptar',
      onCancelMessage: 'Cancelar',
      onAccept: onPress,
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class ExitWithoutSavingChanges extends StatelessWidget {
  const ExitWithoutSavingChanges({super.key, required this.onPress});

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      titulo: 'Advertencia',
      message: '¿Seguro que deseas salir sin guardar cambios?',
      onAcceptMessage: 'Aceptar',
      onCancelMessage: 'Cancelar',
      onAccept: onPress,
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}

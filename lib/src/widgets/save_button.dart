import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;

  SaveButton({required this.isSaving, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isSaving ? null : onSave,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: isSaving ? Colors.grey : Colors.green,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 20),
            Text(isSaving ? "loading..." : 'Save Changes',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void createSettingsSelectionDialog<T>({
  required BuildContext context,
  required String title,
  required T currentSelectedValue,
  required List<T> selections,
  required Function(T? newValue) onValueSelected,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          T selection = currentSelectedValue;
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: selections
                  .map(
                    (e) => ListTile(
                      leading: Radio(
                        value: e,
                        groupValue: selection,
                        onChanged: (value) {
                          setState(() {
                            selection = value ?? currentSelectedValue;
                          });
                          onValueSelected(value);
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Text(e.toString()),
                    ),
                  )
                  .toList(),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          );
        },
      );
    },
  );
}

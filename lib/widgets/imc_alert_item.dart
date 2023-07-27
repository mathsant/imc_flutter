import 'package:flutter/material.dart';

class ImcAlertItem extends StatelessWidget {
  const ImcAlertItem({
    super.key,
    required this.valorImc,
    required this.titleText,
    required this.iconTrailing,
  });

  final double valorImc;
  final String titleText;
  final Widget iconTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconTrailing,
      tileColor: Colors.grey.withOpacity(
        0.2,
      ),
      title: Text(
        titleText,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.lightBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(valorImc.toString(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          )),
    );
  }
}

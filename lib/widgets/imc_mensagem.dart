import 'package:atividade_ebac_imc/models/imc_model.dart';
import 'package:flutter/material.dart';

class ImcMensagem extends StatelessWidget {
  const ImcMensagem({
    super.key,
    required this.imcModel,
  });

  final IMC imcModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Text(
        imcModel.mensagem,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}

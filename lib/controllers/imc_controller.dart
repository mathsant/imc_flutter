import 'package:atividade_ebac_imc/models/imc_model.dart';
import 'package:flutter/material.dart';

class ImcController {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  double resultadoImc = 0;

  ValueNotifier<bool> botaoProcessar = ValueNotifier(false);

  ImcController() {
    pesoController.addListener(() {
      _habilitarBotao();
    });

    alturaController.addListener(() {
      _habilitarBotao();
    });
  }

  void _habilitarBotao() {
    botaoProcessar.value = pesoController.value.text.isNotEmpty &&
        alturaController.value.text.isNotEmpty;
  }

  IMC processarIMC() {
    resultadoImc = double.tryParse(_calcularImc().toStringAsFixed(2)) as double;

    if (resultadoImc == -999) {
      return IMC(0, 0, "");
    }

    var msgImc = _obterMensagemIMC(resultadoImc);
    var pesoValorFormatted =
        double.parse(pesoController.value.text.replaceAll(",", "."));
    var alturaValorFormatted =
        double.parse(alturaController.value.text.replaceAll(",", "."));

    IMC imcModel = IMC(
      alturaValorFormatted,
      pesoValorFormatted,
      msgImc,
    );

    return imcModel;
  }

  double _calcularImc() {
    try {
      var pesoIMC = double.parse(
        pesoController.value.text.replaceAll(",", "."),
      );
      var alturaIMC = double.parse(
        alturaController.value.text.replaceAll(",", "."),
      );

      double valorImc = pesoIMC / (alturaIMC * alturaIMC);
      return valorImc;
    } catch (e) {
      return -999;
    }
  }

  String _obterMensagemIMC(double imcValor) {
    if (imcValor < 16) {
      return "Magreza grave";
    } else if (imcValor >= 16 && imcValor < 17) {
      return "Magreza moderada";
    } else if (imcValor >= 17 && imcValor < 18.5) {
      return "Magreza leve";
    } else if (imcValor >= 18.5 && imcValor < 25) {
      return "Saudável";
    } else if (imcValor >= 25 && imcValor < 30) {
      return "Sobrepeso";
    } else if (imcValor >= 30 && imcValor < 35) {
      return "Obesidade Grau I";
    } else if (imcValor >= 35 && imcValor < 40) {
      return "Obesidade Grau II (severa)";
    } else {
      return "Obesidade Grau III (mórbida)";
    }
  }
}

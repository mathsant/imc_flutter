import 'package:atividade_ebac_imc/controllers/imc_controller.dart';
import 'package:atividade_ebac_imc/models/imc_model.dart';
import 'package:atividade_ebac_imc/widgets/alert_title.dart';
import 'package:atividade_ebac_imc/widgets/imc_alert_item.dart';
import 'package:atividade_ebac_imc/widgets/imc_mensagem.dart';
import 'package:flutter/material.dart';

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 500);

  ImcController imcController = ImcController();

  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Size> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _animationController.addListener(() async {
      if (_animationController.status == AnimationStatus.completed) {
        await Future.delayed(_duration);
        _animationController.reverse();
        await Future.delayed(_duration);
        // ignore: use_build_context_synchronously
        callShowDialog(context);
      }
    });

    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ).animate(_animationController);

    _sizeAnimation = Tween(
      begin: const Size(0, 0),
      end: const Size(250, 250),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    imcController.pesoController.dispose();
    imcController.alturaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMC"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: imcController.alturaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        labelText: "Altura",
                        suffixIcon: Icon(Icons.accessibility_new_outlined),
                        hintText: "Informe sua altura",
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: imcController.pesoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: "Peso",
                        hintText: "Informe seu peso",
                        suffixIcon: Icon(Icons.line_weight),
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: ValueListenableBuilder<bool>(
                  valueListenable: imcController.botaoProcessar,
                  builder: (context, value, _) {
                    return ElevatedButton(
                      onPressed: !value
                          ? null
                          : () {
                              _animationController.forward();
                            },
                      child: const Text("Calcular"),
                    );
                  },
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: _alignmentAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    width: _sizeAnimation.value.width,
                    height: _sizeAnimation.value.height,
                    child:
                        // Lottie.network(
                        //   'https://lottie.host/fd55acce-6c71-4bd4-8833-17dcb0acffbe/aXoOAD4lhe.json',
                        // ),
                        Icon(
                      Icons.check,
                      size: _sizeAnimation.value.width,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> callShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        IMC imcModel = imcController.processarIMC();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          titlePadding: const EdgeInsets.symmetric(horizontal: 0),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          title: const AlertTitle(
            title: "Resultado IMC",
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          content: imcController.resultadoImc != -999
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImcAlertItem(
                      iconTrailing: const Icon(
                        Icons.line_weight,
                        size: 30,
                        color: Colors.lightBlue,
                      ),
                      titleText: "Peso",
                      valorImc: imcModel.peso,
                    ),
                    ImcAlertItem(
                      iconTrailing: const Icon(
                        Icons.accessibility_new_outlined,
                        size: 30,
                        color: Colors.lightBlue,
                      ),
                      titleText: "Altura",
                      valorImc: imcModel.altura,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      iconTrailing: const Icon(
                        Icons.show_chart,
                        size: 30,
                        color: Colors.lightBlue,
                      ),
                      titleText: "Resultado",
                      valorImc: imcController.resultadoImc,
                    ),
                    ImcMensagem(imcModel: imcModel),
                  ],
                )
              : const Center(
                  heightFactor: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Text(
                          "Dados incorretos!",
                        ),
                      ),
                    ],
                  ),
                ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.lightBlue.withOpacity(0.3),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Icon(Icons.close),
            ),
          ],
        );
      },
    );
  }
}
